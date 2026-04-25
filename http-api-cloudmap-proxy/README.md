# http-api-cloudmap-proxy

Manages an API Gateway HTTP API that proxies to a Cloud Map service through a VPC Link.

This module intentionally does not manage ACM certificates, API custom domains, API mappings, Cloudflare DNS, or certificate validation records.

## Example

```hcl
module "http_api_cloudmap_proxy" {
  source = "git::https://github.com/jch254/terraform-modules.git//http-api-cloudmap-proxy?ref=<version>"

  name        = var.name
  environment = var.environment

  subnet_ids                   = data.aws_subnets.public.ids
  vpc_link_security_group_ids  = [module.app_security_groups.vpc_link_security_group_id]
  cloudmap_service_arn         = module.cloudmap_private_service.service_arn

  tags = {
    Environment = var.environment
  }
}
```

Defaults match the current reference-architecture HTTP API edge: HTTP protocol API, HTTP proxy integration, VPC Link connection, `ANY` integration method, `$default` route, `$default` stage, and `auto_deploy = true`.

## Migration Notes

Move API Gateway HTTP API resources into this module before applying. API Gateway replacement is not acceptable. VPC Link replacement is also high risk, so preserve subnet and security group values exactly during the consumer migration.

Expected move targets:

```hcl
moved { from = aws_apigatewayv2_api.main to = module.http_api_cloudmap_proxy.aws_apigatewayv2_api.main }
moved { from = aws_apigatewayv2_vpc_link.main to = module.http_api_cloudmap_proxy.aws_apigatewayv2_vpc_link.main }
moved { from = aws_apigatewayv2_integration.main to = module.http_api_cloudmap_proxy.aws_apigatewayv2_integration.main }
moved { from = aws_apigatewayv2_route.main to = module.http_api_cloudmap_proxy.aws_apigatewayv2_route.main }
moved { from = aws_apigatewayv2_stage.main to = module.http_api_cloudmap_proxy.aws_apigatewayv2_stage.main }
```

Keep custom domain and API mapping resources app-local or defer them to a separate domain-focused module phase.