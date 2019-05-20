resource "aws_codepipeline_webhook" "hugo" {
  name            = "${var.project_name}_codepipeline"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = "${aws_codepipeline.hugo.name}"

  authentication_configuration {
    secret_token  = "${var.github_webhook_secret}"
  }

  filter {
    json_path     = "$.ref"
    match_equals  = "refs/heads/{Branch}"
  }
}

# Wire the CodePipeline webhook into a GitHub repository.
resource "github_repository_webhook" "hugo" {
  repository     = "${var.github_source_repo_name}"

  configuration {
    url          = "${aws_codepipeline_webhook.hugo.url}"
    content_type = "form"
    insecure_ssl = true
    secret       = "${var.github_webhook_secret}"
  }

  events = ["push"]
}
