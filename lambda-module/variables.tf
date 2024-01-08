########### VARS ##########

variable "enable_vpc_config" {
    description  = "Enbale VPC for Lambda"
    default      = false
}

variable "log retention_in_days" {
    default = 7
}

variable "vpc_tag_name" {
    description = "The VPC tag to filter VPC information"
    default     = ""
}

variable "source_code_hash" {
}

variable "vpc_tag_name_Value" {
    description = "The VPC tag value to filter VPC information"
    default     = ""
}
variable "subnet_info" {
    description  = "The subnet info to retrive subnet details"
    default      = ""
}
variable "iam_role_lambda" {
    description  = "The I am role for Lambda"
    default      = ""
}
variable "security_group_name" {
    description  = "The Security group name"
    default      = ""
}
variable "s3_bucket" {
  description = "The S3 bucket name that holds the Lambda code"
}

variable "s3_key" {
  description = "The full path to code file with name inside the s3 bucket"
}

variable "handler" {
  description = "The handler for lambda function"
  default     = ""
}

variable "runtime" {
  description = "The runtime for lambda function"
  default     = "python 3.8"
}

variable "timeout" {
  description = "The time frame for lambda to run, default 300 sec Max"
  default     = "300"
}

variable "memory_size" {
  description = "The memory size to be allocated for the lambda function"
  default     = 128
}
variable "desc" {
  description = "Short description of lambda"
  default     = ""
}

variable "ephemeral_storage" {
  description = "The size of the lambda function's ephemeral storage (/tmp) represented in MB. The minimum supported ephemeral storage is 512 MB."
  default     = 512
}

variable "concurrency" {
  description = "The amount of reserved concurrent executions for this lambda function. A value of 8 disables lambda from concurrent executions."
  default     = "-1"  # Set your desired default value
}

## For Tags Mostly

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}  # Set your default environment variables as a map
}

variable "region_id" {
  description = "aws.region, e.g., eurd"
  default     = "use1"
}
variable "region" {
  description = "AWS region, e.g., eu-west-1"
  default     = "eu-west-1"
}
variable "mandatory_tags" {
  type        = map(any)
  description = "Required map of mandatory tags. environment must have values in"
}
variable "optional_tags" {
  description = "Required map of optional tags."
  type        = map(any)
  
}
variable "custom_tags" {
  description = "Required map of custom tags."
  type        = map(any)
  default     = {}
}

