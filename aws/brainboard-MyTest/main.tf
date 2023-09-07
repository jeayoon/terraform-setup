resource "aws_vpc" "main" {
  tags       = merge(var.tags, {})
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, {})
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  tags              = merge(var.tags, {})
  cidr_block        = var.sb_cidr
  availability_zone = "ap-northeast-1a"
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, {})

  route {
    gateway_id = aws_internet_gateway.main.id
    cidr_block = var.rt_cidr
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, {})

  egress {
    to_port   = 0
    protocol  = "-1"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    to_port   = 80
    protocol  = "tcp"
    from_port = 80
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  ingress {
    to_port   = 22
    protocol  = "tcp"
    from_port = 22
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_key_pair" "main" {
  tags       = merge(var.tags, {})
  public_key = var.pub_key
  key_name   = var.key_name
}

resource "aws_instance" "main" {
  tags                        = merge(var.tags, {})
  subnet_id                   = aws_subnet.main.id
  key_name                    = var.key_name
  instance_type               = "t2.micro"
  availability_zone           = "ap-northeast-1a"
  associate_public_ip_address = true
  ami                         = var.ami

  depends_on = [
    aws_key_pair.main,
  ]

  security_groups = [
    aws_security_group.main.id,
  ]
}

resource "aws_eip" "main" {
  vpc      = true
  tags     = merge(var.tags, {})
  instance = aws_instance.main.id
}

