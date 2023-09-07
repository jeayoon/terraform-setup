variable "ami" {
  type    = string
  default = "ami-04a735b489d2a0320"
}

variable "key_name" {
  type    = string
  default = "ec2-key"
}

variable "pub_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCapVcSWz7rJ6bN7IsPfGB1i3bWzIT8y4ARG60XUaICrwxW/Zp+wN/aBhidsXET7nq2rLd4YBEgdVDKbeZCJMscoZG5JDVqo41ocSZJ+QHwfaFgZeJm2TGcMA92v9MkAMy6NWgcjW8iUGjx4TVMMh1KR/P3nIp6ch+V/PGqJYy3Hkyi0EcHE68TPw2lfwNl9Ak0DHUCPYCH5bmLFd8msq3YHuh78bn4JBtDb2fOtCMYvbbT8ED3VPMMS1k1lYB4mHgxV+njz2QyJNE2+ytjKeuVFcX82s0Oj2qCoVT9uTJeqxvyrVza569bMbU8NwhMuKJpVl6hx0HEnAlXtKpgt5pl"
}

variable "rt_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "sb_cidr" {
  type    = string
  default = "10.0.10.0/24"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

