# Development Environment Automation Guide

## 1. Host Machine Setup

First, install these tools on your host machine:

```bash
# Windows (using Chocolatey):
choco install packer vagrant virtualbox git

# macOS (using Homebrew):
brew install packer vagrant virtualbox git

# Linux (Ubuntu/Debian):
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get install packer vagrant virtualbox git
```

## 2. Project Structure

Create this directory structure:
```plaintext
dev-environment/
├── packer/
│   ├── windows/
│   │   ├── answer_files/        # Windows unattended install files
│   │   ├── scripts/            # Setup scripts
│   │   └── windows.pkr.hcl     # Packer configuration
├── vagrant/
│   ├── Vagrantfile
│   └── scripts/
├── scripts/
│   ├── install_tools.ps1
│   ├── setup_postgresql.ps1
│   └── configure_vs.ps1
└── README.md
```

## 3. Create Base Image with Packer

### 3.1. Packer Configuration (`packer/windows/windows.pkr.hcl`):
```hcl
source "virtualbox-iso" "windows_dev" {
  # Windows ISO configuration
  iso_url = "https://software-download.microsoft.com/download/sg/444969d5-f34g-4e03-ac9d-1f9786c69161/19044.1288.211006-0501.21h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
  iso_checksum = "sha256:YOUR_ISO_CHECKSUM"
  
  # VM configuration
  guest_os_type = "Windows_64"
  cpus = 4
  memory = 16384
  disk_size = 262144
  
  # Windows configuration
  winrm_username = "vagrant"
  winrm_password = "vagrant"
  
  # Shutdown command
  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
}

build {
  sources = ["source.virtualbox-iso.windows_dev"]
  
  provisioner "powershell" {
    scripts = [
      "./scripts/install_tools.ps1",
      "./scripts/setup_postgresql.ps1",
      "./scripts/configure_vs.ps1"
    ]
  }
}
```

### 3.2. Installation Script (`scripts/install_tools.ps1`):
```powershell
# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install development tools
$tools = @(
    "visualstudio2022professional",
    "dotnet-sdk",
    "git",
    "postgresql",
    "pgadmin4",
    "sqlite",
    "postman",
    "beyondcompare",
    "seq"
)

foreach ($tool in $tools) {
    choco install $tool -y
}
```

## 4. Vagrant Configuration

### 4.1. Create Vagrantfile:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "windows_dev_box"  # Your Packer-created box
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "16384"
    vb.cpus = 4
    vb.gui = true
    
    # Video settings
    vb.customize ["modifyvm", :id, "--vram", "128"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
  end
  
  # Network configuration
  config.vm.network "private_network", type: "dhcp"
  
  # Sync project folder
  config.vm.synced_folder "../", "/workspace"
  
  # Project-specific provisioning
  config.vm.provision "shell", path: "scripts/setup_project.ps1"
end
```

## 5. Implementation Steps

1. **Create Base Image**:
```bash
cd packer/windows
packer build windows.pkr.hcl
```

2. **Add Box to Vagrant**:
```bash
vagrant box add windows_dev_box packer_output/windows_dev.box
```

3. **Start Development Environment**:
```bash
cd ../../vagrant
vagrant up
```

## 6. Usage Instructions

### 6.1. For Environment Maintainers:

1. Update Base Image:
```bash
# In packer directory
packer build windows.pkr.hcl
vagrant box update
```

2. Distribute New Image:
```bash
# Package the box
vagrant package --output windows_dev_latest.box
# Upload to your internal server
```

### 6.2. For Developers:

1. First-time Setup:
```bash
# Install required tools
choco install vagrant virtualbox git

# Clone environment repository
git clone <repo-url> dev-environment
cd dev-environment

# Start VM
vagrant up
```

2. Daily Usage:
```bash
# Start development environment
vagrant up

# Stop environment
vagrant halt

# Rebuild environment
vagrant destroy -f
vagrant up
```

## 7. Maintenance and Updates

### 7.1. Update Base Image:
1. Modify Packer scripts
2. Build new image
3. Test in Vagrant
4. Distribute to team

### 7.2. Update Project Configuration:
1. Modify Vagrant provisioning scripts
2. Test locally
3. Commit and push changes
4. Team members run `vagrant provision`

## 8. Troubleshooting

### 8.1. Common Issues:
1. **VirtualBox Issues**:
   ```bash
   # Reset VirtualBox
   vagrant halt
   VBoxManage list vms
   VBoxManage unregistervm <vm-id> --delete
   vagrant up
   ```

2. **Network Issues**:
   ```bash
   # Reset network
   vagrant reload
   ```

3. **Provisioning Failures**:
   ```bash
   # Retry provisioning
   vagrant provision
   ```

### 8.2. Logs:
- Packer logs: `PACKER_LOG=1 packer build windows.pkr.hcl`
- Vagrant logs: `VAGRANT_LOG=debug vagrant up`

## 9. Best Practices

1. Version Control:
   - Keep Packer and Vagrant configurations in version control
   - Document changes in commit messages
   - Tag stable versions

2. Testing:
   - Test new images before distribution
   - Maintain test scripts
   - Validate with different host OS versions

3. Documentation:
   - Keep README updated
   - Document known issues
   - Maintain troubleshooting guide 