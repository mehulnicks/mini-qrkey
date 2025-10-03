import 'package:flutter/material.dart';
import 'cloud_sync_screen.dart';
import 'analytics_screen.dart';

class CloudFeaturesScreen extends StatelessWidget {
  const CloudFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cloud Features'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Cloud Sync'),
              Tab(text: 'Analytics'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CloudSyncScreen(),
            AnalyticsScreen(),
          ],
        ),
      ),
    );
  }
}
