# terraform-aws-cloudflare-static

This is a [Terraform](https://www.terraform.io/) module that sets up a static website:
- Sourced from a public/private Github repo
- Built using [Hugo](https://gohugo.io/)
- Built on [AWS CodePipeline](https://aws.amazon.com/codepipeline/)
- Deployed to [AWS S3](https://aws.amazon.com/s3/)
- Uses [Cloudflare](https://www.cloudflare.com/) for DNS, HTTPS and caching
- (Optionally) sets up DNS records for [Google Apps Email](https://gsuite.google.com/products/gmail/)

# Setup
1. Install Terraform
2. Create a file with a `.tf` extension (say, `root.tf`) in a folder of your choosing. Paste the configuration below into it.
3. Run `terraform init` and then `terraform apply`.

# Terraform configuration

## Easiest
```terraform
module "static-site" {
  source                    = "git::https://github.com/ameyp/terraform-aws-cloudflare-static"
  project_name              = "awesome-website"

  // Your root domain
  root_domain_name          = "example.com"
  // The "www" subdomain for your website
  www_domain_name           = "www.example.com"
  // The name of your domain on Cloudflare. Typically the same as your root domain.
  cloudflare_zone           = "example.com"

  // Your github username
  github_organization       = "username"
  // Name of the repo containing your hugo source
  github_source_repo_name   = "example.com"
  // The branch to build of the above repo
  github_source_repo_branch = "master"
  // https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line
  github_oauth_secret       = "abcdefgh5678"
  // https://developer.github.com/webhooks/securing
  github_webhook_secret     = "ijklmnop1234"
}

provider "aws" {
  version    = "~> 2.10"
  region     = "us-east-1"
  // https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
  // Your AWS access key
  access_key = "aws1234"
  // Your AWS secret key
  secret_key = "aws5678"
}

provider "github" {
  version      = "~> 2.0"
  // Your Github username
  organization = "username"
  // https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line
  token        = "abcdefgh5678"
}

provider "cloudflare" {
  version = "~> 1.14"
  // Your Cloudflare email
  email   = "user@example.com"
  // https://support.cloudflare.com/hc/en-us/articles/200167836-Where-do-I-find-my-Cloudflare-API-key
  token   = "qrstuvwx9012"
}
```

## Customization
In addition to the above configuration, you can add the following variables to the `module` section for additional customization:
```terraform
module "static-site" {
  ...

  // The docker image used for transforming your hugo content to static assets.
  // You can use my image or specify your own on Docker Hub.
  codebuild_docker_image    = "ameypar/hugo-alpine:latest"

  // Whether you want to set up MX records in Cloudflare for Google Apps email.
  use_google_apps_email     = true

  // https://support.google.com/a/answer/183895
  google_txt_verification   = "google1234"
}
```

# Build spec
This should go into `buildspec.yml` in the root of your hugo source repository. This file tells the AWS CodeBuild step in the pipeline how to build your repository using hugo and what files should be uploaded to AWS S3.

```yaml
version: 0.2

phases:
  build:
    commands:
      - hugo -v

artifacts:
  type: zip
  files:
    - '**/*'
  base-directory: 'public'
  discard-paths: no
```

# Best practices

1. Although the template above is written with ease of use in mind, it's recommended that you don't put your secrets into the root file if you intend to check it into version control. Instead, declare variables in the file and create a `terraform.tfvars` file with the actual secrets. Guide here: https://learn.hashicorp.com/terraform/getting-started/variables.html
2. For AWS, instead of using your root user, I recommend creating an IAM user with Administrator access specifically for use with Terraform. Once you're done applying the Terraform plan, you can delete the IAM user if desired. https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html
3. Instead of storing your terraform state locally, pick one of the existing terraform [backends](https://www.terraform.io/docs/backends/config.html). If you choose the [S3 backend](https://www.terraform.io/docs/backends/types/s3.html) and create a bucket named `my-terraform-state`, you would put the following block into your `root.tf` file and then run `terraform init`.
```terraform
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "state"
    region = "us-east-1"
  }
}
```
