"use strict";
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

// infrastructure/terraform/lambda/build-notification-formatter/index.ts
var index_exports = {};
__export(index_exports, {
  handler: () => handler
});
module.exports = __toCommonJS(index_exports);
var import_client_sns = require("@aws-sdk/client-sns");
var sns = new import_client_sns.SNSClient({});
var TOPIC_ARN = process.env.SNS_TOPIC_ARN;
var APP_URL = process.env.APP_URL ?? "";
var GITHUB_REPO_URL = process.env.GITHUB_REPO_URL ?? "";
function statusIcon(status) {
  switch (status) {
    case "SUCCEEDED":
      return "\u2705";
    case "FAILED":
      return "\u274C";
    default:
      return "\u26A0\uFE0F";
  }
}
function formatDuration(phases) {
  const totalSeconds = phases.reduce((sum, p) => sum + (p["duration-in-seconds"] ?? 0), 0);
  const mins = Math.floor(totalSeconds / 60);
  const secs = Math.round(totalSeconds % 60);
  return mins > 0 ? `${mins}m ${secs}s` : `${secs}s`;
}
function formatPhaseTable(phases) {
  return phases.filter((p) => p["phase-status"] && p["phase-type"] !== "COMPLETED").map((p) => {
    const icon = statusIcon(p["phase-status"]);
    const dur = p["duration-in-seconds"] ?? 0;
    const name = p["phase-type"].padEnd(16);
    return `  ${icon} ${name} ${dur}s`;
  }).join("\n");
}
function getFailedPhaseDetails(phases) {
  const failed = phases.filter((p) => p["phase-status"] === "FAILED");
  if (failed.length === 0) return "";
  const details = failed.map((p) => {
    const context = (p["phase-context"] ?? []).filter((c) => c.trim() !== ":" && c.trim() !== "").join("\n    ");
    return context ? `  ${p["phase-type"]}: ${context}` : "";
  }).filter(Boolean).join("\n");
  return details ? `
Error Details:
${details}` : "";
}
async function handler(event) {
  const detail = event.detail;
  const info = detail["additional-information"];
  const status = detail["build-status"];
  const project = detail["project-name"];
  const buildNum = info["build-number"];
  const exportedVars = info["exported-environment-variables"] ?? [];
  const fullCommit = exportedVars.find((v) => v.name === "COMMIT_SHA")?.value ?? info["source-version"] ?? "unknown";
  const commitMsg = exportedVars.find((v) => v.name === "COMMIT_MESSAGE")?.value ?? "";
  const commit = fullCommit.substring(0, 7);
  const initiator = info.initiator ?? "unknown";
  const logsLink = info.logs?.["deep-link"] ?? "";
  const phases = info.phases ?? [];
  const icon = statusIcon(status);
  const duration = formatDuration(phases);
  const projectLink = `https://${event.region}.console.aws.amazon.com/codesuite/codebuild/${event.account}/projects/${project}/history`;
  const commitLink = GITHUB_REPO_URL ? `${GITHUB_REPO_URL}/commit/${fullCommit}` : "";
  const commitDisplay = commitMsg ? `${commit} \u2014 ${commitMsg}` : commit;
  const subject = `${icon} ${project} build #${buildNum} ${status}`;
  const message = [
    `${icon} Build ${status}`,
    `${"\u2500".repeat(40)}`,
    `Project:   ${project}`,
    `Commit:    ${commitDisplay}`,
    `Build:     #${buildNum}`,
    `Status:    ${status}`,
    `Duration:  ${duration}`,
    `Initiator: ${initiator}`,
    ``,
    `Phases:`,
    formatPhaseTable(phases),
    getFailedPhaseDetails(phases),
    ``,
    `URL:      ${APP_URL}`,
    `Project:  ${projectLink}`,
    ...commitLink ? [`GitHub:   ${commitLink}`] : [],
    `Logs:     ${logsLink}`
  ].join("\n").trim();
  await sns.send(new import_client_sns.PublishCommand({ TopicArn: TOPIC_ARN, Subject: subject.substring(0, 100), Message: message }));
}
// Annotate the CommonJS export names for ESM import in node:
0 && (module.exports = {
  handler
});
