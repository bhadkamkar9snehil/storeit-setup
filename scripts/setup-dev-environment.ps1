# Setup Development Environment Script
# This script automates the setup of the Storeit development environment
# Requires PowerShell 5.1 or higher and must be run as Administrator

#Requires -Version 5.1
#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue" # Speeds up downloads

# Configuration
$config = @{
    Tools = @(
        "visualstudio2022enterprise"
        "dotnet-sdk"
        "git"
        "postgresql16"
        "pgadmin4"
        "sqlite"
        "postman"
        "beyondcompare"
        "seq"
        "vscode"
        "nodejs"
        "python3"
        "7zip"
        "googlechrome"
        "firefox"
        "docker-desktop"
        "wsl2"
    )
    VSWorkloads = @(
        "Microsoft.VisualStudio.Workload.NetDesktop"
        "Microsoft.VisualStudio.Workload.NetWeb"
        "Microsoft.VisualStudio.Workload.NetCrossPlat"
        "Microsoft.VisualStudio.Workload.Azure"
        "Microsoft.VisualStudio.Workload.Data"
    )
}

function Write-Status {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command -Name $Command -ErrorAction SilentlyContinue)
}

# Check if running on supported OS
$os = Get-WmiObject -Class Win32_OperatingSystem
if (-not ($os.Caption -match "Windows (10|11|Server)")) {
    throw "This script requires Windows 10, Windows 11, or Windows Server"
}

Write-Status "Starting development environment setup..."

# Install Chocolatey if not already installed
if (-not (Test-CommandExists "choco")) {
    Write-Status "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    refreshenv
}

# Enable required Windows features
Write-Status "Enabling required Windows features..."
$features = @(
    "Microsoft-Hyper-V"
    "Microsoft-Windows-Subsystem-Linux"
    "Containers"
    "VirtualMachinePlatform"
)

foreach ($feature in $features) {
    if ((Get-WindowsOptionalFeature -Online -FeatureName $feature).State -ne "Enabled") {
        Enable-WindowsOptionalFeature -Online -FeatureName $feature -All -NoRestart
    }
}

# Install development tools
Write-Status "Installing development tools..."
foreach ($tool in $config.Tools) {
    Write-Status "Installing $tool..."
    choco install $tool -y --no-progress
}

# Configure Visual Studio
if (Test-CommandExists "vs_installer") {
    Write-Status "Configuring Visual Studio..."
    $vsInstaller = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vs_installer.exe"
    $workloads = $config.VSWorkloads -join " "
    Start-Process -FilePath $vsInstaller -ArgumentList "modify --installPath ""${env:ProgramFiles}\Microsoft Visual Studio\2022\Enterprise"" --add $workloads --quiet --norestart" -Wait
}

# Configure PostgreSQL
Write-Status "Configuring PostgreSQL..."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
$pgPass = "dev_password"
$pgScript = @"
CREATE DATABASE storeit_dev;
CREATE DATABASE storeit_test;
CREATE USER dev WITH PASSWORD '$pgPass';
GRANT ALL PRIVILEGES ON DATABASE storeit_dev TO dev;
GRANT ALL PRIVILEGES ON DATABASE storeit_test TO dev;
"@
$pgScript | psql -U postgres

# Create development directory structure
Write-Status "Creating development directory structure..."
$devPath = "$env:USERPROFILE\source\repos\storeit"
New-Item -ItemType Directory -Force -Path @(
    "$devPath\src"
    "$devPath\docs"
    "$devPath\tools"
    "$devPath\tests"
)

# Configure WSL2
Write-Status "Configuring WSL2..."
wsl --set-default-version 2
wsl --install -d Ubuntu

# Configure Docker
Write-Status "Configuring Docker..."
Start-Service -Name "Docker Desktop Service"
docker --version

Write-Status "Setup completed successfully!"
Write-Status "Please restart your computer to complete the installation."

# Create completion marker
$completionMarker = "$env:USERPROFILE\.storeit-setup-complete"
New-Item -ItemType File -Force -Path $completionMarker

Write-Host "`nSetup completed! A system restart is required to finish the installation." -ForegroundColor Green 