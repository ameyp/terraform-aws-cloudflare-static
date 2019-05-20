provider "aws" {
  version = "~> 2.10"
  region  = "${var.region}"
}

provider "github" {
  version      = "~> 2.0"
  token        = "${var.github_oauth_secret}"
  organization = "${var.github_organization}"
}

provider "cloudflare" {
  version = "~> 1.14"
  email   = "${var.cloudflare_email}"
  token   = "${var.cloudflare_api_token}"
}
