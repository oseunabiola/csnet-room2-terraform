variable "main_vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "csnet-room2-vpc"
}

variable "main_vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "pub_subnet1_name" {
  description = "The name of the public subnet 1"
  type        = string
  default     = "room2-pub-SUBNET1"
}

variable "pub_subnet1_cidr_block" {
  description = "The CIDR block for the public subnet 1"
  type        = string
  default     = "10.1.10.0/24"
}

variable "subnet1_az" {
  description = "The availability zone for the public subnet 1"
  type        = string
  default     = "us-east-1a"
}

variable "priv_subnet1_name" {
  description = "The name of the private subnet 1"
  type        = string
  default     = "room2-priv-SUBNET1"
}

variable "priv_subnet1_cidr_block" {
  description = "The CIDR block for the private subnet 1"
  type        = string
  default     = "10.1.11.0/24"
}

variable "pub_subnet2_name" {
  description = "The name of the public subnet 2"
  type        = string
  default     = "room2-pub-SUBNET2"
}

variable "pub_subnet2_cidr_block" {
  description = "The CIDR block for the public subnet 2"
  type        = string
  default     = "10.1.20.0/24"
}

variable "subnet2_az" {
  description = "The availability zone for the public subnet 2"
  type        = string
  default     = "us-east-1b"
}

variable "priv_subnet2_name" {
  description = "The name of the private subnet 2"
  type        = string
  default     = "room2-priv-SUBNET2"
}

variable "priv_subnet2_cidr_block" {
  description = "The CIDR block for the private subnet 2"
  type        = string
  default     = "10.1.21.0/24"
}

variable "pub_route_table_name" {
  description = "The name of the public route table"
  type        = string
  default     = "room2-pub-RT"
}

variable "priv_route_table_name" {
  description = "The name of the private route table"
  type        = string
  default     = "room2-priv-RT"
}

variable "main_igw_name" {
  description = "The name of the internet gateway"
  type        = string
  default     = "room2-IGW"
}

variable "main_nat_gw_name" {
  description = "The name of the NAT gateway"
  type        = string
  default     = "room2-NAT"
}

variable "main_eip_name" {
  description = "The name of the Elastic IP"
  type        = string
  default     = "room2-EIP"
}