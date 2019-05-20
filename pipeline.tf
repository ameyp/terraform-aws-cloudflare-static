resource "aws_codepipeline" "hugo" {
  name     = "${var.project_name}_codepipeline"
  role_arn = "${aws_iam_role.hugo.arn}"

  artifact_store {
    location = "${aws_s3_bucket.hugo.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration {
        Owner          = "${var.github_organization}"
        Repo           = "${var.github_source_repo_name}"
        Branch         = "${var.github_source_repo_branch}"
        OAuthToken     = "${var.github_oauth_secret}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration {
        ProjectName    = "${aws_codebuild_project.hugo.name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "S3"
      input_artifacts  = ["build_output"]
      version          = "1"

      configuration {
        BucketName     = "${aws_s3_bucket.hugo_root.bucket}"
        Extract        = "true"
      }
    }
  }
}
