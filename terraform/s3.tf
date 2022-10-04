module "aws_s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "3.4.0"
  create_bucket = true
  bucket        = "test-deploy-13413241234312"
  acl           = "private"
}
