import 'package:flutter_test/flutter_test.dart';
import 'package:qsr_flutter_app/core/utils/utils.dart';
import 'package:qsr_flutter_app/features/printing/data/escpos_generator.dart';

void main() {
  group('DateTimeUtils Tests', () {
    test('should format date correctly', () {
      final date = DateTime(2024, 1, 15);
      expect(DateTimeUtils.formatDate(date), 'Jan 15, 2024');
    });

    test('should format currency correctly', () {
      expect(DateTimeUtils.formatCurrency(12.99), '\$12.99');
      expect(DateTimeUtils.formatCurrency(12.99, symbol: '€'), '€12.99');
    });

    test('should calculate start of day correctly', () {
      final dateTime = DateTime(2024, 1, 15, 14, 30, 45);
      final startOfDay = DateTimeUtils.startOfDay(dateTime);
      expect(startOfDay.hour, 0);
      expect(startOfDay.minute, 0);
      expect(startOfDay.second, 0);
    });
  });

  group('ValidationUtils Tests', () {
    test('should validate required fields', () {
      expect(ValidationUtils.validateRequired(null, 'Name'), 'Name is required');
      expect(ValidationUtils.validateRequired('', 'Name'), 'Name is required');
      expect(ValidationUtils.validateRequired('  ', 'Name'), 'Name is required');
      expect(ValidationUtils.validateRequired('Valid', 'Name'), null);
    });

    test('should validate price', () {
      expect(ValidationUtils.validatePrice(null), 'Price is required');
      expect(ValidationUtils.validatePrice(''), 'Price is required');
      expect(ValidationUtils.validatePrice('invalid'), 'Please enter a valid price');
      expect(ValidationUtils.validatePrice('-5'), 'Price must be greater than 0');
      expect(ValidationUtils.validatePrice('0'), 'Price must be greater than 0');
      expect(ValidationUtils.validatePrice('12.99'), null);
    });

    test('should validate quantity', () {
      expect(ValidationUtils.validateQuantity(null), 'Quantity is required');
      expect(ValidationUtils.validateQuantity(''), 'Quantity is required');
      expect(ValidationUtils.validateQuantity('invalid'), 'Please enter a valid quantity');
      expect(ValidationUtils.validateQuantity('-1'), 'Quantity must be greater than 0');
      expect(ValidationUtils.validateQuantity('0'), 'Quantity must be greater than 0');
      expect(ValidationUtils.validateQuantity('5'), null);
    });
  });

  group('StringUtils Tests', () {
    test('should capitalize text', () {
      expect(StringUtils.capitalize('hello'), 'Hello');
      expect(StringUtils.capitalize('HELLO'), 'Hello');
      expect(StringUtils.capitalize('hELLO'), 'Hello');
      expect(StringUtils.capitalize(''), '');
    });

    test('should truncate text', () {
      expect(StringUtils.truncate('Hello World', 10), 'Hello W...');
      expect(StringUtils.truncate('Hello', 10), 'Hello');
      expect(StringUtils.truncate('Hello World', 5, suffix: '...'), 'He...');
    });

    test('should check if string is null or empty', () {
      expect(StringUtils.isNullOrEmpty(null), true);
      expect(StringUtils.isNullOrEmpty(''), true);
      expect(StringUtils.isNullOrEmpty('   '), true);
      expect(StringUtils.isNullOrEmpty('Hello'), false);
    });
  });

  group('EscPosGenerator Tests', () {
    test('should generate KOT template', () {
      final template = KotTemplate(
        storeName: 'Test Restaurant',
        orderType: 'dineIn',
        tokenOrTable: 'T1',
        server: 'John',
        timestamp: DateTime(2024, 1, 15, 14, 30),
        deviceId: 'TEST-001',
        items: [
          const KotItem(quantity: 2, name: 'Pizza Margherita'),
          const KotItem(quantity: 1, name: 'Caesar Salad', notes: 'No croutons'),
        ],
      );

      final kotData = EscPosGenerator.generateKot(template);
      expect(kotData.isNotEmpty, true);
    });

    test('should generate summary report', () {
      final reportData = EscPosGenerator.generateSummaryReport(
        storeName: 'Test Restaurant',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 15),
        totalOrders: 50,
        grossSales: 1250.00,
        averageOrder: 25.00,
        itemsSold: 120,
        topItems: [
          {'name': 'Pizza', 'quantity': 25},
          {'name': 'Burger', 'quantity': 20},
        ],
        deviceId: 'TEST-001',
      );

      expect(reportData.isNotEmpty, true);
    });
  });
}