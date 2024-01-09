#module "tag-1" {
  source         = "git::https://devmterror:MfR84WZ82yHz4frpqRzp@bitbucket.org/morrisonsplc/platform-terraform-aws-tagging.git?ref=v1.0.0"
  mandatory_tags = var.mandatory_tags
  optional_tags  = var.optional_tags
  custom_tags    = var.custom_tags
  region         = var.region
}

resource "random_string" "main" {
  length = 10
  lower  = true
  upper  = false
  numeric = false
  special = false
}

resource "aws_s3_bucket" "main" {
  bucket = "m${module.tag-1.null_resource["environment"]}.${module.tag-1.null_resource["project"]}.${module.tag-1.null_resource["application"]}.${random_string.main.result}"
  acl    = var.s3_acl
  policy = length(var.s3_bucket_policy) > 0 ? var.s3_bucket_policy : null

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)
      enabled                           = lifecycle_rule.value.enabled
      id                                = lookup(lifecycle_rule.value, "id", null)
      prefix                            = lookup(lifecycle_rule.value, "prefix", null)
      tags                              = lookup(lifecycle_rule.value, "tags", null)

      dynamic "expiration" {
      for_each = lookup(lifecycle_rule.value, "expiration", [])

      content {
        date                        = lookup(expiration.value, "date", null)
        days                        = lookup(expiration.value, "days", null)
        expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
      }
    }
    
    dynamic "noncurrent_version_expiration" {
      for_each = lookup(lifecycle_rule.value, "noncurrent_version_expiration", [])
      content {
        days = lookup(noncurrent_version_expiration.value, "days", null)
  }
}

   dynamic "noncurrent_version_transition" {
      for_each = lookup(lifecycle_rule.value, "noncurrent_version_transition", [])
      content {
         days          = lookup(noncurrent_version_transition.value, "days", null)
         storage_class = noncurrent_version_transition.value.storage_class
     }
    }

    dynamic "transition" {
      for_each = lookup(lifecycle_rule.value, "transition", [])
       content {
        date          = lookup(transition.value, "date", null)
        days          = lookup(transition.value, "days", null)
        storage_class = transition.value.storage_class
      }
    }
  }
}
    dynamic "cors_rule" {
      iterator = cors_rule
      for_each = var.cors_rule

  content {
    allowed_headers      = lookup(cors_rule.value, "allowed_headers", null)
    allowed_methods      = lookup(cors_rule.value, "allowed_methods", null)
    allowed_origins      = lookup(cors_rule.value, "allowed_origins", null)
    expose_headers       = lookup(cors_rule.value, "expose_headers", null)
    max_age_seconds      = lookup(cors_rule.value, "max_age_seconds", null)

 }   
}
    versioning {
       enabled = var. enable_versioning
}

  tags = merge (
   module. tag-1.null_resource,
   tomap ({ "Name""m$ {module. tag-1. null_resource["environment"]).$(module.tag-1.null_resource["project"]}.$(module. tag-1. null_resource[ "application"]}.${random_string.main.result}'})
   )
   
  depends_on = [module. tag-1, random_ string-main]

}


