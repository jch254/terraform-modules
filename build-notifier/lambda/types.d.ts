declare module "@aws-sdk/client-sns" {
  export class SNSClient {
    constructor(config?: unknown);
    send(command: PublishCommand): Promise<unknown>;
  }

  export class PublishCommand {
    constructor(input: unknown);
  }
}

declare const process: {
  env: Record<string, string | undefined>;
};