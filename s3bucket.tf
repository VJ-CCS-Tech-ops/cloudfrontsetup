resource "aws_s3_bucket" "originbucket" {

  bucket = "${var.domain_name}"
  //it has to be "public" - This can be changed based on who needs access to the bucket
  acl = "public-read"

  //policy for reading the object from S3 bucket

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.domain_name}/*"]
    }
  ]
}
POLICY

  //this is to tell S3 bucket on which file to be used when the request comes in.  This needs to be changed as well
  website {
    // Here we tell S3 what to use when a request comes in to the root

    index_document = "index.html"
    // if the page doesnt exis then it present the following page
    error_document = "404.html"
  }
}
