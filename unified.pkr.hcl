variable "cpus" {}
variable "disk_size" {}
variable "headless" {}
variable "hostname" {}
variable "http_proxy" {}
variable "https_proxy" {}
variable "iso_checksum" {}
variable "iso_checksum_type" {}
variable "iso_url" {}
variable "memory" {}
variable "no_proxy" {}
variable "ssh_fullname" {}
variable "ssh_password" {}
variable "ssh_username" {}
variable "update" {}
variable "version" {}
variable "virtualbox_guest_os_type" {}
variable "vm_name" {}
variable "home" {}
variable "vram"{}
variable output_directory{}
variable ol7_iso_checksum{}
variable ol7_iso_url{}
variable ol8_iso_checksum{}
variable ol8_iso_url{}

source "virtualbox-iso" "oracle9" {
 
  boot_command= [
        "<esc><wait>",
        "vmlinuz initrd=initrd.img inst.ks=http://172.20.10.2:{{ .HTTPPort }}/ks.cfg",
        "<enter>"
  ]      
  disk_size               = "${var.disk_size}"
  guest_os_type           = "${var.virtualbox_guest_os_type}"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "./http"
  iso_checksum            = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls                = [
    "${var.iso_url}"
  ]
  output_directory        = "${var.output_directory}" 
  shutdown_command        = "echo '${var.ssh_password}'|sudo -S shutdown -P now" 
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_wait_timeout        = "10000s"
  guest_additions_mode    = "disable"
  vboxmanage             = [
    ["modifyvm", "{{ .Name }}", "--audio", "none"], 
    ["modifyvm", "{{ .Name }}", "--usb", "off"],
    ["modifyvm", "{{ .Name }}", "--vram", "${var.vram}"], 
    ["modifyvm", "{{ .Name }}", "--vrde", "off"], 
    ["modifyvm", "{{.Name}}", "--nic1", "bridged"],
    ["modifyvm", "{{.Name}}", "--bridgeadapter1","Intel(R) Wi-Fi 6E AX211 160MHz"],
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], 
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
    // ["modifyvm", "{{ .Name }}", "--natpf1", "guestssh,tcp,,2236,,22"]
  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.vm_name}"
  format                  = "ova"
}





build {
  sources = ["source.virtualbox-iso.oracle9"]
  
  provisioner "file" {
  source      = ".ssh/id_ed25519.pub"
  destination = "/tmp/id_ed25519.pub"
}

provisioner "shell" {
  inline = [
    "mkdir -p /home/packer/.ssh",
    "cat /tmp/id_ed25519.pub >> /home/packer/.ssh/authorized_keys",
    "chmod 600 /home/packer/.ssh/authorized_keys",
    "chown packer:packer /home/packer/.ssh /home/packer/.ssh/authorized_keys",
    "rm /tmp/id_ed25519.pub"
  ]
}  
}

source "virtualbox-iso" "oracle7" {
 
  boot_command= [
        "<tab> text ks=http://172.20.10.2:{{ .HTTPPort }}/ks7.cfg <enter><wait>"
  ]      
  disk_size               = "${var.disk_size}"
  guest_os_type           = "${var.virtualbox_guest_os_type}"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "./http"
  iso_checksum            = "${var.iso_checksum_type}:${var.ol7_iso_checksum}"
  iso_urls                = [
    "${var.ol7_iso_url}"
  ]
  output_directory        = "${var.output_directory}" 
  shutdown_command        = "echo '${var.ssh_password}'|sudo -S shutdown -P now" 
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_wait_timeout        = "10000s"
  guest_additions_mode    = "disable"
  vboxmanage             = [
    ["modifyvm", "{{ .Name }}", "--audio", "none"], 
    ["modifyvm", "{{ .Name }}", "--usb", "off"],
    ["modifyvm", "{{ .Name }}", "--vram", "${var.vram}"], 
    ["modifyvm", "{{ .Name }}", "--vrde", "off"], 
    ["modifyvm", "{{.Name}}", "--nic1", "bridged"],
    ["modifyvm", "{{.Name}}", "--bridgeadapter1","Intel(R) Wi-Fi 6E AX211 160MHz"],
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], 
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.vm_name}"
  format                  = "ova"
}





build {
  sources = ["source.virtualbox-iso.oracle7"]
  
  provisioner "file" {
  source      = ".ssh/id_ed25519.pub"
  destination = "/tmp/id_ed25519.pub"
}

provisioner "shell" {
  inline = [
    "mkdir -p /home/packer/.ssh",
    "cat /tmp/id_ed25519.pub >> /home/packer/.ssh/authorized_keys",
    "chmod 600 /home/packer/.ssh/authorized_keys",
    "chown packer:packer /home/packer/.ssh /home/packer/.ssh/authorized_keys",
    "rm /tmp/id_ed25519.pub"
  ]
}
}

