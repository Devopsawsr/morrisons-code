terraform {
  backend "s3" {
  }
    required_providers {
      aws = {
        source  = "hashicorp/aws"
      }
    }
  }

provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}

locals {
  zip_file_path = "../../../../${var.project}-${var.application}"
}

module "s3" {
  source = "git::https://devmterror:MfRBAWZ82yHz4frpqRzp@bitbucket.org/morrisonsplc/platform-terraform-aws-s3-bucket.git?ref=v1.0.0"

  mandatory_tags = {
    "Environment"        = var.environment
    "Project"            = var.project
    "application_service" = var.application
    "seq_id"              = var.seq_id
  }

  optional_tags = {}
  region        = var.region
}

module "lambda" {
  source = "git::https://devmterror:MfR84WZ82yHz4frpqRzp@bitbucket.org/morrisonsplc/platform-terraform-aws-lambda-with-code.git?ref=v1.0.0"

  mandatory_tags = {
    "Environment"        = var.environment
    "Project"            = var.project
    "application_service" = var.application
    "seq_id"              = var.seq_id
  }

  optional_tags       = {}
  region              = var.region
  enable_vpc_config   = var.enable_vpc_config
  vpc_tag_name        = var.vpc_tag_name
  vpc_tag_name_value  = var.vpc_tag_name_value
  subnet_info         = var.subnet_info
  s3_bucket           = module.s3.name
  s3_key              = module.file_upload.key
  iam_role_lambda     = var.iam_role
  handler             = var.handler
  runtime             = var.runtime
  security_group_name = var.security_group_name
  timeout             = var.timeout
  retention_in_days   = var.retention_in_days
  source_code_hash    = filebase64sha256("${local.zip_file_path}.zip")

  environment_variables = {
    "ENV"        = var.environment
    "PYTHONPATH" = var.python_path
  }
}
