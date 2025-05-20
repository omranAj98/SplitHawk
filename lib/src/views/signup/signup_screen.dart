import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/core/error/snackbar_error.dart';
import 'package:splithawk/src/views/signup/signup_form.dart';

class SignupScreen extends StatelessWidget {
  final String? initEmail;
  const SignupScreen({super.key, this.initEmail});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.error) {
          AppErrorSnackBar(error: state.error!, context: context);
        }
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SignupForm(initEmail: initEmail)],
            ),
          ),
        ),
      ),
    );
  }
}
