import 'package:flutter/material.dart';

class LinkGoogleCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onLinkGoogle;

  const LinkGoogleCard({
    super.key,
    required this.isLoading,
    required this.onLinkGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Link Google Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Connect your Google account to sign in more easily.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.g_mobiledata_rounded),
              label: const Text('Link Google Account'),
              onPressed: isLoading ? null : onLinkGoogle,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
