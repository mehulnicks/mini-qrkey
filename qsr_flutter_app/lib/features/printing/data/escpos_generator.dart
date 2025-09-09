import 'dart:typed_data';

class EscPosCommands {
  // ESC/POS Control Commands
  static const List<int> esc = [0x1B];
  static const List<int> gs = [0x1D];
  static const List<int> lf = [0x0A];
  static const List<int> cr = [0x0D];
  static const List<int> crlf = [0x0D, 0x0A];

  // Initialize printer
  static List<int> init() => esc + [0x40];

  // Text formatting
  static List<int> bold(bool enabled) => esc + [0x45, enabled ? 1 : 0];
  static List<int> underline(bool enabled) => esc + [0x2D, enabled ? 1 : 0];
  static List<int> doubleHeight(bool enabled) => esc + [0x21, enabled ? 0x10 : 0x00];
  static List<int> doubleWidth(bool enabled) => esc + [0x21, enabled ? 0x20 : 0x00];
  static List<int> doubleSize(bool enabled) => esc + [0x21, enabled ? 0x30 : 0x00];

  // Text alignment
  static List<int> alignLeft() => esc + [0x61, 0x00];
  static List<int> alignCenter() => esc + [0x61, 0x01];
  static List<int> alignRight() => esc + [0x61, 0x02];

  // Line feeds
  static List<int> feed(int lines) => List.filled(lines, 0x0A);

  // Cut paper
  static List<int> cut() => gs + [0x56, 0x00];
  static List<int> cutPartial() => gs + [0x56, 0x01];

  // Character size
  static List<int> setSize(int width, int height) {
    int size = ((width - 1) << 4) | (height - 1);
    return gs + [0x21, size];
  }

  // Print text
  static List<int> text(String text) => text.codeUnits;

  // Print line separator
  static List<int> separator([String char = '-', int length = 32]) {
    return text(char * length) + crlf;
  }

  // QR Code (if supported by printer)
  static List<int> qrCode(String data) {
    List<int> commands = [];
    
    // Set QR code module size
    commands.addAll(gs + [0x28, 0x6B, 0x03, 0x00, 0x31, 0x43, 0x03]);
    
    // Set QR code error correction level
    commands.addAll(gs + [0x28, 0x6B, 0x03, 0x00, 0x31, 0x45, 0x30]);
    
    // Store QR code data
    List<int> dataBytes = data.codeUnits;
    int len = dataBytes.length + 3;
    commands.addAll(gs + [0x28, 0x6B, len & 0xFF, (len >> 8) & 0xFF, 0x31, 0x50, 0x30]);
    commands.addAll(dataBytes);
    
    // Print QR code
    commands.addAll(gs + [0x28, 0x6B, 0x03, 0x00, 0x31, 0x51, 0x30]);
    
    return commands;
  }
}

class KotTemplate {
  final String storeName;
  final String orderType;
  final String tokenOrTable;
  final String server;
  final DateTime timestamp;
  final String deviceId;
  final List<KotItem> items;

  const KotTemplate({
    required this.storeName,
    required this.orderType,
    required this.tokenOrTable,
    required this.server,
    required this.timestamp,
    required this.deviceId,
    required this.items,
  });
}

class KotItem {
  final int quantity;
  final String name;
  final String? notes;

  const KotItem({
    required this.quantity,
    required this.name,
    this.notes,
  });
}

class EscPosGenerator {
  static Uint8List generateKot(KotTemplate template) {
    List<int> commands = [];

    // Initialize printer
    commands.addAll(EscPosCommands.init());

    // Header
    commands.addAll(EscPosCommands.alignCenter());
    commands.addAll(EscPosCommands.bold(true));
    commands.addAll(EscPosCommands.doubleSize(true));
    commands.addAll(EscPosCommands.text(template.storeName));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.bold(false));
    commands.addAll(EscPosCommands.doubleSize(false));
    commands.addAll(EscPosCommands.crlf);

