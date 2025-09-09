# QSR Flutter App

A comprehensive Flutter mobile app for Quick Service Restaurants (QSR) to manage orders, print Kitchen Order Tickets (KOT), and generate detailed reports. Built with offline-first architecture, Material 3 design, and Bluetooth thermal printer support.

## Features

### 🍽️ **Order Management**
- Create quick orders (dine-in/takeaway)
- Select menu items with quantity steppers
- Add notes to individual items
- Real-time order total calculation
- Offline-first order persistence

### 📋 **Menu Management**
- Manage up to 20 menu items
- Add/edit/delete menu items
- Toggle item availability
- Price management
- Real-time menu updates

### 🧾 **KOT Printing (Feature-Flag Controlled)**
- Enable/disable KOT feature per customer
- Bluetooth thermal printer support (58/80mm)
- ESC/POS command generation
- Device pairing and selection
- Print KOT on order completion
- Reprint functionality

### 📊 **Comprehensive Reporting**
- **Date Filters**: Today, Yesterday, This Week, Last 7 days, This Month, Last 30 days, This Year, Custom Range
- **Metrics**: Total Orders, Gross Sales, Items Sold, Average Order Value
- **Analytics**: Top 5 selling items, daily trends
- **Export**: CSV export for offline analysis
- **Print**: Summary reports on thermal printer

### ⚙️ **Settings & Configuration**
- KOT enable/disable toggle
- Bluetooth printer selection
- Store information management
- Tax rate configuration
- Currency symbol customization
- Settings export/import
- Reset to defaults

## Technical Architecture

### 🏗️ **Architecture Pattern**
- **Clean Architecture** with feature-based modules
- **Data/Domain/Presentation** layers
- **Reactive State Management** with Riverpod
- **Offline-first** data persistence

### 🗄️ **Database & Storage**
- **SQLite** via Drift ORM
- **Reactive queries** with real-time updates
- **Migration support** for schema evolution
- **Foreign key constraints** for data integrity
- **Optimized indexes** for fast queries

### 🎨 **UI/UX Design**
- **Material 3** design system
- **Dynamic Color** support
- **High contrast** accessibility
- **Large touch targets** for tablet use
- **Responsive layout** for various screen sizes

### 🔌 **Connectivity & Offline Support**
- **Offline-first** architecture
- **Connectivity monitoring**
- **Graceful degradation** when offline
- **Data sync flags** for future backend integration

## Project Structure

```
qsr_flutter_app/
├── lib/
│   ├── core/
│   │   ├── database/           # Drift database configuration
│   │   ├── theme/              # Material 3 theme
│   │   └── utils/              # Utilities and helpers
│   ├── features/
│   │   ├── menu/               # Menu management
│   │   ├── orders/             # Order processing
│   │   ├── printing/           # KOT printing system
│   │   ├── reports/            # Analytics and reporting
│   │   └── settings/           # App configuration
│   └── shared/
│       ├── models/             # Data models
│       ├── providers/          # Riverpod providers
│       └── widgets/            # Reusable UI components
├── assets/
│   ├── fonts/                  # Custom fonts
│   ├── templates/              # KOT templates
│   └── translations/           # i18n support
└── test/
    ├── unit/                   # Unit tests
    └── widget/                 # Widget tests
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.13.0 or higher)
- Dart SDK (3.1.0 or higher)
- Android Studio or VS Code
- Android device/emulator for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd qsr_flutter_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for Drift database)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Android Configuration

The app includes necessary Android permissions for:
- Bluetooth connectivity (Android 12+ compatible)
- File storage access
- Network connectivity monitoring

## Usage Guide

### First Time Setup
1. **Configure Store Information**: Go to Settings and update store name, server name
2. **Set Tax Rate**: Configure tax percentage in Settings
3. **Enable KOT**: Toggle KOT printing if needed
4. **Pair Printer**: Connect to Bluetooth thermal printer (if KOT enabled)

### Daily Operations
1. **Create Orders**: Select items, set quantities, add notes
2. **Save Orders**: Store orders locally with immediate persistence
3. **Print KOT**: Generate kitchen tickets (if enabled)
4. **View Reports**: Analyze sales data with various filters
5. **Export Data**: Generate CSV reports for external analysis

## Testing

### Unit Tests
```bash
flutter test test/unit/
```

### Widget Tests
```bash
flutter test test/widget/
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ using Flutter for the QSR industry**