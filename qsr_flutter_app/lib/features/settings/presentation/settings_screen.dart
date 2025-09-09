import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../shared/providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    if (settings.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // KOT Feature Section
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.print),
                title: const Text('KOT Printing'),
                subtitle: const Text('Enable Kitchen Order Ticket printing'),
                trailing: Switch(
                  value: settings.kotEnabled,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setKotEnabled(value);
                  },
                ),
              ),
              if (settings.kotEnabled) ...[
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: const Text('Bluetooth Printer'),
                  subtitle: Text(
                    settings.selectedPrinter ?? 'No printer selected',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPrinterSelection(context, ref),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Store Information Section
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.store),
                title: const Text('Store Information'),
                subtitle: const Text('Configure store details'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('Store Name'),
                subtitle: Text(settings.storeName),
                trailing: const Icon(Icons.edit),
                onTap: () => _showEditDialog(
                  context,
                  ref,
                  'Store Name',
                  settings.storeName,
                  (value) => ref.read(settingsProvider.notifier).setStoreName(value),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Server Name'),
                subtitle: Text(settings.serverName),
                trailing: const Icon(Icons.edit),
                onTap: () => _showEditDialog(
                  context,
                  ref,
                  'Server Name',
                  settings.serverName,
                  (value) => ref.read(settingsProvider.notifier).setServerName(value),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Financial Settings Section
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Financial Settings'),
                subtitle: const Text('Configure tax rates and currency'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.percent),
                title: const Text('Tax Rate'),
                subtitle: Text('${(settings.taxRate * 100).toStringAsFixed(1)}%'),
                trailing: const Icon(Icons.edit),
                onTap: () => _showTaxRateDialog(context, ref, settings.taxRate),
              ),
              ListTile(
                leading: const Icon(Icons.currency_exchange),
                title: const Text('Currency Symbol'),
                subtitle: Text(settings.currencySymbol),
                trailing: const Icon(Icons.edit),
                onTap: () => _showEditDialog(
                  context,
                  ref,
                  'Currency Symbol',
                  settings.currencySymbol,
                  (value) => ref.read(settingsProvider.notifier).setCurrencySymbol(value),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Data Management Section
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Data Management'),
                subtitle: const Text('Backup and restore settings'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Export Settings'),
                subtitle: const Text('Save settings to file'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _exportSettings(context, ref),
              ),
              ListTile(
                leading: const Icon(Icons.upload),
                title: const Text('Import Settings'),
                subtitle: const Text('Load settings from file'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _importSettings(context, ref),
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Reset to Defaults'),
                subtitle: const Text('Restore all settings to default values'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showResetDialog(context, ref),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Device Information Section
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Device Information'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.device_hub),
                title: const Text('Device ID'),
                subtitle: Text(settings.deviceId),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('App Version'),
                subtitle: const Text('1.0.0+1'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPrinterSelection(BuildContext context, WidgetRef ref) {
    // TODO: Implement Bluetooth printer scanning and selection
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Printer'),
        content: const Text('Bluetooth printer selection will be implemented'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    String title,
    String currentValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: currentValue);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a value';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onSave(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showTaxRateDialog(BuildContext context, WidgetRef ref, double currentRate) {
    final controller = TextEditingController(
      text: (currentRate * 100).toStringAsFixed(1),
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tax Rate'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Tax Rate (%)',
              suffixText: '%',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a tax rate';
              }
              final rate = double.tryParse(value.trim());
              if (rate == null || rate < 0 || rate > 100) {
                return 'Please enter a valid tax rate (0-100)';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final rate = double.parse(controller.text.trim()) / 100;
                ref.read(settingsProvider.notifier).setTaxRate(rate);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(settingsProvider.notifier).resetToDefaults();
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings reset to defaults')),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportSettings(BuildContext context, WidgetRef ref) async {
    try {
      final settingsService = ref.read(settingsServiceProvider);
      final settingsJson = await settingsService.exportSettingsAsJson();
      
      // Create a temporary file
      final directory = Directory.systemTemp;
      final file = File('${directory.path}/qsr_settings_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(settingsJson);

      await Share.shareXFiles([XFile(file.path)], text: 'QSR App Settings');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings exported successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting settings: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _importSettings(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final settingsJson = await file.readAsString();
        
        final settingsService = ref.read(settingsServiceProvider);
        await settingsService.importSettingsFromJson(settingsJson);
        
        // Reload settings in provider
        await ref.read(settingsProvider.notifier)._loadSettings();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings imported successfully')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing settings: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
