variable "environment"      { type = string }
variable "vm_count"         { type = number; default = 3 }
variable "ram_mb"           { type = number; default = 4096 }
variable "vcpu"             { type = number; default = 2 }
variable "disk_os"          { type = number; default = 20 }
variable "disk_extra_size"  { type = number; default = 1 }
variable "extra_disk_count" { type = number; default = 4 }
variable "ssh_key_path"     { type = string; default = "~/.ssh/id_ed25519.pub" }
variable "vm_user"          { type = string; default = "debianadmin" }

# Variables spécifiques Cloud
variable "gcp_project_id"   { type = string; default = "" }
variable "azure_location"   { type = string; default = "France Central" }
