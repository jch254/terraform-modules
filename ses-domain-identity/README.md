# ses-domain-identity

Creates an Amazon SES domain identity and Easy DKIM tokens for one domain.

This module intentionally does not manage DNS records, receipt rule sets, receipt rules, active receipt rule sets, raw mail buckets, Lambda forwarders, mail provider records, or app parser behavior.

## Example

```hcl
module "parse_domain_identity" {
  source = "git::https://github.com/jch254/terraform-modules.git//ses-domain-identity?ref=<version>"

  domain = "parse.example.com"

  tags = {
    Environment = "prod"
  }
}
```

Use the outputs to publish the SES verification TXT and DKIM CNAME records via the generic `cloudflare-dns-records` module:

```hcl
locals {
  parse_domain_records = merge(
    {
      verification = {
        name    = "_amazonses.${module.parse_domain_identity.domain}"
        type    = "TXT"
        content = module.parse_domain_identity.verification_token
      }
    },
    {
      for token in module.parse_domain_identity.dkim_tokens :
      "dkim_${token}" => {
        name    = "${token}._domainkey.${module.parse_domain_identity.domain}"
        type    = "CNAME"
        content = "${token}.dkim.amazonses.com"
      }
    },
  )
}

module "parse_domain_records" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudflare-dns-records?ref=<version>"

  zone_id = data.cloudflare_zone.zone.id
  records = local.parse_domain_records
}
```

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `domain` | Domain to verify with Amazon SES, for example `parse.example.com`. | `string` | required |
| `tags` | Reserved tag map for interface consistency. `aws_ses_domain_identity` and `aws_ses_domain_dkim` do not currently support tags in the AWS provider. | `map(string)` | `{}` |

## Outputs

| Name | Description |
| --- | --- |
| `domain` | SES domain identity domain. |
| `verification_token` | SES domain verification token for the `_amazonses.<domain>` TXT record. |
| `dkim_tokens` | SES Easy DKIM tokens for `<token>._domainkey.<domain>` CNAME records. |
| `identity_arn` | ARN of the SES domain identity. |

## Migration Notes

Existing SES identities must be imported or moved into this module before applying. Recreating a live identity can temporarily break verification and DKIM status for inbound mail.

Example import:

```bash
terraform import 'module.parse_domain_identity.aws_ses_domain_identity.main' parse.example.com
terraform import 'module.parse_domain_identity.aws_ses_domain_dkim.main' parse.example.com
```

For a Terraform-managed identity in the same state, prefer a `moved` block or `terraform state mv`:

```hcl
moved {
  from = aws_ses_domain_identity.parse
  to   = module.parse_domain_identity.aws_ses_domain_identity.main
}

moved {
  from = aws_ses_domain_dkim.parse
  to   = module.parse_domain_identity.aws_ses_domain_dkim.main
}
```

Run a plan after moving or importing state and require no replacement before applying.
