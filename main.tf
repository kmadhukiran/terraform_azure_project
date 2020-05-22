provider "azurerm" {
version = "2.2.0"
    #subscription_id = "${var.subscription_id}"
    #client_id       = "${Client_ID}"
    #client_secret   = "${Client Secret}"
    #tenant_id       = "${Tenant_ID}"
features{}
}
resource "azurerm_resource_group" "Atmecs"{
    name      = "AtmecsGroup"
    location  = "westus"
}
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "AtmecsVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "westus"
    resource_group_name = "${azurerm_resource_group.Atmecs.name}"
    }
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"
    resource_group_name  = "${azurerm_resource_group.Atmecs.name}"
    virtual_network_name = "AtmecsVnet"
    address_prefix       = "10.0.1.0/24"
}
resource "azurerm_network_interface" "myterraformNIC" {
  name                = "AtmecsNICgroup"
  location            = "westus"
  resource_group_name = "${azurerm_resource_group.Atmecs.name}"

  ip_configuration {
    name                          = "AtmecsNICgroupconfig"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.myterraformPIP.id}"
  }
}
resource "azurerm_public_ip" "myterraformPIP" {
  name                    = "public_ip"
  location                = "westus"
  resource_group_name     = "${azurerm_resource_group.Atmecs.name}"
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}
resource "azurerm_network_security_group" "myterraformsecurity" {
    name                = "AtmecsSecurity"
    location            = "westus"
    resource_group_name = "${azurerm_resource_group.Atmecs.name}"
        security_rule {
        name                    = "AllowSSH"
        priority                = 100
        direction               = "Inbound"
        access                  = "Allow"
        protocol                = "Tcp"
        source_port_range       = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"

  }

  security_rule {
        name                    = "AllowHTTP"
        priority                = 200
        direction               = "Inbound"
        access                  = "Allow"
         protocol                = "Tcp"
        source_port_range       = "*"
    destination_port_range      = "8080"
    source_address_prefix       = "Internet"
    destination_address_prefix  = "*"
  }
}
resource "azurerm_network_interface_security_group_association" "myterraformassociation" {
network_security_group_id = "${azurerm_network_security_group.myterraformsecurity.id}"
network_interface_id = "${azurerm_network_interface.myterraformNIC.id}"
}
resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "AtmecsVm"
    location              = "westus"
    resource_group_name   = "${azurerm_resource_group.Atmecs.name}"
    network_interface_ids = ["${azurerm_network_interface.myterraformNIC.id}"]
     vm_size               = "Standard_D2"
    count                 = "1"

    storage_os_disk {
        name              = "AtmecsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"

    }
    storage_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7.5"
        version   = "latest"
    }
    os_profile {
        computer_name  = "Albertson"
        admin_username = "Atmecs"
        admin_password = "Atmecs@123456"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
    connection {
        type = "ssh"
        host = "testvm"
        user = "azureuser"
        port = "22"
        agent = false
    }
}


