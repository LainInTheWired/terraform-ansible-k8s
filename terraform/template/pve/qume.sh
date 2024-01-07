# やり方1
qm create 9300 --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
qm set 9300 --scsi0 ceph:0,import-from=/root/ubuntu-20.04-server-cloudimg-amd64.img
qm set 9300 --ide2 ceph:cloudinit
qm set 9300 --serial0 socket --vga serial0
qm template 9300

# やり方２
qm create 9200 --memory 2048 --core 2 --name ubuntu-cloud --net0 virtio,bridge=vmbr0
qm importdisk 9200 jammy-server-cloudimg-amd64.img ceph
qm set 9200 --scsihw virtio-scsi-pci --scsi0 ceph:vm-9200-disk-0

qm set 9200 --ide2 ceph:cloudinit
qm set 9200 --boot c --bootdisk scsi0
qm set 9200 --serial0 socket --vga serial0
qm template 9200

# やってみよう
qm create 9300 --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
qm importdisk 9200 /root/ubuntu-20.04-server-cloudimg-amd64.img ceph
qm set 9300 --scsi0 ceph:0,import-from=/root/ubuntu-20.04-server-cloudimg-amd64.img
qm set 9200 --boot c --bootdisk scsi0


qm set 9300 --ide2 ceph:cloudinit
qm set 9300 --serial0 socket --vga serial0
qm template 9300

# やってみよう改
qm create 9300 --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
qm set 9300 --scsi0 ceph:0,import-from=/root/ubuntu-20.04-server-cloudimg-amd64.img
qm set 9300 --boot c --bootdisk scsi0
qm set 9300 --ide2 ceph:cloudinit
qm set 9300 --serial0 socket --vga serial0
qm template 9300


qm clone 9300 112 --name ubuntu2
qm set 112 --sshkey /tmp/kimu_id_rsa.pub
qm set 112 --ipconfig0 ip=10.0.1.45/24,gw=10.0.1.1