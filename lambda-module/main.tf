module "tag-1" {
  source        = "git::https://devmterror:HFR84W282yfz4frpqRzp@bitbucket.org/morrisonspic/platform-terraform-aus-tagging.git?ref=v1.0.0"
  region        = var.region
  mandatory_tags = var.mandatory_tags
  optional_tags  = var.optional_tags
  custom_tags    = var.custom_tags
}

data "aws_vpc" "main" {
  count = var.enable_vpc_config ? 1 : 0

  filter {
    name   = "tag:${var.vpc_tag_name}"
    values = [var.vpc_tag_name_value]
  }
}

data "aws_subnets" "private_app_subnets" {
  count = var.enable_vpc_config ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main[count.index].id]
  }

  tags = {
    Name = "${var.subnet_info}*"
  }
}

data "aws_security_group" "main" {
  count  = var.enable_vpc_config ? 1 : 0
  name   = var.security_group_name
  vpc_id = data.aws_vpc.main[count.index].id
}

data "aws_iam_role" "main" {
  name = "${var.iam_role}-lambda"
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/lambda/lmb-${split("/", module.tag-1.null_resource["region"])[1]}-${module.tag-1.null_resource["environment"]}-${module.tag-1.null_resource["project"]}${module.tag-1.null_resource["application"]}${module.tag-1.null_resource["version"]}"
  retention_in_days = var.log_retention_in_days
  depends_on        = [module.tag-1]

  tags = merge(
    module.tag-1.null_resource,
    tomap({ "Name" = "/aws/lambda/lmb-${split("/", module.tag-1.null_resource["region"])[1]}-${module.tag-1.null_resource["environment"]}-${module.tag-1.null_resource["project"]}${module.tag-1.null_resource["application"]}${module.tag-1.null_resource["version"]}"})
  )
}

resource "aws_lambda_function" "main" {
  function_name = "lmb-${split("/", module.tag-1.null_resource["region"])[1]}-${module.tag-1.null_resource["environment"]}-${module.tag-1.null_resource["project"]}${module.tag-1.null_resource["application"]}${module.tag-1.null_resource["version"]}"
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  role          = data.aws_iam_role.main.arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size
  description   = var.desc
  reserved_concurrent_executions = var.concurrency
  source_code_hash              = var.source_code_hash
  ephemeral_storage {
    size = var.ephemeral_storage
  }

  vpc_config {
    subnet_ids          = var.enable_vpc_config ? data.aws_subnets.private_app_subnets[0].ids : []
    security_group_ids  = var.enable_vpc_config ? [data.aws_security_group.main[0].id] : []
  }

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) > 0 ? [true] : []
    content {
      variables = var.environment_variables
    }
  }

  depends_on = [module.tag-1, aws_cloudwatch_log_group.main]
  tags       = merge(
    module.tag-1.null_resource,
    tomap({ "Name" = "/aws/lambda/lmb-${split("/", module.tag-1.null_resource["region"])[1]}-${module.tag-1.null_resource["environment"]}-${module.tag-1.null_resource["project"]}${module.tag-1.null_resource["application"]}${module.tag-1.null_resource["version"]}" })
  )
}
