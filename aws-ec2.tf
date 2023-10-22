#----------------------------------------
# EC2インスタンスの作成
#----------------------------------------
resource "aws_instance" "Master" {
  count = 2
  ami                    = "ami-053b0d53c279acc90" # ubuntu22:04
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.sample_subnet.id
  private_ip            = ["10.0.1.${count.index + 1}"]
  key_name               = aws_key_pair.key_pair.id
  vpc_security_group_ids = [aws_security_group.sample_sg.id]
  tags = {
    Name = "master${count.index + 1}"
  }
}
#----------------------------------------
# EC2インスタンスの作成
#----------------------------------------
resource "aws_instance" "Worker" {
  count = 3
  ami                    = "ami-053b0d53c279acc90" # ubuntu22:04
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.sample_subnet.id
    private_ip            = ["10.0.1.1${count.index + 1}"]

  key_name               = aws_key_pair.key_pair.id
  vpc_security_group_ids = [aws_security_group.sample_sg.id]
  tags = {
    Name = "worker${count.index + 1}"
  }
}
#----------------------------------------
# EC2インスタンスの作成
#----------------------------------------
# resource "aws_instance" "etcd" {
#   count = 3
#   ami                    = "ami-053b0d53c279acc90" # ubuntu22:04
#   instance_type          = "t3.medium"
#   subnet_id              = aws_subnet.sample_subnet.id
#   key_name               = aws_key_pair.key_pair.id
#   vpc_security_group_ids = [aws_security_group.sample_sg.id]
#   tags = {
#     Name = "etcd${count.index + 1}"
#   }
# }
#----------------------------------------
# EC2インスタンスの作成
#----------------------------------------
# resource "aws_instance" "sample_web_server" {
#   ami                    = "ami-053b0d53c279acc90" # ubuntu22:04
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.sample_subnet.id
#   key_name               = aws_key_pair.key_pair.id
#   vpc_security_group_ids = [aws_security_group.sample_sg.id]
  
#   provisioner "remote-exec" {
#     inline = ["echo 'connect ssh'"]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file(local.private_key_file)
#       host        = aws_instance.sample_web_server.public_ip
#     }
#   }
#   provisioner "local-exec" {
#     command = "ansible-playbook  -i ${aws_instance.sample_web_server.public_ip}, --private-key .key_pair/terraform.id_rsa nginx.yaml"
#   }
# }