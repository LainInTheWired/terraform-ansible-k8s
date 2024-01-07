resource "null_resource" "ansible-provision"{
    depends_on=["proxmox_vm_qemu.Worker","proxmox_vm_qemu.Master"]

    provisioner "local-exec" {
        command = "export MASTER1=${proxmox_vm_qemu.Master[0].ipconfig0}"
    }

    provisioner "local-exec" {
        command = "echo \"[kube-master]\" >>../../../kubespray/inventory/inventory"
    }

    provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s ip=%s access_ip=%s",proxmox_vm_qemu.Master.*.name,proxmox_vm_qemu.Master.*.ipconfig0,proxmox_vm_qemu.Master.*.ipconfig0,proxmox_vm_qemu.Master.*.ipconfig0))}\" >>../../../kubespray/inventory/inventory"
    }
    provisioner "local-exec" {
        command = "echo \"[etcd]\" >>../../../kubespray/inventory/inventory"
    }

     provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s ip=%s access_ip=%s",proxmox_vm_qemu.Master.*.name,proxmox_vm_qemu.Master.*.ipconfig0,proxmox_vm_qemu.Master.*.ipconfig0,proxmox_vm_qemu.Master.*.ipconfig0))}\" >>../../../kubespray/inventory/inventory"
    }

    provisioner "local-exec" {
        command = "echo \"[kube-node]\" >>../../../kubespray/inventory/inventory"
    }

     provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s ip=%s access_ip=%s",proxmox_vm_qemu.Worker.*.name,proxmox_vm_qemu.Worker.*.ipconfig0,proxmox_vm_qemu.Worker.*.ipconfig0,proxmox_vm_qemu.Worker.*.ipconfig0))}\" >>../../../kubespray/inventory/inventory"
    }
    provisioner "local-exec" {
        command =  "echo \"\n[k8s-cluster:children]\nkube-node\nkube-master\" >>../../../kubespray/inventory/inventory"
    }

    # ssh
    # provisioner "local-exec" {
    #     command =  "sudo scp -oStrictHostKeyChecking=no -r  -i  .key_pair/terraform.id_rsa kubespray/ .key_pair/terraform.id_rsa ubuntu@${proxmox_vm_qemu.Master[0].ipconfig0}:~/"
    # }
    # provisioner "local-exec" {
    # command = <<EOT
    #     sudo ssh -oStrictHostKeyChecking=no -i .key_pair/terraform.id_rsa ubuntu@${proxmox_vm_qemu.Master[0].ipconfig0} <<EOF
    #     echo "\$nrconf{kernelhints} = '0';"
    #     echo "\$nrconf{restart} = 'a';" | sudo tee /etc/needrestart/conf.d/50local.conf
    #     EOF
    #     sudo apt -y upgrade
    #     sudo apt update
    #     sudo apt install -y python3-pip
    #     export PATH=\$PATH:/home/ubuntu/.local/bin
    #     cd kubespray/
    #     pip install -r requirements.txt
    #     export PATH=\$PATH:/home/ubuntu/.local/bin
    #     ansible-playbook -i inventory/inventory -u ubuntu -b -v --private-key=~/terraform.id_rsa cluster.yml
    # EOT
    # }
    
}