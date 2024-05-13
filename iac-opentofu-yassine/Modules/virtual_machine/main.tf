resource "azurerm_linux_virtual_machine" "JumVm" {
    name                                = var.name
    location                            = var.location
    resource_group_name                 = var.resource_group_name
    network_interface_ids               = [azurerm_network_interface.nic.id]
    size                                 = var.size
    computer_name                        = var.name
    admin_username                       = var.admin_username
    admin_password                       = var.admin_password
    disable_password_authentication      =  false
    tags                                 = var.tags

    os_disk {
    name                 = "${var.name}-OsDisk"
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    }

    source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
    }
/*
    admin_ssh_key {
    username   = var.vm_user
    public_key = file("~/.ssh/id_rsa")
    }*/

/* # Install kubectl (latest)
  provisioner "remote-exec" {
    inline = [
      "sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl",
      "chmod +x ./kubectl",
      "mv ./kubectl /usr/local/bin/kubectl",
    ]
    connection {
      type     = "ssh"
      user     = var.admin_username
      password = "Hello@12345#"
      host     = azurerm_network_interface.nic.private_ip_address
      timeout  = "4m"
      agent    = false
    }
  }*/

  /*  # Install helm v3 (latest)
      provisioner "remote-exec" {
      inline = [
        "sudo apt-get update -y",
        "sudo apt-get upgrade -y",
        "sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3",
        "chmod 700 get_helm.sh",
        "./get_helm.sh",
      ]
    }

    # Install Azure CLI (latest)
      provisioner "remote-exec" {
      inline = [
        "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
      ]
    }*/
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name}-Nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [azurerm_network_security_group.nsg]
}


