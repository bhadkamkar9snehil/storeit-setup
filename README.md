# Storeit - Local-First Inventory Management System

Storeit is a comprehensive inventory management system designed for mid-sized retail chains, manufacturing SMEs, and distribution companies. The system follows a local-first architecture with optional cloud synchronization capabilities.

## Key Features

- **Local-First Architecture**
  - Full offline operation
  - Local data storage
  - Automatic backup system
  - Optional cloud sync

- **Cross-Platform Support**
  - Windows desktop application
  - macOS desktop application
  - Linux desktop application
  - Mobile applications (iOS/Android)

- **Core Functionality**
  - Inventory tracking and management
  - Multi-location support
  - Barcode/QR scanning
  - Reporting and analytics
  - User management and access control
  - Backup and restore capabilities

## System Components

1. **Desktop Application (.NET MAUI)**
   - Primary user interface
   - Local data storage
   - Offline operation
   - Local API server

2. **Mobile Application**
   - Barcode/QR scanning
   - Inventory checks
   - Basic analytics
   - Work order management

3. **Central Monitoring Server**
   - System health monitoring
   - Module update distribution
   - Troubleshooting support

## Getting Started

### Prerequisites

- Windows 10/11, macOS 12+, or Linux (Ubuntu 22.04+)
- .NET SDK 8.0
- SQLite
- Node.js 18+ (for development)

### Installation

1. Download the latest release for your platform
2. Run the installer
3. Follow the setup wizard
4. Configure local database
5. Set up backup locations

### Development Setup

See [DEVELOPMENT_SETUP.md](DEVELOPMENT_SETUP.md) for detailed development environment setup instructions.

## Documentation

- [System Design](SYSTEM_DESIGN.md)
- [Development Setup](DEVELOPMENT_SETUP.md)
- [API Documentation](docs/api/README.md)
- [User Guides](docs/user-guides/README.md)

## Architecture

The system follows a local-first architecture with the following components:

```
[Mobile App] ←→ [Desktop App (Local Server)] ←→ [Central Monitoring Server]
                        ↑
                    [SQLite]
```

- All business data is stored locally in SQLite
- Desktop app acts as local server for mobile app
- Central server only handles monitoring and updates
- Optional cloud sync for data backup

## Security

- Local user authentication
- Role-based access control
- Data encryption at rest
- Secure local API communication
- Encrypted backups

## Backup and Restore

- Automatic backup scheduling
- Multiple backup locations
- Full system restore capability
- Backup validation
- Incremental backups

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, please:
1. Check the documentation
2. Review the troubleshooting guide
3. Submit an issue
4. Contact the development team 