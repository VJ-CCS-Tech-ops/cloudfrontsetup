
//Generation cerate an SSL certificate using AWS certificate manager
//email validation has to happen before this cert gets created

resource "aws_acm_certificate" "certificate" {

  domain_name       = "*.${var.domain_name}"
  validation_method = "EMAIL"


  subject_alternative_names = ["${var.www.domain_name}"]
}