    // KOT Title
    commands.addAll(EscPosCommands.bold(true));
    commands.addAll(EscPosCommands.doubleHeight(true));
    commands.addAll(EscPosCommands.text('KITCHEN ORDER TICKET'));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.bold(false));
    commands.addAll(EscPosCommands.doubleHeight(false));
    commands.addAll(EscPosCommands.crlf);

    // Order Info
    commands.addAll(EscPosCommands.alignLeft());
    commands.addAll(EscPosCommands.separator());
    
    // Token/Table and Order Type
    String tokenTableLabel = template.orderType.toUpperCase() == 'DINEIN' ? 'Table' : 'Token';
    commands.addAll(EscPosCommands.text('$tokenTableLabel: ${template.tokenOrTable}'));
    commands.addAll(EscPosCommands.text(' ' * (16 - template.tokenOrTable.length - tokenTableLabel.length - 2)));
    commands.addAll(EscPosCommands.text('Type: ${template.orderType.toUpperCase()}'));
    commands.addAll(EscPosCommands.crlf);
    
    // Server and timestamp
    String timeStr = _formatTime(template.timestamp);
    commands.addAll(EscPosCommands.text('Server: ${template.server}'));
    if (template.server.length < 10) {
      commands.addAll(EscPosCommands.text(' ' * (16 - template.server.length - 8)));
      commands.addAll(EscPosCommands.text(timeStr));
    } else {
      commands.addAll(EscPosCommands.crlf);
      commands.addAll(EscPosCommands.text('Time: $timeStr'));
    }
    commands.addAll(EscPosCommands.crlf);
    
    commands.addAll(EscPosCommands.separator());
    commands.addAll(EscPosCommands.crlf);

    // Items
    commands.addAll(EscPosCommands.bold(true));
    commands.addAll(EscPosCommands.text('ITEMS:'));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.bold(false));
    commands.addAll(EscPosCommands.crlf);

    for (final item in template.items) {
      // Quantity and item name
      String qtyStr = '${item.quantity}x';
      String itemLine = '$qtyStr ${item.name}';
      
      if (itemLine.length > 32) {
        // Split long item names
        commands.addAll(EscPosCommands.text(qtyStr));
        commands.addAll(EscPosCommands.crlf);
        commands.addAll(EscPosCommands.text('  ${item.name}'));
        commands.addAll(EscPosCommands.crlf);
      } else {
        commands.addAll(EscPosCommands.text(itemLine));
        commands.addAll(EscPosCommands.crlf);
      }

      // Item notes
      if (item.notes != null && item.notes!.isNotEmpty) {
        String notesText = '  Note: ${item.notes!}';
        if (notesText.length > 32) {
          // Word wrap notes
          List<String> words = item.notes!.split(' ');
          String currentLine = '  Note: ';
          
          for (String word in words) {
            if ((currentLine + word).length <= 32) {
              currentLine += word + ' ';
            } else {
              commands.addAll(EscPosCommands.text(currentLine.trimRight()));
              commands.addAll(EscPosCommands.crlf);
              currentLine = '    $word ';
            }
          }
          
          if (currentLine.trim().isNotEmpty) {
            commands.addAll(EscPosCommands.text(currentLine.trimRight()));
            commands.addAll(EscPosCommands.crlf);
          }
        } else {
          commands.addAll(EscPosCommands.text(notesText));
          commands.addAll(EscPosCommands.crlf);
        }
      }
      
      commands.addAll(EscPosCommands.crlf);
    }

    // Footer
    commands.addAll(EscPosCommands.separator());
    commands.addAll(EscPosCommands.alignCenter());
    
    String footerTime = _formatDateTime(template.timestamp);
    commands.addAll(EscPosCommands.text('Printed: $footerTime'));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.text('Device: ${template.deviceId}'));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.crlf);

    // Cut paper
    commands.addAll(EscPosCommands.cut());

    return Uint8List.fromList(commands);
  }

  static Uint8List generateSummaryReport({
    required String storeName,
    required DateTime startDate,
    required DateTime endDate,
    required int totalOrders,
    required double grossSales,
    required double averageOrder,
    required int itemsSold,
    required List<Map<String, dynamic>> topItems,
    required String deviceId,
  }) {
    List<int> commands = [];

    // Initialize printer
    commands.addAll(EscPosCommands.init());

    // Header
    commands.addAll(EscPosCommands.alignCenter());
    commands.addAll(EscPosCommands.bold(true));
    commands.addAll(EscPosCommands.doubleSize(true));
    commands.addAll(EscPosCommands.text(storeName));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.bold(false));
    commands.addAll(EscPosCommands.doubleSize(false));
    commands.addAll(EscPosCommands.crlf);

    // Report title
    commands.addAll(EscPosCommands.bold(true));
    commands.addAll(EscPosCommands.doubleHeight(true));
    commands.addAll(EscPosCommands.text('SALES SUMMARY'));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.bold(false));
    commands.addAll(EscPosCommands.doubleHeight(false));
    commands.addAll(EscPosCommands.crlf);

    // Date range
    commands.addAll(EscPosCommands.alignLeft());
    String dateRange = '${_formatDate(startDate)} to ${_formatDate(endDate)}';
    commands.addAll(EscPosCommands.text(dateRange));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.separator());

    // Metrics
    commands.addAll(EscPosCommands.text('SUMMARY:'));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.text('Total Orders: $totalOrders'));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.text('Gross Sales: \$${grossSales.toStringAsFixed(2)}'));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.text('Average Order: \$${averageOrder.toStringAsFixed(2)}'));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.text('Items Sold: $itemsSold'));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.crlf);

    // Top items
    if (topItems.isNotEmpty) {
      commands.addAll(EscPosCommands.text('TOP ITEMS:'));
      commands.addAll(EscPosCommands.crlf);
      commands.addAll(EscPosCommands.separator('-', 32));
      
      for (int i = 0; i < topItems.length; i++) {
        final item = topItems[i];
        String line = '${i + 1}. ${item['name']} x${item['quantity']}';
        if (line.length > 32) {
          commands.addAll(EscPosCommands.text('${i + 1}. ${item['name']}'));
          commands.addAll(EscPosCommands.crlf);
          commands.addAll(EscPosCommands.text('   x${item['quantity']}'));
          commands.addAll(EscPosCommands.crlf);
        } else {
          commands.addAll(EscPosCommands.text(line));
          commands.addAll(EscPosCommands.crlf);
        }
      }
      commands.addAll(EscPosCommands.crlf);
    }

    // Footer
    commands.addAll(EscPosCommands.separator());
    commands.addAll(EscPosCommands.alignCenter());
    String footerTime = _formatDateTime(DateTime.now());
    commands.addAll(EscPosCommands.text('Generated: $footerTime'));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.text('Device: $deviceId'));
    commands.addAll(EscPosCommands.crlf);
    commands.addAll(EscPosCommands.crlf);

    // Cut paper
    commands.addAll(EscPosCommands.cut());

    return Uint8List.fromList(commands);
  }

  static String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  static String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${_formatTime(dateTime)}';
  }
}
