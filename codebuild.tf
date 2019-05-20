resource "aws_codebuild_project" "hugo" {
  name          = "${var.project_name}_codebuild"
  description   = "CodeBuild project to build a hugo site."
  build_timeout = "5"
  service_role  = "${aws_iam_role.hugo.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "${var.codebuild_docker_image}"
    image_pull_credentials_type = "SERVICE_ROLE"
    type                        = "LINUX_CONTAINER"
  }
}
