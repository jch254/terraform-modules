# acm-dns-validated-certificate

Creates one ACM certificate configured for DNS validation.

This module intentionally does not manage DNS records, Cloudflare records, or `aws_acm_certificate_validation`. DNS-provider-specific modules can consume `validation_records` and create the required validation CNAMEs in their own Terraform root.

## Example

```hcl
module "acm_dns_validated_certificate" {
  source = "git::https://github.com/jch254/terraform-modules.git//acm-dns-validated-certificate?ref=<version>"

  domain_name = var.dns_name

  tags = {
    Name        = "${var.name}-certificate"
    Environment = var.environment
  }
}

output "acm_certificate_validation" {
  description = "ACM certificate DNS validation records for the DNS Terraform root."
  value       = module.acm_dns_validated_certificate.validation_records
}
```

For apex plus wildcard certificates, pass the wildcard SAN explicitly:

```hcl
module "acm_dns_validated_certificate" {
  source = "git::https://github.com/jch254/terraform-modules.git//acm-dns-validated-certificate?ref=<version>"

  domain_name               = var.cloudflare_domain
  subject_alternative_names = ["*.${var.cloudflare_domain}"]
  tags                      = local.tags
}
```

`subject_alternative_names` are de-duplicated and sorted to keep plans stable. `validation_records` is keyed by DNS record name and includes all certificate domain names that share that validation record, which avoids duplicate DNS records for apex plus wildcard certificates.

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `domain_name` | Primary domain name for the ACM certificate. | `string` | required |
| `subject_alternative_names` | Additional subject alternative names. | `list(string)` | `[]` |
| `validation_method` | ACM validation method. | `string` | `"DNS"` |
| `tags` | Tags to apply to the certificate. | `map(string)` | `{}` |

## Outputs

| Name | Description |
| --- | --- |
| `arn` | ARN of the ACM certificate. |
| `domain_name` | Primary domain name on the certificate. |
| `domain_validation_options` | Raw ACM domain validation options. |
| `validation_records` | De-duplicated DNS validation records keyed by record name. |

## Migration Notes

Existing ACM certificates must be moved into this module before applying. Certificate replacement is not acceptable for existing app domains.

Reference-architecture-style move target:

```hcl
moved {
  from = aws_acm_certificate.main
  to   = module.acm_dns_validated_certificate.aws_acm_certificate.main
}
```

Equivalent state command:

```bash
terraform state mv 'aws_acm_certificate.main' 'module.acm_dns_validated_certificate.aws_acm_certificate.main'
```

After adding the module and moved block, run a remote-state plan and require no replacement for the certificate. Keep `domain_name`, SANs, validation method, and tags equivalent to the existing resource during migration.
