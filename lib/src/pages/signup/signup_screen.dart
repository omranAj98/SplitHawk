import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/pages/signup/signup_form.dart';

class SignupScreen extends StatelessWidget {
  final String? initEmail;
  const SignupScreen({super.key, this.initEmail});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error!.message.toString() ?? 'An error occurred',
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SignupForm(initEmail: initEmail,)],
            ),
          ),
        ),
      ),
    );
  }
}
