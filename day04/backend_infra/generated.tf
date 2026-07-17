# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "sanggs-demo-terrawk-bkt"
resource "aws_s3_bucket" "imported" {
  bucket              = "sanggs-demo-terrawk-bkt"
  bucket_namespace    = "global"
  force_destroy       = false
  object_lock_enabled = false
  region              = "us-west-2"
  tags                = {}
  tags_all            = {}
}
