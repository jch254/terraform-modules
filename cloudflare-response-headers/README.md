# cloudflare-response-headers

Creates a Cloudflare zone response-header transform ruleset with a standard
security-header baseline. The defaults match the current static-site pattern
used by `jch254.com`, while keeping values overrideable per consumer.

## Example

```hcl
module "response_headers" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudflare-response-headers?ref=<version>"

  zone_id = data.cloudflare_zone.zone.id
}
```

## Customization

Override individual standard headers when a site needs a different policy:

```hcl
module "response_headers" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudflare-response-headers?ref=<version>"

  zone_id = data.cloudflare_zone.zone.id

  content_security_policy = "default-src 'self'; img-src 'self' https: data:"
}
```

Add extra headers with `additional_headers`:

```hcl
module "response_headers" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudflare-response-headers?ref=<version>"

  zone_id = data.cloudflare_zone.zone.id

  additional_headers = {
    "Cross-Origin-Opener-Policy" = {
      value = "same-origin"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `zone_id` | Cloudflare zone ID where the response-header transform ruleset will be created. | `string` | required |
| `name` | Name of the Cloudflare response-header ruleset. | `string` | `"default"` |
| `description` | Description for the response-header transform rule. | `string` | `"Security Headers"` |
| `expression` | Cloudflare ruleset expression that determines where the response headers apply. | `string` | `"true"` |
| `content_security_policy` | Content-Security-Policy header value. | `string` | static-site default |
| `permissions_policy` | Permissions-Policy header value. | `string` | static-site default |
| `referrer_policy` | Referrer-Policy header value. | `string` | `"strict-origin-when-cross-origin"` |
| `strict_transport_security` | Strict-Transport-Security header value. | `string` | `"max-age=31536000; includeSubDomains; preload"` |
| `x_content_type_options` | X-Content-Type-Options header value. | `string` | `"nosniff"` |
| `x_frame_options` | X-Frame-Options header value. | `string` | `"DENY"` |
| `additional_headers` | Additional response headers keyed by header name. | `map(object({ operation = optional(string, "set"), value = string }))` | `{}` |

## Outputs

| Name | Description |
| --- | --- |
| `id` | Cloudflare response-header ruleset ID. |
| `name` | Cloudflare response-header ruleset name. |
| `phase` | Cloudflare ruleset phase. |

## Migration

Move existing root-managed Cloudflare response-header rulesets into the module
before applying so the live ruleset is not recreated:

```hcl
moved {
  from = cloudflare_ruleset.response_headers
  to   = module.response_headers.cloudflare_ruleset.this
}
```

Run a remote-state plan after the move and require no create, update, delete,
or replace for the moved ruleset.
