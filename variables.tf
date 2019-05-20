variable "region" {
  default = "us-east-1"
}

variable "project_name" {}

variable "www_domain_name" {}
variable "root_domain_name" {}

variable "codebuild_docker_image" {
  default = "ameypar/hugo-alpine:latest"
}

variable "github_webhook_secret" {}
variable "github_oauth_secret" {}
variable "github_source_repo_name" {}
variable "github_source_repo_branch" {}
variable "github_organization" {}

variable "cloudflare_api_token" {}
variable "cloudflare_email" {}
variable "cloudflare_zone" {}

variable "use_google_apps_email" {
  default = false
}
variable "google_txt_verification" {}
