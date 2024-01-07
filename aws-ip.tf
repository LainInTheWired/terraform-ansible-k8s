resource "null_resource" "ansible-provision" {
    depends_on = [aws_instance.Worker, aws_instance.Master]

    # Define MASTER1 environment variable
    provisioner "local-exec" {
        command = "export MASTER1=${aws_instance.Master[0].public_ip}"
    }

    # Initialize inventory file
    provisioner "local-exec" {
        command = "echo \"[kube-master]\" > kubespray/inventory/my-cluster/inventory.ini"
    }

    # Add master nodes to inventory
    provisioner "local-exec" {
        command = "echo \"${join("\n", formatlist("%s ansible_ssh_host=%s ip=%s access_ip=%s", aws_instance.Master.*.tags.Name, aws_instance.Master.*.public_ip, aws_instance.Master.*.private_ip, aws_instance.Master.*.private_ip))}\" >> kubespray/inventory/my-cluster/inventory.ini"
    }

    # Add etcd section to inventory
    provisioner "local-exec" {
        command = "echo \"[etcd]\" >> kubespray/inventory/my-cluster/inventory.ini"
    }

    # Add worker nodes to inventory
    provisioner "local-exec" {
        command = "echo \"[kube-node]\" >> kubespray/inventory/my-cluster/inventory.ini"
    }

    provisioner "local-exec" {
        command = "echo \"${join("\n", formatlist("%s ansible_ssh_host=%s ip=%s access_ip=%s", aws_instance.Worker.*.tags.Name, aws_instance.Worker.*.public_ip, aws_instance.Worker.*.private_ip, aws_instance.Worker.*.private_ip))}\" >> kubespray/inventory/my-cluster/inventory.ini"
    }

    # Define k8s-cluster group
    provisioner "local-exec" {
        command = "echo \"\n[k8s-cluster:children]\nkube-node\nkube-master\" >> kubespray/inventory/my-cluster/inventory.ini"
    }

    # Compress and copy the Kubespray directory to the master node
    provisioner "local-exec" {
        command = "tar -czvf kubespray.tar.gz -C kubespray . && scp -o StrictHostKeyChecking=no -i .key_pair/terraform.id_rsa .key_pair/terraform.id_rsa  kubespray.tar.gz ubuntu@${aws_instance.Master[0].public_ip}:~/"
    }

    # SSH into the master node and run the setup commands
    provisioner "local-exec" {
        command = <<EOT
            ssh -o StrictHostKeyChecking=no -i .key_pair/terraform.id_rsa ubuntu@${aws_instance.Master[0].public_ip} 'bash -s' <<EOF
            echo "\$nrconf{kernelhints} = '0';" | sudo tee /etc/needrestart/conf.d/50local.conf
            echo "\$nrconf{restart} = 'a';" | sudo tee -a /etc/needrestart/conf.d/50local.conf
            sudo mkdir kubespray
            sudo tar -xzvf kubespray.tar.gz -C kubespray
            sudo apt -y upgrade
            sudo apt update
            sudo apt install -y python3-pip
            export PATH=\$PATH:/home/ubuntu/.local/bin
            cd kubespray
            pip install -r requirements.txt
            ansible-playbook -i inventory/my-cluster/inventory.ini -u ubuntu -b -v --private-key=~/terraform.id_rsa cluster.yml
            EOF
        EOT
    }
}