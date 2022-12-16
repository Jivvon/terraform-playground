terraform {
  backend "s3" {
    bucket = "aws-channel-lento-terraform"
    key    = "aws/devops/infra.tfstate"
    region = "ap-northeast-2"
    #    dynamodb_table = "aws-channel-lento-terraform-locking"
  }
}

# 아래 2개는 수동으로 하여도 되고 backend init 하기 전에 미리 생성해 두어도 됨.
# 우선 편의 성을 위해서 우선 아래 resource로 생성후에 backend를 추가하여 init하는 식으로 수행 함

# S3 bucket for backend
resource "aws_s3_bucket" "tf_state" {
  bucket = "aws-channel-lento-terraform"
}

#resource "aws_s3_bucket_acl" "tf_state" {
#  bucket = aws_s3_bucket.tf_state.id
#  acl    = "private"
#}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

## DDB Tabel for backend
#resource "aws_dynamodb_table" "tf_state_lock" {
#  name         = "aws-channel-lento-terraform-locking"
#  hash_key     = "LockID"
#  billing_mode = "PAY_PER_REQUEST"
#
#  attribute {
#    name = "LockID"
#    type = "S"
#  }
#}
