variable "name" {
    type = string
    default = "prod"
  
}

variable "location" {
  type = string
  default = "eastus"
}

variable "my_virtual_machine_size" {
  default     = "Standard_B2s"
  description = "Size of the Virtual Machine"
}

variable "my_virtual_machine_password" {
  default     = "PapaBento@"
  description = "Password of the Virtual Machine"
}