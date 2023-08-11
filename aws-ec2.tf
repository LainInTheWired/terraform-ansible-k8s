#----------------------------------------
# EC2インスタンスの作成
#----------------------------------------
resource "aws_instance" "appache" {
  count = 1
  ami                    = "ami-053b0d53c279acc90" # ubuntu22:04
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.sample_subnet.id
  key_name               = aws_key_pair.key_pair.id
  vpc_security_group_ids = [aws_security_group.sample_sg.id]
  
  user_data = <<EOF
#! /bin/bash
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
EOF
}
#----------------------------------------
# EC2インスタンスの作成
#----------------------------------------
resource "aws_instance" "sample_web_server" {
  ami                    = "ami-053b0d53c279acc90" # ubuntu22:04
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.sample_subnet.id
  key_name               = aws_key_pair.key_pair.id
  vpc_security_group_ids = [aws_security_group.sample_sg.id]
  
  provisioner "remote-exec" {
    inline = ["sudo yum -y install nginx",
              "sudo systemclt start nginx"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(local.private_key_file)
      host        = aws_instance.sample_web_server.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.sample_web_server.public_ip}, --private-key ${module.aws-keypair.private_key_file} nginx.yaml"
  }
}