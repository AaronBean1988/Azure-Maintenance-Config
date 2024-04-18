resource "azurerm_network_interface" "nic" {
  name                = "test-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name 

  ip_configuration {
    name                          = "test-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id 
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "avd_vm" {
  name                  = "test-vm"
  resource_group_name   = azurerm_resource_group.rg.name 
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_D4s_v4"
  admin_username        = "admin"
  admin_password        = "Password123!"
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    name                 = "testvm-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-23h2-avd-m365"
    version   = "latest"
  }
}