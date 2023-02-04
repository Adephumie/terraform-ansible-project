# This file adds an A record for subdomain terraform-test 
# for ALB IP address.

resource "aws_route53_record" "sub_domain_record" {
  zone_id = var.hosted_zone_id
  name    = var.sub_domain_name
  type    = "A"

  alias {
    name                   = aws_lb.project_lb.dns_name
    zone_id                = aws_lb.project_lb.zone_id
    evaluate_target_health = true
  }
}