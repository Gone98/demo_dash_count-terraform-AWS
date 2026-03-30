resource "aws_instance" "dashboard_instance" {
  ami                         = "ami-0f8faa29480e7e6de"
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.dashboard_subnet.id
  security_groups             = [aws_security_group.dashboard_sg.id]
  key_name                    = aws_key_pair.private_key_pair.key_name
  private_ip                  = var.dashboard_private_ip
  user_data                   = file("shell_scripts/dashboard.sh")
  tags = {
    Name      = "Dashboard Instance"
    terraform = "true"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.private_key.private_key_openssh
  }

  provisioner "file" {
    content     = tls_private_key.private_key.private_key_openssh
    destination = "/home/ubuntu/${local.private_key_file}"
  }

  provisioner "remote-exec" {
    inline = ["chmod 400 /home/ubuntu/${local.private_key_file}"]
  }
}

resource "aws_instance" "counting_instance" {
  ami                         = "ami-0f8faa29480e7e6de"
  instance_type               = var.instance_type
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.counting_subnet.id
  vpc_security_group_ids      = [aws_security_group.counting_sg.id]
  key_name                    = aws_key_pair.private_key_pair.key_name
  private_ip                  = var.counting_private_ip
  user_data                   = file("shell_scripts/counting.sh")
  tags = {
    Name      = "Counting Instance"
    terraform = "true"
  }
}

resource "tls_private_key" "private_key" {
  algorithm = "ED25519"
}

locals {
  private_key_file = "dashboard-and-counting-ssh-key.pem"
}

resource "aws_key_pair" "private_key_pair" {
  key_name   = local.private_key_file
  public_key = tls_private_key.private_key.public_key_openssh
}
