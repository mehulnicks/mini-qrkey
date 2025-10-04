import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/subscription_dashboard_widget.dart';
import '../widgets/subscription_metrics_widget.dart';
import '../providers/subscription_provider.dart';
import '../core/theme/qrkey_theme.dart';

class SubscriptionTestScreen extends ConsumerWidget {
  const SubscriptionTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Test'),
        backgroundColor: QRKeyTheme.primarySaffron,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subscription Dashboard Widget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SubscriptionDashboardWidget(),
            SizedBox(height: 24),
            Text(
              'Subscription Metrics Widget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SubscriptionMetricsWidget(),
            SizedBox(height: 24),
            Text(
              'Compact Subscription Widget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CompactSubscriptionWidget(),
                Spacer(),
                Text('Used in headers and navigation'),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Quick Metrics Widget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            QuickMetricsWidget(),
            SizedBox(height: 24),
            Text(
              'Compact Metrics Widget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SubscriptionMetricsWidget(compact: true),
          ],
        ),
      ),
    );
  }
}
