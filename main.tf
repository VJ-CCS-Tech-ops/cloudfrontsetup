// This block tells Terraform that we're going to provision AWS resources.

provider "aws" {
  version = "~> 2.70"
  region  = "${var.region}"
}

provider "local" {
  version = "~> 1.4"
}

provider "template" {
  version = "~> 2.1"
}

//bucket name generation

data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${data.aws_caller_identity.current.account_id}.tfstate"
}

//creating user policy

resource "aws_iam_user_policy_attachment" "bootstrap-dynamodb-attach" {
  user       = "${basename(data.aws_caller_identity.current.arn)}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_user_policy_attachment" "bootstrap-s3-attach" {
  user       = "${basename(data.aws_caller_identity.current.arn)}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

//creating S3 bucket to store the state file

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${local.bucket_name}"

  versioning {
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      "bucket",
    ]
  }
}

//creating Dynamodb to lock the state file

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform_state_lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  depends_on = [
    "aws_iam_user_policy_attachment.bootstrap-dynamodb-attach",
    "aws_iam_user_policy_attachment.bootstrap-s3-attach"
  ]
}
