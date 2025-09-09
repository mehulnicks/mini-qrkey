# QSR Flutter App

A comprehensive Quick Service Restaurant (QSR) management system built with Flutter.

## Features

- **Multi-language Support**: Hindi and English localization
- **Order Management**: Complete order lifecycle management
- **KOT (Kitchen Order Ticket) Printing**: Thermal printer support
- **Menu Management**: Category-based menu with pricing
- **Reporting System**: Sales reports with date filtering
- **Settings Management**: Currency, language, and printer settings
- **Cross-platform**: Web, Android, iOS, and macOS support

## Technical Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Riverpod (flutter_riverpod)
- **Database**: SQLite (sqflite)
- **UI**: Material Design with responsive layout

## Getting Started

### Prerequisites

- Flutter SDK 3.x or higher
- Dart SDK
- Chrome browser (for web development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd mini-qrkey
```

2. Navigate to the Flutter app directory:
```bash
cd qsr_flutter_app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
flutter run -d chrome --target=lib/clean_qsr_main.dart
```

## Project Structure

```
qsr_flutter_app/
├── lib/
│   ├── clean_qsr_main.dart      # Main application file (3,366 lines)
│   ├── simple_qsr_main.dart     # Simplified version (has compilation issues)
│   ├── kot_screen.dart          # Kitchen Order Ticket screen
│   └── other_files...
├── assets/
│   ├── fonts/                   # Custom fonts
│   ├── templates/               # KOT templates
│   └── translations/            # Language files
├── android/                     # Android-specific files
├── ios/                         # iOS-specific files
├── macos/                       # macOS-specific files
├── web/                         # Web-specific files
└── pubspec.yaml                 # Project dependencies
```

## Main Components

### Order Management
- Place new orders
- View order history
- Track order status
- Manage order items

### KOT Printing
- Generate kitchen order tickets
- Thermal printer integration
- Customizable templates

### Menu Management
- Category-based organization
- Item pricing and descriptions
- Inventory tracking

### Reporting
- Sales analytics
- Date range filtering
- Export capabilities

### Settings
- Multi-language support (Hindi/English)
- Currency configuration
- Printer settings
- Theme customization

## Dependencies

Key dependencies include:
- `flutter_riverpod`: State management
- `sqflite`: SQLite database
- `shared_preferences`: Local storage
- `bluetooth_print`: Printer integration

## Running the App

The main entry point is `clean_qsr_main.dart` which contains the complete implementation:

```bash
flutter run -d chrome --target=lib/clean_qsr_main.dart
```

For development on other platforms:
- Android: `flutter run -d android`
- iOS: `flutter run -d ios`
- macOS: `flutter run -d macos`

## Known Issues

- The `simple_qsr_main.dart` file has compilation errors and should not be used
- Layout constraints issue in reports section (fixed in clean version)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the repository.