source "virtualbox-iso" "oracle8" {
  boot_command= [
         
        "<esc><wait>",
        "vmlinuz initrd=initrd.img inst.ks=http://172.20.10.2:{{ .HTTPPort }}/ks7.cfg",
        "<enter>"
      ]

  disk_size               = "${var.disk_size}"
  guest_os_type           = "${var.virtualbox_guest_os_type}"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "./http"
  iso_checksum            = "${var.iso_checksum_type}:${var.ol8_iso_checksum}"
  iso_urls                = [
    "${var.ol8_iso_url}"
  ]
  output_directory        = "${var.output_directory}" 
  shutdown_command        = "echo '${var.ssh_password}'|sudo -S shutdown -P now" 
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_wait_timeout        = "10000s"
  guest_additions_mode    = "disable"
  vboxmanage             = [
    ["modifyvm", "{{ .Name }}", "--audio", "none"], 
    ["modifyvm", "{{ .Name }}", "--usb", "off"],
    ["modifyvm", "{{ .Name }}", "--vram", "${var.vram}"], 
    ["modifyvm", "{{ .Name }}", "--vrde", "off"], 
    ["modifyvm", "{{.Name}}", "--nic1", "bridged"],
    ["modifyvm", "{{.Name}}", "--bridgeadapter1","Intel(R) Wi-Fi 6E AX211 160MHz"],
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], 
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.vm_name}"
  format                  = "ova"
}


build {
  sources = ["source.virtualbox-iso.oracle8"]
  
  provisioner "file" {
  source      = ".ssh/id_ed25519.pub"
  destination = "/tmp/id_ed25519.pub"
}

provisioner "shell" {
  inline = [
    "mkdir -p /home/packer/.ssh",
    "cat /tmp/id_ed25519.pub >> /home/packer/.ssh/authorized_keys",
    "chmod 600 /home/packer/.ssh/authorized_keys",
    "chown packer:packer /home/packer/.ssh /home/packer/.ssh/authorized_keys",
    "rm /tmp/id_ed25519.pub"
  ]
}  
}



source "virtualbox-iso" "rhel8" {
 
  boot_command= [  
      "<esc><wait>",
      "vmlinuz initrd=initrd.img inst.ks=http://172.20.10.2:{{.HTTPPort}}/ks-rhel.cfg",
      "<enter>"
      ]

  disk_size               = "${var.disk_size}"
  guest_os_type           = "rhel8-64"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "./http"
  iso_checksum            = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls                = [
    "${var.iso_url}"
  ]
  output_directory        = "${var.output_directory}"
  shutdown_command        = "echo '${var.ssh_password}'|sudo -S shutdown -P now" 
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_wait_timeout        = "10000s"
  guest_additions_mode    = "disable"
  vboxmanage             = [
    ["modifyvm", "{{ .Name }}", "--audio", "none"], 
    ["modifyvm", "{{ .Name }}", "--usb", "off"],
    ["modifyvm", "{{ .Name }}", "--vram", "${var.vram}"],
    ["modifyvm", "{{ .Name }}", "--vrde", "off"], 
    ["modifyvm", "{{.Name}}", "--nic1", "bridged"],
    ["modifyvm", "{{.Name}}", "--bridgeadapter1","Intel(R) Wi-Fi 6E AX211 160MHz"],
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], 
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.vm_name}"
  format                  = "ova"
}

build {
  sources = ["source.virtualbox-iso.rhel8"]
  
  provisioner "file" {
  source      = ".ssh/id_ed25519.pub"
  destination = "/tmp/id_ed25519.pub"
}

provisioner "shell" {
  inline = [
    "mkdir -p /home/packer/.ssh",
    "cat /tmp/id_ed25519.pub >> /home/packer/.ssh/authorized_keys",
    "chmod 600 /home/packer/.ssh/authorized_keys",
    "chown packer:packer /home/packer/.ssh /home/packer/.ssh/authorized_keys",
    "rm /tmp/id_ed25519.pub"
  ]
}
}


