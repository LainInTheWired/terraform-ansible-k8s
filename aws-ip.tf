resource "null_resource" "ansible-provision"{
    depends_on=["aws_instance.Worker","aws_instance.Master"]

    provisioner "local-exec" {
        command = "echo \"[kube-master]\" >> kubespray/inventory/inventory"
    }

    provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s",aws_instance.Master.*.tags.Name,aws_instance.Master.*.public_ip))}\" >> kubespray/inventory/inventory"
    }
    provisioner "local-exec" {
        command = "echo \"[etcd]\" >> kubespray/inventory/inventory"
    }

     provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s",aws_instance.etcd.*.tags.Name,aws_instance.etcd.*.public_ip))}\" >> kubespray/inventory/inventory"
    }

    provisioner "local-exec" {
        command = "echo \"[kube-node]\" >> kubespray/inventory/inventory"
    }

     provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s",aws_instance.Worker.*.tags.Name,aws_instance.Worker.*.public_ip))}\" >> kubespray/inventory/inventory"
    }
    provisioner "local-exec" {
        command =  "echo \"\n[k8s-cluster:children]\nkube-node\nkube-master\" >> kubespray/inventory/inventory"
    }
}