variable "s3_acl" {
  description = "The canned ACL to apply (e.g., private/public-read/public-read-write, etc)."
  default     = "private"
}

variable "s3_bucket_policy" {
  description = "Defines the S3 bucket policy in JSON format."
  default     = null
}

variable "s3_bucket_hash" {
  description = "Defines the S3 bucket hash."
}

variable "lifecycle_rule" {
  description = "Defines the S3 bucket lifecycle rule configuration."
  default     = []
}

variable "enable_versioning" {
  description = "A flag to enable or disable versioning for the S3 bucket."
  default     = false
}

variable "cors_rule" {
  description = "Defines the CORS rule configuration."
  default     = []
}
variable "region" {
  description = "AWS region, e.g., eu-west-1"
  default     = "eu-west-1"
}

variable "mandatory_tags" {
  description = "Required map of mandatory tags. Environment must have values in the map."
  type        = map(string)
}

variable "optional_tags" {
  description = "Required map of optional tags."
  type        = map(string)
}

variable "custom_tags" {
  description = "Required map of custom tags."
  type        = map(string)
  default     = {}
}
