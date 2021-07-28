terraform {
  # Require any 1.0.x version of Terraform
  required_version = ">= 1.0, < 1.1"
}

# IAM Role

resource "aws_iam_role" "role" {
  name = var.role_name
  assume_role_policy = data.template_file.assume_role_policy.rendered

  tags = {
    Name        = "${var.project_name }-${var.env}"
    ProjectName = var.project_name
  }
}

resource "aws_iam_role_policy" "policy" {
  name = "${var.project_name }-policy-${var.env}"
  role = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.permissions.json
}

data "template_file" "assume_role_policy" {
  template = file("${ path.module }/assume_role_policy.json")
  vars = {
    assuming_service = var.assuming_role_service
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid = ""

    actions = compact(concat([
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ], var.additional_permissions))

    effect = "Allow"

    resources = [
      "*",
    ]
  }
}
