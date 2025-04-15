# Development Environment Setup Guide - Inventory Management System

## Table of Contents
1. [System Requirements](#1-system-requirements)
2. [Development Tools](#2-development-tools)
3. [Environment Setup](#3-environment-setup)
4. [Repository Structure](#4-repository-structure)
5. [Database Setup](#5-database-setup)
6. [Configuration](#6-configuration)
7. [Development Workflows](#7-development-workflows)
8. [Testing Environment](#8-testing-environment)
9. [Documentation](#9-documentation)
10. [Monitoring & Debugging](#10-monitoring--debugging)

## 1. System Requirements

### 1.1 Hardware Requirements
- **Minimum Requirements:**
  - Windows 10/11 Pro or Enterprise
  - 16GB RAM
  - 256GB SSD
  - Intel i7/AMD Ryzen 7 or better
  - 1920x1080 display resolution

- **Recommended:**
  - 32GB RAM
  - 512GB SSD
  - Multiple monitors
  - Dedicated graphics card

### 1.2 Software Requirements
- Windows 10/11 Pro or Enterprise
- Visual Studio 2022 Enterprise/Professional
- .NET 8 SDK
- Git
- PostgreSQL 16
- SQLite tools

## 2. Development Tools

### 2.1 Core Development Tools
- **Visual Studio 2022**
  - Required Workloads:
    - .NET Desktop Development
    - ASP.NET and Web Development
    - .NET Multi-platform App UI Development
  - Recommended Extensions:
    - XAML Styler
    - CodeMaid
    - Git Extensions

- **Database Tools**
  - PostgreSQL 16
  - pgAdmin 4
  - DB Browser for SQLite
  - DBeaver (optional)

- **Version Control**
  - Git
  - GitHub Desktop/GitKraken
  - Beyond Compare

### 2.2 Additional Tools
- **API Development & Testing**
  - Postman
  - Swagger UI
  - Fiddler

- **Monitoring & Debugging**
  - Application Insights
  - Seq
  - dotTrace
  - dotMemory

## 3. Environment Setup

### 3.1 Initial Setup
1. Enable required Windows features:
   ```powershell
   # Run as Administrator
   Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
   Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
   ```

2. Install Chocolatey package manager:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
   iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
   ```

3. Install core tools using Chocolatey:
   ```powershell
   choco install -y visualstudio2022enterprise
   choco install -y dotnet-sdk
   choco install -y git
   choco install -y postgresql
   choco install -y pgadmin4
   choco install -y sqlite
   choco install -y postman
   choco install -y beyondcompare
   choco install -y seq
   ```

### 3.2 Visual Studio Configuration
1. Install required workloads:
   - Open Visual Studio Installer
   - Modify Visual Studio 2022
   - Select required workloads
   - Install

2. Install recommended extensions:
   - Open Visual Studio
   - Go to Extensions > Manage Extensions
   - Install recommended extensions

### 3.3 Database Setup
1. PostgreSQL Configuration:
   ```sql
   -- Create development database
   CREATE DATABASE storeit_dev;
   
   -- Create test database
   CREATE DATABASE storeit_test;
   
   -- Create development user
   CREATE USER dev WITH PASSWORD 'dev_password';
   GRANT ALL PRIVILEGES ON DATABASE storeit_dev TO dev;
   GRANT ALL PRIVILEGES ON DATABASE storeit_test TO dev;
   ```

2. SQLite Setup:
   - No additional setup required
   - Database will be created automatically on first run

## 4. Repository Structure

```plaintext
storeit/
├── src/
│   ├── Storeit.Desktop/        # WPF Desktop Application
│   ├── Storeit.Core/          # Core Business Logic
│   ├── Storeit.Data/          # Data Access Layer
│   ├── Storeit.Api/           # Web API
│   ├── Storeit.Common/        # Shared Components
│   └── Storeit.Tests/         # Test Projects
├── docs/
│   ├── architecture/
│   ├── api/
│   └── user-guides/
├── tools/
│   ├── scripts/
│   └── utilities/
└── tests/
    ├── unit/
    ├── integration/
    └── e2e/
```

## 5. Database Setup

### 5.1 Connection Strings
Create `appsettings.Development.json`:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=storeit_dev;Username=dev;Password=dev_password",
    "TestConnection": "Host=localhost;Database=storeit_test;Username=test;Password=test_password",
    "LocalDb": "Data Source=storeit_local.db"
  }
}
```

### 5.2 Database Migrations
1. Create initial migration:
   ```powershell
   dotnet ef migrations add InitialCreate --project Storeit.Data
   ```

2. Apply migrations:
   ```powershell
   dotnet ef database update --project Storeit.Data
   ```

## 6. Configuration

### 6.1 Development Settings
Create `appsettings.Development.json`:
```json
{
  "Environment": "Development",
  "Logging": {
    "LogLevel": {
      "Default": "Debug",
      "Microsoft": "Information"
    }
  },
  "Features": {
    "EnableTelemetry": true,
    "EnableDebugViews": true,
    "UseLocalDatabase": true
  }
}
```

### 6.2 User Secrets
1. Initialize user secrets:
   ```powershell
   dotnet user-secrets init --project Storeit.Desktop
   ```

2. Add development secrets:
   ```powershell
   dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Host=localhost;Database=storeit_dev;Username=dev;Password=dev_password"
   ```

## 7. Development Workflows

### 7.1 Git Workflow
1. Branch naming:
   - `feature/*` - New features
   - `bugfix/*` - Bug fixes
   - `release/*` - Release preparation
   - `hotfix/*` - Emergency fixes

2. Commit message format:
   ```
   <type>(<scope>): <subject>
   
   <body>
   
   <footer>
   ```

### 7.2 Build Process
1. Local build:
   ```powershell
   dotnet restore
   dotnet build
   dotnet test
   ```

2. Run application:
   ```powershell
   dotnet run --project Storeit.Desktop
   ```

## 8. Testing Environment

### 8.1 Test Categories
1. Unit Tests:
   ```powershell
   dotnet test Storeit.Tests.Unit
   ```

2. Integration Tests:
   ```powershell
   dotnet test Storeit.Tests.Integration
   ```

3. E2E Tests:
   ```powershell
   dotnet test Storeit.Tests.E2E
   ```

### 8.2 Test Data
1. Create test database:
   ```sql
   CREATE DATABASE storeit_test;
   ```

2. Apply test migrations:
   ```powershell
   dotnet ef database update --project Storeit.Data --context TestDbContext
   ```

## 9. Documentation

### 9.1 Code Documentation
1. XML Documentation:
   - Enable in project settings
   - Document public APIs
   - Document complex logic

2. README Files:
   - Project overview
   - Setup instructions
   - Contributing guidelines

### 9.2 Development Wiki
1. Technical Documentation:
   - Architecture overview
   - Database schema
   - API documentation
   - Deployment guide

2. Process Documentation:
   - Coding standards
   - Git workflow
   - Release process
   - Testing guidelines

## 10. Monitoring & Debugging

### 10.1 Logging Setup
1. Configure Seq:
   ```powershell
   choco install seq
   ```

2. Configure logging in `appsettings.Development.json`:
   ```json
   {
     "Serilog": {
       "WriteTo": [
         {
           "Name": "Seq",
           "Args": {
             "serverUrl": "http://localhost:5341"
           }
         }
       ]
     }
   }
   ```

### 10.2 Performance Monitoring
1. Configure Application Insights:
   ```powershell
   dotnet add package Microsoft.ApplicationInsights
   ```

2. Add instrumentation key to user secrets:
   ```powershell
   dotnet user-secrets set "ApplicationInsights:InstrumentationKey" "your-key"
   ```

## Troubleshooting

### Common Issues
1. **Database Connection Issues**
   - Verify PostgreSQL service is running
   - Check connection strings
   - Verify user permissions

2. **Build Failures**
   - Clean solution
   - Restore packages
   - Check .NET SDK version

3. **Test Failures**
   - Verify test database setup
   - Check test data
   - Review test configuration

### Support
- Create issue in GitHub repository
- Contact development team
- Check documentation 