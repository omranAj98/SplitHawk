import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/routes.dart';
import 'package:splithawk/src/core/validators/app_text_validators.dart';
import 'package:splithawk/src/core/widgets/app_safe_area.dart';
import 'package:splithawk/src/core/widgets/app_snack_bar.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String? initEmail;
  const ResetPasswordScreen({super.key, this.initEmail});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? email = initEmail;

    void submit() {
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();

        context.read<AuthBloc>().add(AuthResetPasswordEvent(email: email!));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.resetPassword)),
      body: AppSafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            switch (state.authStatus) {
              case AuthStatus.loading:
                print("loading");
                break;
              case AuthStatus.success:
                AppSnackBar.show(
                  context,
                  message: AppLocalizations.of(context)!.resetLinkSent,
                  type: SnackBarType.success,
                );
                context.goNamed(
                  AppRoutesName.signin,
                  queryParameters: {'email': email},
                );
                break;
              case AuthStatus.error:
                state.error?.showErrorDialog(context);
              case AuthStatus.unauthenticated:
              case AuthStatus.initial:
              case AuthStatus.authenticated:
                break;
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    readOnly: state.authStatus == AuthStatus.loading,
                    // onSaved: (value) => email = value,
                    onChanged: (value) => email = value,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.email,
                      filled: true,
                      prefixIcon: Icon(Icons.email),
                    ),
                    initialValue: initEmail,
                    autocorrect: false,
                    onFieldSubmitted: (value) => submit(),
                    validator:
                        (value) =>
                            AppTextValidators.validateEmail(context, value),
                    enableSuggestions: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      state.authStatus == AuthStatus.loading ? null : submit();
                    },
                    child: Text(
                      state.authStatus == AuthStatus.loading
                          ? AppLocalizations.of(context)!.loading
                          : AppLocalizations.of(context)!.resetPassword,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}