# To Output IP address of webserver_1
output "webserver_1_ip_addr" {
  value       = aws_instance.webserver_1.private_ip
  description = "IP address of server 1"
}

# To Output IP address of webserver_2
output "webserver_2_ip_addr" {
  value       = aws_instance.webserver_2.private_ip
  description = "IP address of server 2"
}

# To Output IP address of webserver_3
output "webserver_3_ip_addr" {
  value       = aws_instance.webserver_3.private_ip
  description = "IP address of server 3"
}

# To output generated url for the loadbalancer
output "lb_generated_url" {
  value       = aws_lb.project_lb.dns_name
  description = "Generated url of load balancer"
}



