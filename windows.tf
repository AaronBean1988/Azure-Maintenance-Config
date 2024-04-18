resource "azurerm_network_interface" "nic" {
  name                = "test-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name 

  ip_configuration {
    name                          = "test-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id 
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_resource_group.rg] 
}

resource "azurerm_windows_virtual_machine" "avd_vm" {
  name                  = "test-vm"
  resource_group_name   = azurerm_resource_group.rg.name 
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_D4s_v4"
  admin_username        = "testing"
  admin_password        = "Password123!"
  network_interface_ids = [azurerm_network_interface.nic.id]
  patch_mode            = "AutomaticByPlatform"
  bypass_platform_safety_checks_on_user_schedule_enabled = true

  os_disk {
    name                 = "testvm-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  depends_on = [azurerm_resource_group.rg] 
}

resource "azurerm_maintenance_configuration" "dailywindows" {
  name                = "Daily-WindowsServers"
  resource_group_name = azurerm_resource_group.rg.name 
  location            = azurerm_resource_group.rg.location
  scope               = "InGuestPatch"
  in_guest_user_patch_mode = "User"
 
  install_patches {
    reboot = "Never"
    windows {
      classifications_to_include = ["Definition"]
    }
  }
 
  window {
    time_zone = "Eastern Standard Time"
    start_date_time = "2024-04-18 12:00"
    duration = "03:00"
    recur_every = "Day"
  }
}

resource "azurerm_maintenance_assignment_virtual_machine" "assignment" {
  location                     = azurerm_resource_group.rg.location
  maintenance_configuration_id = azurerm_maintenance_configuration.dailywindows.id
  virtual_machine_id           = azurerm_windows_virtual_machine.avd_vm.id 
}