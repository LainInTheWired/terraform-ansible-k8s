resource "null_resource" "ansible-provision"{
    depends_on=["aws_instance.Worker","aws_instance.Master"]

    provisioner "local-exec" {
        command = "echo \"[kube-master]\" >> kubespray/inventory/inventory"
    }

    provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s",aws_instance.Master.*.public_ip))}\" >> kubespray/inventory/inventory"
    }

       provisioner "local-exec" {
        command = "echo \"[kube-node]\" >> kubespray/inventory/inventory"
    }

     provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s",aws_instance.Worker.*.public_ip))}\" >> kubespray/inventory/inventory"
    }
}