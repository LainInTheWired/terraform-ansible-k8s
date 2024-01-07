resource "proxmox_vm_qemu" "Master" {
  name  = "K8s-Master0${count.index + 1}"
  
  desc  = "Ubuntu develop environment"
  count = 1

  target_node = "PVE02"
  clone   = "kimu-ubuntu2004"
  full_clone = true
  # 关机 guest agent
  os_type = "cloud-init"
  onboot  = true
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"

  # CPU
  cores    = 2
  sockets  = 2
  cpu      = "kvm64"
  # 内存
  memory   = 4096

  # 硬盘设置，因计算的方式 101580M 代替 100G
  disk {
    slot     = 0
    size     = "20G"
    type     = "scsi"
    storage  = "ceph"
    iothread = 1
  }

  # 网络
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # 记住这里要使用IP CIDR。因为只创建一个虚拟机，虚拟机的 IP 是 192.168.1.91。如果要创建多个虚拟机的话，IP 将会是 .91、.92、.93 。
  ipconfig0 = "ip=10.0.1.${count.index + 41}/24,gw=10.0.1.1"

  # 用户名和 SSH key
  ciuser  = "user"
  cipassword = "ecc"
  sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDm2l3E3a43hRvmCc1KCf69AekpQ8N5I/mX9TA2rLqf65O/EO4mG2AxQpR1DAIzLdfy2VavclBbgTUfohRddCaUSD6rkfnVjoQ9mZ0aYTKWHWfT7YDXsZHvCm9cmjkqIdYwQgHjlNorl2mb3XbKLvOlhp2xNZcUR91qKW62nzAPZ8Nw/q/ViuFfAGnLSaZ755rptY8FaeXmvoVq6tfNW0T4u7t7NhEwkX8PFkOCEIM2lt75nZHFuBWvM1cPbA5tgX9dwjAt7fFC3IdQCDph8an1Rp4UQpuqJNNp3orwfGfEcppfYgB7Ru8Yz2KeaAD/Zoa93m26RF3e9zXdXtsCjfl41cNbPvmIwrVDnzGwlkNiuKnhRcOo5kbGbUGsdchlZhbqSzRcr76jUBOqM3t5P9Ff0Xbt8XQMKpo6hDjgE6B3vgFmbEpmof70BtjnkZ7DsrCCDKNsbYuh3jNthUyb7GHTc4k4Cd1WDbWkmH6IvmaM5nGhZpZaUuuL3G9WJKYFhkjkGWrjETXGWYE64LHCcr9B0t+89XH2DjD273LubSCfWWtxQwlrJ9c1XPL3bCd9iNpYy03Jx48m5y4Y8C6dwQEOy2cFktegDwBfgbYpvOPhPi89jtuehl8dsk0QIvqN85ikS9AWi6XMKFJ9FWN9XbOcnX69RxsxKaNMJWMIRkzHsw== nowhereman@M2PROMacBook-Pro.local
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkQZytOhn+NQ4o+3t5Pq8ikROG3sdGYiMloM7QJRtZgxGul2qouC0uvCyuXF+rVcx7Boq7z8hYrNLPz5B30bB8zNENGrs75sXTz1GO9ZPSouNuipBGxYyVrKorjnwxrsGpt3q4yaC8fJLTqCNrA5dLG6h1xv8POr4B81x++ZN63tZQy+d88eictkf7rREYuLiuDTd9KrU/u7xto9ChVriNJSX0FG/eSjZLYCJtViGKNS8q6vHd3eDxccLPX9EBB8vydB6P6A3PLwwKoFyboqpUhHK2v09OtmvFuot5L035E9UVO6VwKmWlu3bjc7REWMeNeafi/Uit52xEYmq6aDGT9Ej9g58mAl/HQP+WhmV7azcea8kXAdMxWK7kUxW03DYEfbV9YlSQOwlCTkSyGsNqdfyzNYTzajyDfjc1t0Ia3u5ojZ4gAsm3hvX5jDKmuKyFKiAP3T/p8IfSvUva4iYq3RF5YKZGzH4tffhaYMNtXX8xgxjzMru9m9cGpCw5zhE= root@11cd3eed5f8a
  EOF
}


