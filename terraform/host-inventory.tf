# Export instance Elastic IP addresses to host-inventory file
resource "local_file" "host_inventory_file" {
  filename = "./host-inventory"
  content  = <<EOT
[webservers]
server1 ansible_host=${aws_eip.webserver_1_ip.public_ip}
server2 ansible_host=${aws_eip.webserver_2_ip.public_ip}
server3 ansible_host=${aws_eip.webserver_3_ip.public_ip}
  EOT
}