source "virtualbox-iso" "rhel9" {
  boot_command= [
      "<esc><wait>",
      "vmlinuz initrd=initrd.img inst.ks=http://172.20.10.2:{{.HTTPPort}}/ks.cfg",
      "<enter>"
      ]

  disk_size               = "${var.disk_size}"
  guest_os_type           = "RedHat_64"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "./http"
  iso_checksum            = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls                = [
    "${var.iso_url}"
  ]
  output_directory        = "${var.output_directory}" 
  shutdown_command        = "echo '${var.ssh_password}'|sudo -S shutdown -P now" 
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_wait_timeout        = "10000s"
  guest_additions_mode    = "disable"
  vboxmanage             = [
    ["modifyvm", "{{ .Name }}", "--audio", "none"], 
    ["modifyvm", "{{ .Name }}", "--usb", "off"],
    ["modifyvm", "{{ .Name }}", "--vram", "${var.vram}"],
    ["modifyvm", "{{ .Name }}", "--vrde", "off"], 
    ["modifyvm", "{{.Name}}", "--nic1", "bridged"],
    ["modifyvm", "{{.Name}}", "--bridgeadapter1","Intel(R) Wi-Fi 6E AX211 160MHz"],
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], 
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.vm_name}"
  format                  = "ova"
}
build {
  sources = ["source.virtualbox-iso.rhel9"]
  
  provisioner "file" {
  source      = ".ssh/id_ed25519.pub"
  destination = "/tmp/id_ed25519.pub"
}

provisioner "shell" {
  inline = [
    "mkdir -p /home/packer/.ssh",
    "cat /tmp/id_ed25519.pub >> /home/packer/.ssh/authorized_keys",
    "chmod 600 /home/packer/.ssh/authorized_keys",
    "chown packer:packer /home/packer/.ssh /home/packer/.ssh/authorized_keys",
    "rm /tmp/id_ed25519.pub"
  ]
}
  
}


# Source for Windows 2019 VM
source "virtualbox-iso" "windows2019" {
  guest_os_type        = "windows9srv-64"
  vm_name              = "${var.vm_name}"
  iso_url              = "${var.windows19_iso_url}"
  iso_checksum         = "${var.windows19_iso_checksum}"
  iso_checksum_type="sha256"
  guest_additions_mode = "disable"
  output_directory="${var.output_directory}"
  headless             = "${var.headless}"
  boot_wait            = "${var.boot_wait}"
  disk_size            = "${var.disk_size}"
  communicator         = "winrm"
  winrm_username       = "${var.winrm_username}"
  winrm_password       = "${var.winrm_password}"
  winrm_use_ssl        = true
  winrm_insecure       = true
  winrm_timeout        = "4h"
  floppy_files         = ["scripts/bios/gui/autounattend-2019.xml"]
  shutdown_command     = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout     = "30m"
  vboxmanage           = [
    ["modifyvm", "{{.Name}}", "--memory", "${var.memory}"],
    ["modifyvm", "{{.Name}}", "--cpus", "${var.numvcpus}"]
  ]
}
 # Build for Windows 2019 VM
build {
  sources = ["source.virtualbox-iso.windows2019"]

  provisioner "powershell" {
    only         = ["virtualbox-iso"]
    scripts      = ["scripts/virtualbox-guest-additions.ps1"]
    pause_before = "1m"
  }

  provisioner "powershell" {
    scripts = ["scripts/setup.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }
}

# Build for Windows 2022 VM
build {
  sources = ["source.virtualbox-iso.windows2022"]

  provisioner "powershell" {
    only         = ["virtualbox-iso"]
    scripts      = ["scripts/virtualbox-guest-additions.ps1"]
    pause_before = "1m"
  }

  provisioner "powershell" {
    scripts = ["scripts/setup.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }
}




// # Source for Windows 2022 VM
source "virtualbox-iso" "windows2022" {
  guest_os_type        = "Windows2022_64"
  vm_name              = "${var.vm_name}"
  iso_url              = "${var.windows22-iso-url}"
  iso_checksum         = "${var.windows22-iso-checksum}"
    iso_checksum_type="sha256"
  guest_additions_mode = "disable"
  headless             = "${var.headless}"
  boot_wait            = "${var.boot_wait}"
  disk_size            = "${var.disk_size}"
  communicator         = "winrm"
  winrm_username       = "${var.winrm_username}"
  winrm_password       = "${var.winrm_password}"
  winrm_use_ssl        = true
  winrm_insecure       = true
  winrm_timeout        = "4h"
  floppy_files         = ["scripts/bios/gui/autounattend.xml"]
  shutdown_command     = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout     = "30m"
  vboxmanage           = [
    ["modifyvm", "{{.Name}}", "--memory", "${var.memory}"],
    ["modifyvm", "{{.Name}}", "--cpus", "${var.numvcpus}"]
  ]
}


# Build for Windows 2022 VM
build {
  sources = ["source.virtualbox-iso.windows2022"]

  provisioner "powershell" {
    only         = ["virtualbox-iso"]
    scripts      = ["scripts/virtualbox-guest-additions.ps1"]
    pause_before = "1m"
  }

  provisioner "powershell" {
    scripts = ["scripts/setup.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }
}