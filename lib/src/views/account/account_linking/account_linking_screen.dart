import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/views/account/account_linking/widgets/authentication_methods_card.dart';
import 'package:splithawk/src/views/account/account_linking/widgets/link_email_password_card.dart';
import 'package:splithawk/src/views/account/account_linking/widgets/link_google_card.dart';

class AccountLinkingScreen extends StatefulWidget {
  const AccountLinkingScreen({Key? key}) : super(key: key);

  @override
  State<AccountLinkingScreen> createState() => _AccountLinkingScreenState();
}

class _AccountLinkingScreenState extends State<AccountLinkingScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Account Authentication')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: _authStateListener,
        builder: (context, state) {
          // Get current user's linked providers
          final linkedProviders =
              context.read<AuthBloc>().authRepository.getLinkedProviders();
          final hasEmailProvider = linkedProviders.contains('password');
          final hasGoogleProvider = linkedProviders.contains('google.com');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Connected Authentication Methods',
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 16),

                // Current authentication methods
                AuthenticationMethodsCard(
                  linkedProviders: linkedProviders,
                  hasEmailProvider: hasEmailProvider,
                  hasGoogleProvider: hasGoogleProvider,
                  onUnlink: _showUnlinkConfirmation,
                ),

                const SizedBox(height: 24),
                Text('Add Authentication Method', style: textTheme.titleSmall),
                const SizedBox(height: 16),

                // Link with Google
                if (!hasGoogleProvider)
                  LinkGoogleCard(
                    isLoading: _isLoading,
                    onLinkGoogle:
                        () => context.read<AuthBloc>().add(
                          const AuthLinkWithGoogleEvent(),
                        ),
                  ),

                const SizedBox(height: 16),

                // Link with Email/Password
                if (!hasEmailProvider)
                  LinkEmailPasswordCard(
                    isLoading: _isLoading,
                    userEmail: state.user?.email,
                    onLinkEmail:
                        (email, password) => context.read<AuthBloc>().add(
                          AuthLinkWithEmailEvent(
                            email: email,
                            password: password,
                          ),
                        ),
                  ),

                const SizedBox(height: 32),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }

  void _authStateListener(BuildContext context, AuthState state) {
    if (state.authStatus == AuthStatus.linkingSuccess) {
      setState(() => _isLoading = false);
      _showSuccessSnackBar(context, 'Account linked successfully!');
    } else if (state.authStatus == AuthStatus.unlinkingSuccess) {
      setState(() => _isLoading = false);
      _showSuccessSnackBar(context, 'Account unlinked successfully!');
    } else if (state.authStatus == AuthStatus.linkingFailed ||
        state.authStatus == AuthStatus.unlinkingFailed ||
        state.authStatus == AuthStatus.accountConflict ||
        state.authStatus == AuthStatus.error) {
      setState(() => _isLoading = false);
      state.error?.showErrorDialog(context);
    } else if (state.authStatus == AuthStatus.loading) {
      setState(() => _isLoading = true);
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showUnlinkConfirmation(BuildContext context, String providerId) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Disconnect Authentication Method'),
            content: const Text(
              'Are you sure you want to disconnect this authentication method? '
              'You will no longer be able to sign in using it.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.read<AuthBloc>().add(
                    AuthUnlinkProviderEvent(providerId: providerId),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Disconnect'),
              ),
            ],
          ),
    );
  }
}
