# api-gateway-custom-domain

Creates one API Gateway v2 custom domain and one API mapping.

This module intentionally does not create ACM certificates, DNS records, Cloudflare resources, wildcard routing, or apex routing policy. For apps that need both apex and wildcard domains, instantiate this module once per domain.

## Example

```hcl
module "api_gateway_custom_domain" {
  source = "git::https://github.com/jch254/terraform-modules.git//api-gateway-custom-domain?ref=<version>"

  domain_name     = var.dns_name
  certificate_arn = module.acm_dns_validated_certificate.arn
  api_id          = module.http_api_cloudmap_proxy.api_id
  stage           = module.http_api_cloudmap_proxy.stage_id

  tags = {
    Name        = "${var.name}-api-domain"
    Environment = var.environment
  }
}

output "api_gateway_custom_domain_target" {
  description = "Target domain name for DNS CNAME records."
  value       = module.api_gateway_custom_domain.target_domain_name
}
```

For apex plus wildcard apps, call the module twice with app-local domain choices:

```hcl
module "api_gateway_custom_domain_apex" {
  source = "git::https://github.com/jch254/terraform-modules.git//api-gateway-custom-domain?ref=<version>"

  domain_name     = var.cloudflare_domain
  certificate_arn = module.acm_dns_validated_certificate.arn
  api_id          = aws_apigatewayv2_api.main.id
  stage           = aws_apigatewayv2_stage.main.id
  tags            = local.tags
}

module "api_gateway_custom_domain_wildcard" {
  source = "git::https://github.com/jch254/terraform-modules.git//api-gateway-custom-domain?ref=<version>"

  domain_name     = "*.${var.cloudflare_domain}"
  certificate_arn = module.acm_dns_validated_certificate.arn
  api_id          = aws_apigatewayv2_api.main.id
  stage           = aws_apigatewayv2_stage.main.id
  tags            = local.tags
}
```

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `domain_name` | Custom domain name to attach to API Gateway. | `string` | required |
| `certificate_arn` | ACM certificate ARN for the custom domain. | `string` | required |
| `api_id` | API Gateway HTTP API ID to map. | `string` | required |
| `stage` | API Gateway stage ID or name to map. | `string` | required |
| `endpoint_type` | API Gateway custom domain endpoint type. | `string` | `"REGIONAL"` |
| `security_policy` | TLS security policy. | `string` | `"TLS_1_2"` |
| `tags` | Tags to apply to the custom domain. | `map(string)` | `{}` |

## Outputs

| Name | Description |
| --- | --- |
| `domain_name` | API Gateway custom domain name. |
| `target_domain_name` | Regional API Gateway target domain name for DNS CNAME records. |
| `hosted_zone_id` | API Gateway hosted zone ID for the custom domain target. |
| `api_mapping_id` | ID of the API Gateway API mapping. |

## Migration Notes

Existing API Gateway domain resources must be moved into this module before applying. Custom domain or API mapping replacement is not acceptable for existing app domains.

Reference-architecture-style move targets:

```hcl
moved {
  from = aws_apigatewayv2_domain_name.main
  to   = module.api_gateway_custom_domain.aws_apigatewayv2_domain_name.main
}

moved {
  from = aws_apigatewayv2_api_mapping.main
  to   = module.api_gateway_custom_domain.aws_apigatewayv2_api_mapping.main
}
```

Equivalent state commands:

```bash
terraform state mv 'aws_apigatewayv2_domain_name.main' 'module.api_gateway_custom_domain.aws_apigatewayv2_domain_name.main'
terraform state mv 'aws_apigatewayv2_api_mapping.main' 'module.api_gateway_custom_domain.aws_apigatewayv2_api_mapping.main'
```

After adding the module and moved blocks, run a remote-state plan and require no replacement for the custom domain or API mapping. Keep `domain_name`, certificate ARN, API ID, stage, endpoint type, security policy, and tags equivalent to the existing resources during migration.
