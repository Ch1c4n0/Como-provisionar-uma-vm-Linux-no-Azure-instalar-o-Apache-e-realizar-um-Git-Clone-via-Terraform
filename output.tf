output "web_vm_ip_address" {
  description = "Virtual Machine name IP Address"
  value       = azurerm_linux_virtual_machine.myvmlinuxvm1.public_ip_address
}