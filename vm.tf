 provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "mahi" {
    ami = "ami-0277155c3f0ab2930"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.allow_tls.id]
  
}

resource "aws_eip" "mahi" {
    domain = "vpc"
}

resource "aws_security_group" "allow_tls" {
  name = "allow_tls"
  description = "Allow  TLS inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${aws_eip.mahi.public_ip}/32"]
  }
  ingress {
    description = "mahi"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

/*
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.mahi.id
  allocation_id = aws_eip.mahi.id
}

resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = "${aws_ebs_volume.mahi.id}"

  tags = {
    Name = "HelloWorld_snap"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvda"
  volume_id   = aws_ebs_volume.defaults.id
  instance_id = aws_instance.web.id
}
*/
resource "aws_instance" "web" {
  ami               = "ami-0277155c3f0ab2930"
  instance_type     = "t2.micro"
  
  root_block_device {
    volume_size = 30 # in GB <<----- I increased this!
    volume_type = "gp3"
    encrypted   = true
  }
  tags = {
    Name = "HelloWorld"
  }
}
/*
resource "aws_ebs_volume" "defaults" {
  size              = 30
  availability_zone = "${aws_instance.web.availability_zone}"
}
