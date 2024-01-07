# provider.tf
terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = ">= 2.0.0" 
    }
  }
}
# 设置 Proxmox Provider
provider "proxmox" {
  pm_api_url   = "https://10.0.1.30:8006/api2/json" # Proxmox API 地址
  pm_user      = "root@pam" # Proxmox 用户名
  pm_password  = "rinriN@PVE01"  
}
