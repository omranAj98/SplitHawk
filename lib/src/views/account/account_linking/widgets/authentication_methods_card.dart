import 'package:flutter/material.dart';

class AuthenticationMethodsCard extends StatelessWidget {
  final List<String> linkedProviders;
  final bool hasEmailProvider;
  final bool hasGoogleProvider;
  final Function(BuildContext, String) onUnlink;

  const AuthenticationMethodsCard({
    super.key,
    required this.linkedProviders,
    required this.hasEmailProvider,
    required this.hasGoogleProvider,
    required this.onUnlink,
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
              'Your account can be accessed using:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Email/Password status
            _buildAuthMethodTile(
              context,
              icon: Icons.email,
              title: 'Email and Password',
              isConnected: hasEmailProvider,
              providerId: 'password',
            ),

            // Google status
            _buildAuthMethodTile(
              context,
              icon: Icons.g_mobiledata_rounded,
              title: 'Google',
              isConnected: hasGoogleProvider,
              providerId: 'google.com',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthMethodTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isConnected,
    required String providerId,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(isConnected ? 'Connected' : 'Not connected'),
      trailing:
          isConnected && linkedProviders.length > 1
              ? TextButton(
                onPressed: () => onUnlink(context, providerId),
                child: const Text('Disconnect'),
              )
              : null,
    );
  }
}
