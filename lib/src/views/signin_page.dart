import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/core/routes/names.dart';
import 'package:splithawk/src/core/validators/app_text_validators.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

class SigninPage extends StatelessWidget {
  final String? initEmail;
  const SigninPage({super.key, this.initEmail});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // Initialize email with initEmail if available
    String? email = initEmail;
    String? password;

    void submit() {
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();

        context.read<AuthBloc>().add(
          AuthSignInWithEmailEvent(email: email!, password: password!),
        );
      }
    }

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state.authStatus) {
          case AuthStatus.initial:
            print("initial");
            break;
          case AuthStatus.loading:
            print("loading");
            break;
          case AuthStatus.authenticated:
            context.goNamed(AppRoutesName.home);
            print("authenticated");
            break;
          case AuthStatus.error:
            state.error?.showErrorDialog(context);
            break;
          default:
            break;
        }
      },
      builder:
          (context, state) => GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              // backgroundColor: Colors.blue[100],
              body: SafeArea(
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: AppColors.highlight,
                          fixedSize: Size.fromWidth(200),
                        ),
                        onPressed: () async {
                          state.authStatus == AuthStatus.loading
                              ? null
                              : context.pushNamed(AppRoutesName.signup);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.createAccount,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: formKey,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text("Login to continue"),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                readOnly:
                                    state.authStatus == AuthStatus.loading,
                                // Use both onSaved and onChanged
                                onSaved: (value) => email = value,
                                onChanged: (value) => email = value,

                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.email,
                                  filled: true,
                                  prefixIcon: Icon(Icons.email),
                                ),
                                initialValue: initEmail,

                                autocorrect: false,
                                validator:
                                    (value) => AppTextValidators.validateEmail(
                                      context,
                                      value,
                                    ),
                                enableSuggestions: true,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                readOnly:
                                    state.authStatus == AuthStatus.loading,
                                onSaved: (value) => password = value,
                                obscureText: true,
                                onFieldSubmitted: (value) => submit(),

                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.password,
                                  filled: true,
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                validator:
                                    (value) =>
                                        AppTextValidators.validatePassword(
                                          context,
                                          value,
                                        ),
                                // controller: controller.password,
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  state.authStatus == AuthStatus.loading
                                      ? null
                                      : context.pushNamed(
                                        AppRoutesName.resetPassword,
                                        queryParameters: {'email': email},
                                      );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.forgotPassword,
                                ),
                              ),
                              const SizedBox(height: 8),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  // backgroundColor: AppColors.highlight,
                                  fixedSize: Size.fromWidth(200),
                                ),
                                onPressed: () async {
                                  state.authStatus == AuthStatus.loading
                                      ? null
                                      : submit();
                                },
                                child: Text(
                                  state.authStatus == AuthStatus.loading
                                      ? AppLocalizations.of(context)!.loading
                                      : AppLocalizations.of(context)!.signIn,
                                ),
                              ),
                              SizedBox(height: 26),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.additionalLoginMethods,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  // backgroundColor: AppColors.highlight,
                                  fixedSize: Size.fromWidth(300),
                                ),
                                onPressed: () async {
                                  state.authStatus == AuthStatus.loading
                                      ? null
                                      : context.read<AuthBloc>().add(
                                        AuthSignInWithGoogleEvent(),
                                      );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.g_mobiledata),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 25.0,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.signInWithGoogle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
