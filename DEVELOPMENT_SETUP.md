# Storeit Development Environment Setup

## System Requirements

### Minimum Requirements
- Windows 10/11, macOS 12+, or Linux (Ubuntu 22.04+)
- 8GB RAM
- 20GB free disk space
- Intel Core i5 or equivalent
- Internet connection for initial setup and updates

### Recommended Requirements
- 16GB RAM
- 50GB free disk space
- Intel Core i7 or equivalent
- SSD storage
- Dedicated graphics card

## Development Tools

### Core Tools
1. **Visual Studio 2022**
   - .NET MAUI workload
   - Mobile development with .NET
   - ASP.NET and web development
   - .NET desktop development

2. **.NET SDK 8.0**
   - Required for .NET MAUI development
   - Cross-platform development support

3. **SQLite**
   - Local database for development
   - SQLite tools for database management

4. **PostgreSQL 16**
   - For central monitoring server development
   - pgAdmin for database management

5. **Node.js 18+**
   - For central monitoring server development
   - npm or yarn package manager

### Additional Tools
- Git for version control
- Docker Desktop for containerization
- Postman for API testing
- Visual Studio Code for additional editing
- Android Studio for mobile development
- Xcode for iOS development (macOS only)

## Environment Setup

### Windows Setup
1. Install Visual Studio 2022 with required workloads
2. Install .NET SDK 8.0
3. Install SQLite
4. Install PostgreSQL 16
5. Install Node.js 18+
6. Install Git
7. Install Docker Desktop
8. Install Android Studio

### macOS Setup
1. Install Visual Studio for Mac
2. Install .NET SDK 8.0
3. Install SQLite
4. Install PostgreSQL 16
5. Install Node.js 18+
6. Install Git
7. Install Docker Desktop
8. Install Xcode
9. Install Android Studio

### Linux Setup (Ubuntu)
```bash
# Install .NET SDK
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y dotnet-sdk-8.0

# Install SQLite
sudo apt-get install -y sqlite3

# Install PostgreSQL
sudo apt-get install -y postgresql-16

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Git
sudo apt-get install -y git

# Install Docker
sudo apt-get install -y docker.io
```

## Repository Structure

```
storeit/
├── src/
│   ├── desktop/           # .NET MAUI desktop application
│   ├── mobile/            # React Native/Flutter mobile app
│   ├── central-server/    # Node.js monitoring server
│   └── shared/            # Shared libraries and models
├── tests/
│   ├── desktop/
│   ├── mobile/
│   └── central-server/
├── docs/
│   ├── api/
│   ├── architecture/
│   └── user-guides/
└── scripts/
    ├── setup/
    ├── backup/
    └── deployment/
```

## Database Setup

### Local Development Database
```sql
-- SQLite setup script
CREATE TABLE IF NOT EXISTS Users (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Username TEXT NOT NULL UNIQUE,
    PasswordHash TEXT NOT NULL,
    Role TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Inventory (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    Description TEXT,
    Quantity INTEGER NOT NULL,
    Location TEXT,
    LastUpdated DATETIME
);

-- Additional tables as needed
```

### Central Server Database
```sql
-- PostgreSQL setup script
CREATE TABLE IF NOT EXISTS Installations (
    Id SERIAL PRIMARY KEY,
    InstallationId UUID NOT NULL UNIQUE,
    Version TEXT NOT NULL,
    LastHealthCheck TIMESTAMP,
    Status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS ModuleUpdates (
    Id SERIAL PRIMARY KEY,
    ModuleName TEXT NOT NULL,
    Version TEXT NOT NULL,
    ReleaseDate TIMESTAMP NOT NULL,
    DownloadUrl TEXT NOT NULL
);
```

## Configuration

### Development Settings
```json
{
  "Database": {
    "ConnectionString": "Data Source=storeit.db",
    "BackupLocation": "./backups"
  },
  "LocalApi": {
    "Port": 5000,
    "EnableSwagger": true
  },
  "Monitoring": {
    "CentralServerUrl": "https://monitoring.storeit.com",
    "HealthCheckInterval": 300
  }
}
```

## Development Workflows

### Desktop Application
1. Clone repository
2. Open solution in Visual Studio
3. Restore NuGet packages
4. Build solution
5. Run application

### Mobile Application
1. Clone repository
2. Install dependencies
3. Configure development environment
4. Start development server
5. Run on emulator/device

### Central Server
1. Clone repository
2. Install dependencies
3. Configure environment variables
4. Start development server

## Testing Environment

### Desktop Testing
```bash
dotnet test src/desktop/Storeit.Desktop.Tests
```

### Mobile Testing
```bash
npm test src/mobile
```

### API Testing
```bash
npm test src/central-server
```

## Documentation

### Code Documentation
- Use XML documentation comments
- Follow C# documentation standards
- Document public APIs
- Include usage examples

### Development Wiki
- Architecture decisions
- Development guidelines
- Troubleshooting guides
- API documentation

## Monitoring & Debugging

### Logging Setup
```csharp
// Configure logging in Program.cs
builder.Logging.AddConsole();
builder.Logging.AddDebug();
builder.Logging.AddFile("logs/storeit-{Date}.log");
```

### Performance Monitoring
- Use Visual Studio Diagnostic Tools
- Monitor memory usage
- Track database performance
- Analyze network traffic

## Troubleshooting

### Common Issues
1. Database connection problems
2. Mobile app connectivity issues
3. Update distribution failures
4. Backup/restore problems

### Support
- Check development wiki
- Review error logs
- Contact development team
- Submit issue tickets 