resource "null_resource" "ansible-provision"{
    depends_on=["aws_instance.Worker","aws_instance.Master"]

    provisioner "local-exec" {
        command = "export MASTER1=${aws_instance.Master[0].public_ip}"
    }

    provisioner "local-exec" {
        command = "echo \"[kube-master]\" >> kubespray/inventory/inventory"
    }

    provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s ip=%s access_ip=%s",aws_instance.Master.*.tags.Name,aws_instance.Master.*.public_ip,aws_instance.Master.*.private_ip,aws_instance.Master.*.private_ip))}\" >> kubespray/inventory/inventory"
    }
    provisioner "local-exec" {
        command = "echo \"[etcd]\" >> kubespray/inventory/inventory"
    }

     provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s ip=%s access_ip=%s",aws_instance.Master.*.tags.Name,aws_instance.Master.*.public_ip,aws_instance.Master.*.private_ip,aws_instance.Master.*.private_ip))}\" >> kubespray/inventory/inventory"
    }

    provisioner "local-exec" {
        command = "echo \"[kube-node]\" >> kubespray/inventory/inventory"
    }

     provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s ip=%s access_ip=%s",aws_instance.Worker.*.tags.Name,aws_instance.Worker.*.public_ip,aws_instance.Worker.*.private_ip,aws_instance.Worker.*.private_ip))}\" >> kubespray/inventory/inventory"
    }
    provisioner "local-exec" {
        command =  "echo \"\n[k8s-cluster:children]\nkube-node\nkube-master\" >> kubespray/inventory/inventory"
    }
}