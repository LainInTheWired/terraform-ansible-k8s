# provider.tf
terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = ">= 2.0.0" 
    }
  }
}
variable "tr_pve_url" {
  type = string
}
variable "tr_pve_user" {
  type = string
}
variable "tr_pve_password" {
  type = string
}
# 设置 Proxmox Provider
provider "proxmox" {
  pm_api_url   = var.tr_pve_url # Proxmox API 地址
  pm_user      = var.tr_pve_url # Proxmox 用户名
  pm_password  = var.tr_pve_password  
}
