// Zone overrides

resource "cloudflare_zone_settings_override" "root" {
  name = "${var.root_domain_name}"
  settings {
    always_online = "on"
    always_use_https = "on"
    automatic_https_rewrites = "on"
    brotli = "on"
    http2 = "on"
    ip_geolocation = "on"
    ipv6 = "on"
    opportunistic_encryption = "on"
    opportunistic_onion = "on"
    ssl = "flexible"
    tls_1_3 = "on"
    websockets = "on"
  }
}

// DNS records

resource "cloudflare_record" "cname-mail" {
  domain  = "${var.root_domain_name}"
  name    = "mail.${var.root_domain_name}"
  value   = "ghs.googlehosted.com"
  proxied = true
  type    = "CNAME"
}

resource "cloudflare_record" "cname-root" {
  domain  = "${var.root_domain_name}"
  name    = "${var.root_domain_name}"
  value   = "${var.root_domain_name}.s3-website-${var.region}.amazonaws.com"
  proxied = true
  type    = "CNAME"
}

resource "cloudflare_record" "cname-www" {
  domain  = "${var.root_domain_name}"
  name    = "${var.www_domain_name}"
  value   = "${var.www_domain_name}.s3-website-${var.region}.amazonaws.com"
  proxied = true
  type    = "CNAME"
}

resource "cloudflare_record" "txt-google" {
  count    = "${var.use_google_apps_email}"
  domain   = "${var.root_domain_name}"
  name     = "${var.root_domain_name}"
  value    = "google-site-verification=${var.google_txt_verification}"
  proxied  = false
  priority = 10
  type     = "TXT"
}

resource "cloudflare_record" "mx-aspmx-l" {
  count    = "${var.use_google_apps_email}"
  domain   = "${var.root_domain_name}"
  name     = "${var.root_domain_name}"
  value    = "aspmx.l.google.com"
  proxied  = false
  priority = 10
  type     = "MX"
}

resource "cloudflare_record" "mx-alt1" {
  count    = "${var.use_google_apps_email}"
  domain   = "${var.root_domain_name}"
  name     = "${var.root_domain_name}"
  value    = "alt1.aspmx.l.google.com"
  proxied  = false
  priority = 20
  type     = "MX"
}

resource "cloudflare_record" "mx-alt2" {
  count    = "${var.use_google_apps_email}"
  domain   = "${var.root_domain_name}"
  name     = "${var.root_domain_name}"
  value    = "alt2.aspmx.l.google.com"
  proxied  = false
  priority = 20
  type     = "MX"
}

resource "cloudflare_record" "mx-aspmx2" {
  count    = "${var.use_google_apps_email}"
  domain   = "${var.root_domain_name}"
  name     = "${var.root_domain_name}"
  value    = "aspmx2.googlemail.com"
  proxied  = false
  priority = 30
  type     = "MX"
}

resource "cloudflare_record" "mx-aspmx3" {
  count    = "${var.use_google_apps_email}"
  domain   = "${var.root_domain_name}"
  name     = "${var.root_domain_name}"
  value    = "aspmx3.googlemail.com"
  proxied  = false
  priority = 30
  type     = "MX"
}

resource "cloudflare_record" "mx-aspmx4" {
  count    = "${var.use_google_apps_email}"
  domain   = "${var.root_domain_name}"
  name     = "${var.root_domain_name}"
  value    = "aspmx4.googlemail.com"
  proxied  = false
  priority = 30
  type     = "MX"
}

resource "cloudflare_record" "mx-aspmx5" {
  count    = "${var.use_google_apps_email}"
  domain   = "${var.root_domain_name}"
  name     = "${var.root_domain_name}"
  value    = "aspmx5.googlemail.com"
  proxied  = false
  priority = 30
  type     = "MX"
}
