import 'package:flutter/material.dart';

class SupabaseDemoScreen extends StatelessWidget {
  const SupabaseDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Demo'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Supabase Demo Screen'),
      ),
    );
  }
}