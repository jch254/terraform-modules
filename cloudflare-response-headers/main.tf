locals {
  standard_headers = {
    "Content-Security-Policy" = {
      operation = "set"
      value     = var.content_security_policy
    }
    "Permissions-Policy" = {
      operation = "set"
      value     = var.permissions_policy
    }
    "Referrer-Policy" = {
      operation = "set"
      value     = var.referrer_policy
    }
    "Strict-Transport-Security" = {
      operation = "set"
      value     = var.strict_transport_security
    }
    "X-Content-Type-Options" = {
      operation = "set"
      value     = var.x_content_type_options
    }
    "X-Frame-Options" = {
      operation = "set"
      value     = var.x_frame_options
    }
  }

  headers = merge(local.standard_headers, var.additional_headers)
}

resource "cloudflare_ruleset" "this" {
  zone_id = var.zone_id
  name    = var.name
  kind    = "zone"
  phase   = "http_response_headers_transform"

  rules = [
    {
      description = var.description
      expression  = var.expression
      action      = "rewrite"

      action_parameters = {
        headers = local.headers
      }
    }
  ]
}
