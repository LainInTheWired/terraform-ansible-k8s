resource "null_resource" "ansible-provision"{
    depends_on=["aws_instance.Worker","aws_instance.Master"]
    provisioner "local-exec" {
        command = "export MASTER1=${aws_instance.Master[0].public_ip}"
    }

    provisioner "local-exec" {
        command = "echo \"[kube-master]\" >> kubespray/inventory/my-cluster/inventory.ini"
    }

    provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s ip=%s access_ip=%s",aws_instance.Master.*.tags.Name,aws_instance.Master.*.public_ip,aws_instance.Master.*.private_ip,aws_instance.Master.*.private_ip))}\" >> kubespray/inventory/my-cluster/inventory.ini"
    }
    provisioner "local-exec" {
        command = "echo \"[etcd]\" >> kubespray/inventory/my-cluster/inventory.ini"
    }

     provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s ip=%s access_ip=%s",aws_instance.Master.*.tags.Name,aws_instance.Master.*.public_ip,aws_instance.Master.*.private_ip,aws_instance.Master.*.private_ip))}\" >> kubespray/inventory/my-cluster/inventory.ini"
    }

    provisioner "local-exec" {
        command = "echo \"[kube-node]\" >> kubespray/inventory/my-cluster/inventory.ini"
    }

     provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s ip=%s access_ip=%s",aws_instance.Worker.*.tags.Name,aws_instance.Worker.*.public_ip,aws_instance.Worker.*.private_ip,aws_instance.Worker.*.private_ip))}\" >> kubespray/inventory/my-cluster/inventory.ini"
    }
    provisioner "local-exec" {
        command =  "echo \"\n[k8s-cluster:children]\nkube-node\nkube-master\" >> kubespray/inventory/my-cluster/inventory.ini"
    }

    # ssh
    provisioner "local-exec" {
        command =  "tar -czvf kubespray.tar.gz kubespray && sudo scp -oStrictHostKeyChecking=no   -i  .key_pair/terraform.id_rsa kubespray.tar.gz .key_pair/terraform.id_rsa ubuntu@${aws_instance.Master[0].public_ip}:~/"
    }
    provisioner "local-exec" {
    command = <<EOT
        sudo ssh -oStrictHostKeyChecking=no -i .key_pair/terraform.id_rsa ubuntu@${aws_instance.Master[0].public_ip} <<EOF
        echo "\$nrconf{kernelhints} = '0';"
        echo "\$nrconf{restart} = 'a';" | sudo tee /etc/needrestart/conf.d/50local.conf
        EOF
        tar -xzvf /path/to/destination/kubespray.tar.gz
        sudo apt -y upgrade
        sudo apt update
        sudo apt install -y python3-pip
        export PATH=\$PATH:/home/ubuntu/.local/bin
        cd kubespray/
        pip install -r requirements.txt
        export PATH=\$PATH:/home/ubuntu/.local/bin
        ansible-playbook -i inventory/my-cluster/inventory.ini -u ubuntu -b -v --private-key=~/terraform.id_rsa cluster.yml
    EOT
    }
    
}