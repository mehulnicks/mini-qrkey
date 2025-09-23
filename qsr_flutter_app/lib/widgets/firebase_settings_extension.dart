import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_wrapper.dart';

class FirebaseSettingsExtension extends ConsumerWidget {
  final Widget originalSettingsContent;
  
  const FirebaseSettingsExtension({
    super.key,
    required this.originalSettingsContent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    
    return Column(
      children: [
        // User Profile Section
        if (user != null) ...[
          Card(
            margin: const EdgeInsets.all(16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFFF9933),
                backgroundImage: user.photoURL != null 
                    ? NetworkImage(user.photoURL!) 
                    : null,
                child: user.photoURL == null
                    ? Text(
                        (user.displayName?.isNotEmpty == true 
                            ? user.displayName![0].toUpperCase()
                            : user.email?[0].toUpperCase() ?? 'U'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              title: Text(user.displayName ?? 'User'),
              subtitle: Text(user.email ?? ''),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ),
          const Divider(),
        ],
        
        // Original Settings Content
        Expanded(child: originalSettingsContent),
      ],
    );
  }
}