resource "proxmox_vm_qemu" "Worker" {
  name  = "K8s-Worker0${count.index + 1}"
  
  desc  = "Ubuntu develop environment"

  target_node = "PVE0${count.index + 1}"

  count = 3

  clone   = "kimu-ubuntu2004"
  full_clone = true
  # 关机 guest agent
  os_type = "cloud-init"
  onboot  = true
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"

  # CPU
  cores    = 2
  sockets  = 2
  cpu      = "kvm64"
  # 内存
  memory   = 4096

  # 硬盘设置，因计算的方式 101580M 代替 100G
  disk {
    slot     = 0
    size     = "20G"
    type     = "scsi"
    storage  = "ceph"
    iothread = 1
  }

  # 网络
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # 记住这里要使用IP CIDR。因为只创建一个虚拟机，虚拟机的 IP 是 192.168.1.91。如果要创建多个虚拟机的话，IP 将会是 .91、.92、.93 。
  ipconfig0 = "ip=10.0.1.${count.index + 45}/24,gw=10.0.1.1"

  # 用户名和 SSH key
  ciuser  = "user"
  cipassword = "ecc"
  sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDm2l3E3a43hRvmCc1KCf69AekpQ8N5I/mX9TA2rLqf65O/EO4mG2AxQpR1DAIzLdfy2VavclBbgTUfohRddCaUSD6rkfnVjoQ9mZ0aYTKWHWfT7YDXsZHvCm9cmjkqIdYwQgHjlNorl2mb3XbKLvOlhp2xNZcUR91qKW62nzAPZ8Nw/q/ViuFfAGnLSaZ755rptY8FaeXmvoVq6tfNW0T4u7t7NhEwkX8PFkOCEIM2lt75nZHFuBWvM1cPbA5tgX9dwjAt7fFC3IdQCDph8an1Rp4UQpuqJNNp3orwfGfEcppfYgB7Ru8Yz2KeaAD/Zoa93m26RF3e9zXdXtsCjfl41cNbPvmIwrVDnzGwlkNiuKnhRcOo5kbGbUGsdchlZhbqSzRcr76jUBOqM3t5P9Ff0Xbt8XQMKpo6hDjgE6B3vgFmbEpmof70BtjnkZ7DsrCCDKNsbYuh3jNthUyb7GHTc4k4Cd1WDbWkmH6IvmaM5nGhZpZaUuuL3G9WJKYFhkjkGWrjETXGWYE64LHCcr9B0t+89XH2DjD273LubSCfWWtxQwlrJ9c1XPL3bCd9iNpYy03Jx48m5y4Y8C6dwQEOy2cFktegDwBfgbYpvOPhPi89jtuehl8dsk0QIvqN85ikS9AWi6XMKFJ9FWN9XbOcnX69RxsxKaNMJWMIRkzHsw== nowhereman@M2PROMacBook-Pro.local
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkQZytOhn+NQ4o+3t5Pq8ikROG3sdGYiMloM7QJRtZgxGul2qouC0uvCyuXF+rVcx7Boq7z8hYrNLPz5B30bB8zNENGrs75sXTz1GO9ZPSouNuipBGxYyVrKorjnwxrsGpt3q4yaC8fJLTqCNrA5dLG6h1xv8POr4B81x++ZN63tZQy+d88eictkf7rREYuLiuDTd9KrU/u7xto9ChVriNJSX0FG/eSjZLYCJtViGKNS8q6vHd3eDxccLPX9EBB8vydB6P6A3PLwwKoFyboqpUhHK2v09OtmvFuot5L035E9UVO6VwKmWlu3bjc7REWMeNeafi/Uit52xEYmq6aDGT9Ej9g58mAl/HQP+WhmV7azcea8kXAdMxWK7kUxW03DYEfbV9YlSQOwlCTkSyGsNqdfyzNYTzajyDfjc1t0Ia3u5ojZ4gAsm3hvX5jDKmuKyFKiAP3T/p8IfSvUva4iYq3RF5YKZGzH4tffhaYMNtXX8xgxjzMru9m9cGpCw5zhE= root@11cd3eed5f8a
  EOF
}
