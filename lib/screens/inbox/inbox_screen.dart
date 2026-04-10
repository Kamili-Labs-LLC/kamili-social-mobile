import 'package:flutter/material.dart';
import '../../widgets/common/empty_state.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      body: const EmptyState(
        icon: Icons.mail_outline,
        title: 'Inbox Coming Soon',
        subtitle:
            'Unified messaging across all your social platforms is on the way.',
      ),
    );
  }
}
