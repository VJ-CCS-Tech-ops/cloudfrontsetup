// Create a variable for our domain name because we'll be using it a lot.
// We'll also need the root domain (also known as zone apex or naked domain).
variable "root_domain_name" {
  default = "crowncommercial.gov.uk"
}

variable "region" {
  default = "eu-west-2"
}

variable "s3_origin_id" {
  default = "myS3Origin"
}

variable "domain_name" {
  default = "api.sbx.api.crowncommercial.gov.uk"
}
