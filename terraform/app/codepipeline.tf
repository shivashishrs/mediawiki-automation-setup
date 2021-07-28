resource "aws_codepipeline" "app" {
  name     = "${var.app_name}-${var.env}-codepipeline"
  role_arn = module.codepipeline_role.iam_role_arn
  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }
  stage {
    name = "source"
    action {
      category         = "Source"
      name             = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        S3Bucket    = aws_s3_bucket.source_code.bucket
        S3ObjectKey = "ansible.zip"
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      category        = "Deploy"
      name            = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.cd.name
        DeploymentGroupName = aws_codedeploy_deployment_group.cd.deployment_group_name
      }
    }
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
}

resource "aws_codedeploy_app" "cd" {
  name = "${var.app_name}-${var.env}"
}

resource "aws_codedeploy_deployment_group" "cd" {
  app_name              = aws_codedeploy_app.cd.name
  deployment_group_name = "${var.app_name}-${var.env}-cd-group"
  service_role_arn      = module.cd_role.iam_role_arn

  autoscaling_groups = [module.asg.asg_name]

}

module "cd_role" {
  source                 = "../modules/iam/role"
  assuming_role_service  = "codedeploy.amazonaws.com"
  env                    = var.env
  project_name           = var.app_name
  role_name              = "${var.app_name}-${var.env}-cd-role"
  additional_permissions = ["s3:*", "autoscaling:*", "ec2:*"]
}

module "codepipeline_role" {
  source                 = "../modules/iam/role"
  assuming_role_service  = "codepipeline.amazonaws.com"
  env                    = var.env
  project_name           = var.app_name
  role_name              = "${var.app_name}-${var.env}-codepipeline-role"
  additional_permissions = ["s3:*", "codedeploy:*", "ec2:*"]
}

resource "aws_s3_bucket" "source_code" {
  bucket_prefix = "mediawiki-source"
  versioning {
    enabled = true
  }
}

data "archive_file" "ansible" {
  type        = "zip"
  source_dir  = "../../ansible/"
  output_path = "ansible.zip"
}

resource "aws_s3_bucket_object" "ansible_code_upload" {
  bucket = aws_s3_bucket.source_code.bucket
  key    = "ansible.zip"
  source = data.archive_file.ansible.output_path
  etag   = filemd5(data.archive_file.ansible.output_path)
}