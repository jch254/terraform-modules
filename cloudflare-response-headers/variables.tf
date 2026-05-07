variable "zone_id" {
  description = "Cloudflare zone ID where the response-header transform ruleset will be created."
  type        = string
}

variable "name" {
  description = "Name of the Cloudflare response-header ruleset."
  type        = string
  default     = "default"
}

variable "description" {
  description = "Description for the response-header transform rule."
  type        = string
  default     = "Security Headers"
}

variable "expression" {
  description = "Cloudflare ruleset expression that determines where the response headers apply."
  type        = string
  default     = "true"
}

variable "content_security_policy" {
  description = "Content-Security-Policy header value."
  type        = string
  default     = "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; img-src 'self' data: https:; frame-src https://www.youtube-nocookie.com https://player.vimeo.com https://w.soundcloud.com https://open.spotify.com https://www.instagram.com https://embed.podcasts.apple.com; font-src 'self' https://fonts.gstatic.com; connect-src 'self'; upgrade-insecure-requests"
}

variable "permissions_policy" {
  description = "Permissions-Policy header value."
  type        = string
  default     = "camera=(), microphone=(), geolocation=(), payment=()"
}

variable "referrer_policy" {
  description = "Referrer-Policy header value."
  type        = string
  default     = "strict-origin-when-cross-origin"
}

variable "strict_transport_security" {
  description = "Strict-Transport-Security header value."
  type        = string
  default     = "max-age=31536000; includeSubDomains; preload"
}

variable "x_content_type_options" {
  description = "X-Content-Type-Options header value."
  type        = string
  default     = "nosniff"
}

variable "x_frame_options" {
  description = "X-Frame-Options header value."
  type        = string
  default     = "DENY"
}

variable "additional_headers" {
  description = "Additional response headers keyed by header name. These are merged with the standard security headers."
  type = map(object({
    operation = optional(string, "set")
    value     = string
  }))
  default = {}
}
