import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:thermal_printer/thermal_printer.dart';

import 'escpos_generator.dart';
import '../../../core/database/database.dart';

enum PrinterConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}

class BluetoothDevice {
  final String name;
  final String address;
  final bool isConnected;

  const BluetoothDevice({
    required this.name,
    required this.address,
    this.isConnected = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothDevice &&
          runtimeType == other.runtimeType &&
          address == other.address;

  @override
  int get hashCode => address.hashCode;

  @override
  String toString() => '$name ($address)';
}

class PrintingService {
  // final BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;
  
  PrinterConnectionStatus _status = PrinterConnectionStatus.disconnected;
  BluetoothDevice? _connectedDevice;
  String? _lastError;

  final StreamController<PrinterConnectionStatus> _statusController = 
      StreamController<PrinterConnectionStatus>.broadcast();
  final StreamController<List<BluetoothDevice>> _devicesController = 
      StreamController<List<BluetoothDevice>>.broadcast();

  Stream<PrinterConnectionStatus> get statusStream => _statusController.stream;
  Stream<List<BluetoothDevice>> get devicesStream => _devicesController.stream;

  PrinterConnectionStatus get status => _status;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  String? get lastError => _lastError;

  void _updateStatus(PrinterConnectionStatus newStatus, [String? error]) {
    _status = newStatus;
    _lastError = error;
    _statusController.add(newStatus);
  }

  Future<bool> requestPermissions() async {
    try {
      // Simplified permission handling - will need proper implementation later
      return true;
    } catch (e) {
      _updateStatus(PrinterConnectionStatus.error, 'Permission error: $e');
      return false;
    }
  }

  Future<bool> isBluetoothEnabled() async {
    try {
      // Simplified bluetooth check - will need proper implementation later
      return true;
    } catch (e) {
      _updateStatus(PrinterConnectionStatus.error, 'Bluetooth check error: $e');
      return false;
    }
  }

  Future<List<BluetoothDevice>> scanForPrinters() async {
    try {
      if (!await requestPermissions()) {
        throw Exception('Bluetooth permissions not granted');
      }

      if (!await isBluetoothEnabled()) {
        throw Exception('Bluetooth is not enabled');
      }

      // Mock devices for now
      final bluetoothDevices = <BluetoothDevice>[
        const BluetoothDevice(name: 'Mock Thermal Printer', address: '00:11:22:33:44:55'),
      ];

      _devicesController.add(bluetoothDevices);
      return bluetoothDevices;
    } catch (e) {
      _updateStatus(PrinterConnectionStatus.error, 'Scan error: $e');
      return [];
    }
  }

  Future<bool> connectToPrinter(BluetoothDevice device) async {
    try {
      _updateStatus(PrinterConnectionStatus.connecting);

      if (!await requestPermissions()) {
        throw Exception('Bluetooth permissions not granted');
      }

      if (!await isBluetoothEnabled()) {
        throw Exception('Bluetooth is not enabled');
      }

      // Disconnect if already connected
      if (_connectedDevice != null) {
        await disconnect();
      }

      // Mock connection for now
      await Future.delayed(const Duration(seconds: 1));
      
      _connectedDevice = device;
      _updateStatus(PrinterConnectionStatus.connected);
      return true;
    } catch (e) {
      _updateStatus(PrinterConnectionStatus.error, 'Connection error: $e');
      return false;
    }
  }

  Future<void> disconnect() async {
    try {
      // Mock disconnect for now
      _connectedDevice = null;
      _updateStatus(PrinterConnectionStatus.disconnected);
    } catch (e) {
      _updateStatus(PrinterConnectionStatus.error, 'Disconnect error: $e');
    }
  }

  Future<bool> printKot({
    required String storeName,
    required String orderType,
    required String tokenOrTable,
    required String server,
    required DateTime timestamp,
    required String deviceId,
    required List<KotItem> items,
  }) async {
    try {
      if (_status != PrinterConnectionStatus.connected) {
        throw Exception('Printer not connected');
      }

      final template = KotTemplate(
        storeName: storeName,
        orderType: orderType,
        tokenOrTable: tokenOrTable,
        server: server,
        timestamp: timestamp,
        deviceId: deviceId,
        items: items,
      );

      final kotData = EscPosGenerator.generateKot(template);
      // await _bluetooth.writeBytes(kotData); // Mock print for now
      print('KOT printed to console: ${kotData.length} bytes');
      
      return true;
    } catch (e) {
      _updateStatus(PrinterConnectionStatus.error, 'Print error: $e');
      return false;
    }
  }

  Future<bool> printOrderFromDatabase({
    required AppDatabase database,
    required int orderId,
    required String storeName,
    required String server,
    required String deviceId,
  }) async {
    try {
      // Get order details
      final orders = await database.getAllOrders();
      final order = orders.firstWhere((o) => o.id == orderId);
      
      // Get order items with menu item details
      final orderItems = await database.getOrderItems(orderId);
      final menuItems = await database.getAllMenuItems();
      
      final kotItems = orderItems.map((orderItem) {
        final menuItem = menuItems.firstWhere((m) => m.id == orderItem.menuItemId);
        return KotItem(
          quantity: orderItem.quantity,
          name: menuItem.name,
          notes: orderItem.notes,
        );
      }).toList();

      return await printKot(
        storeName: storeName,
        orderType: order.orderType.name,
        tokenOrTable: order.tokenOrTable,
        server: server,
        timestamp: DateTime.fromMillisecondsSinceEpoch(order.createdAtEpoch),
        deviceId: deviceId,
        items: kotItems,
      );
    } catch (e) {
      _updateStatus(PrinterConnectionStatus.error, 'Database print error: $e');
      return false;
    }
  }

  // Print detailed bill receipt
  Future<bool> printBill({
    required String storeName,
    required String address,
    required String phone,
    String? email,
    String? gstNumber,
    required String billNumber,
    required DateTime timestamp,
    required String orderSource,
    String? customerName,
    String? customerPhone,
    String? orderType,
    String? tokenNumber,
    String? tableNumber,
    required List<BillItem> items,
    required double subtotal,
    double discount = 0.0,
    double fixedDiscount = 0.0,
    double containerCharge = 0.0,
    double deliveryCharge = 0.0,
    double packagingCharge = 0.0,
    double serviceCharge = 0.0,
    double cgst = 0.0,
    double sgst = 0.0,
    required double grandTotal,
    required String paymentMethod,
    String? transactionId,
    String? customerNotes,
    String? rewardType,
    String? deliveryPasscode,
    String? pickupBarcode,
    String? gstinFooter,
    String? fsaiNumber,
  }) async {
    try {
      if (_status != PrinterConnectionStatus.connected) {
        throw Exception('Printer not connected');
      }

      final template = BillTemplate(
        storeName: storeName,
        address: address,
        phone: phone,
        email: email,
        gstNumber: gstNumber,
        billNumber: billNumber,
        timestamp: timestamp,
        orderSource: orderSource,
        customerName: customerName,
        customerPhone: customerPhone,
        orderType: orderType,
        tokenNumber: tokenNumber,
        tableNumber: tableNumber,
        items: items,
        subtotal: subtotal,
        discount: discount,
        fixedDiscount: fixedDiscount,
        containerCharge: containerCharge,
        deliveryCharge: deliveryCharge,
        packagingCharge: packagingCharge,
        serviceCharge: serviceCharge,
        cgst: cgst,
        sgst: sgst,
        grandTotal: grandTotal,
        paymentMethod: paymentMethod,
        transactionId: transactionId,
        customerNotes: customerNotes,
        rewardType: rewardType,
        deliveryPasscode: deliveryPasscode,
        pickupBarcode: pickupBarcode,
        gstinFooter: gstinFooter,
        fsaiNumber: fsaiNumber,
      );

      final billData = EscPosGenerator.generateBill(template);
      // await _bluetooth.writeBytes(billData); // Mock print for now
      print('Bill printed to console: ${billData.length} bytes');
      
      return true;
    } catch (e) {
      _updateStatus(PrinterConnectionStatus.error, 'Bill print error: $e');
      return false;
    }
  }

  Future<bool> printSummaryReport({
    required String storeName,
    required DateTime startDate,
    required DateTime endDate,
    required int totalOrders,
    required double grossSales,
    required double averageOrder,
    required int itemsSold,
    required List<Map<String, dynamic>> topItems,
    required String deviceId,
  }) async {
    try {
      if (_status != PrinterConnectionStatus.connected) {
        throw Exception('Printer not connected');
      }

      final reportData = EscPosGenerator.generateSummaryReport(
        storeName: storeName,
        startDate: startDate,
        endDate: endDate,
        totalOrders: totalOrders,
        grossSales: grossSales,
        averageOrder: averageOrder,
        itemsSold: itemsSold,
        topItems: topItems,
        deviceId: deviceId,
      );

      // await _bluetooth.writeBytes(reportData); // Mock print for now
      print('Report printed to console: ${reportData.length} bytes');
      return true;
    } catch (e) {
      _updateStatus(PrinterConnectionStatus.error, 'Report print error: $e');
      return false;
    }
  }

  Future<bool> testPrint() async {
    try {
      if (_status != PrinterConnectionStatus.connected) {
        throw Exception('Printer not connected');
      }

      final testItems = [
        const KotItem(quantity: 1, name: 'Test Item 1'),
        const KotItem(quantity: 2, name: 'Test Item 2', notes: 'No onions'),
      ];

      return await printKot(
        storeName: 'Test Restaurant',
        orderType: 'DINE-IN',
        tokenOrTable: 'T1',
        server: 'Test Server',
        timestamp: DateTime.now(),
        deviceId: 'TEST-DEVICE',
        items: testItems,
      );
    } catch (e) {
      _updateStatus(PrinterConnectionStatus.error, 'Test print error: $e');
      return false;
    }
  }

  void dispose() {
    _statusController.close();
    _devicesController.close();
  }
}
