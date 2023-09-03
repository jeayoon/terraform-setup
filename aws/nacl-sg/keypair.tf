data "aws_key_pair" "ec2" {
  key_name           = "test-key"
  include_public_key = true
}