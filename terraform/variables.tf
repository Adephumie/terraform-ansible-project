variable "region" {
  description = "Region set for AWS provider"
  type        = string
  default     = ""
}

variable "vpc_cidr_block" {
  description = "Value for the VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_A_cidr_block" {
  description = "Value for the pub-subnet-A CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_B_cidr_block" {
  description = "Value for the pub-subnet-B CIDR block"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet_C_cidr_block" {
  description = "Value for the pub-subnet-C CIDR block"
  type        = string
  default     = "10.0.3.0/24"
}

variable "subnet_D_cidr_block" {
  description = "Value for the pub-subnet-C CIDR block"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zone_A" {
  description = "availability zone for public subnets A and B"
  type        = string
  default     = ""
}

variable "availability_zone_B" {
  description = "availability zone for public subnets C and D"
  type        = string
  default     = ""
}

variable "key_pair_name" {
  description = "EC2 key pair"
  type        = string
  default     = ""
}

variable "vm_type" {
  description = "type of instance used- free tier eligible"
  type        = string
  default     = "t2.micro"
}

variable "ami_value" {
  description = "ami for ubuntu 20.04LTS deployed- free tier eligible"
  type        = string
  default     = ""
}

variable "ssl_certificate_arn" {
  description = "SSL certificate for the domain name"
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "Hosted zone ID for domain name"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "domain name for Application Load Balancer"
  type        = string
  default     = ""
}

variable "sub_domain_name" {
  description = "sub-domain name for Application Load Balancer"
  type        = string
  default     = ""
}
