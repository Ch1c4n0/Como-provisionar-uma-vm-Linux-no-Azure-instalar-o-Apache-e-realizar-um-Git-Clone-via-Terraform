resource "azurerm_public_ip" "my-public-ip" {
  name                    = "Public-ip-${var.name}"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}

resource "azurerm_network_interface" "mynetworkinterface" {
  name                = "network-interface-${var.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal-${var.name}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my-public-ip.id



  }
}

resource "azurerm_linux_virtual_machine" "myvmlinuxvm1" {
  name                = "vm-${var.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.my_virtual_machine_size

    network_interface_ids = [
    azurerm_network_interface.mynetworkinterface.id,
  ]

  computer_name                   = "vm-${var.name}"
  admin_username                  = "chicano"
  admin_password                  = var.my_virtual_machine_password
  disable_password_authentication = false

    os_disk {
    name                 = "vmdisk-${var.name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

    provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y apache2",
      "sudo apt install -y git",
      "sudo mkdir -p /var/www/app",
      "sudo git -C /var/www/app/ clone https://Ch1c4n0:TOKEN@github.com/Ch1c4n0/public_html.git",
      "sudo mv /var/www/app/public_html /var/www/public_html",
      "sudo sed -i 's/html/public_html/' /etc/apache2/sites-available/000-default.conf",
      "sudo a2ensite 000-default.conf",
      "sudo systemctl restart apache2"

    ]

    connection {
      type     = "ssh"
      host     = azurerm_linux_virtual_machine.myvmlinuxvm1.public_ip_address
      user     = azurerm_linux_virtual_machine.myvmlinuxvm1.admin_username
      password = var.my_virtual_machine_password
    }


  }


}
