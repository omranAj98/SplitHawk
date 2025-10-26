import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/routes/names.dart';
import 'package:splithawk/src/core/validators/app_text_validators.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/widgets/app_safe_area.dart';

class SigninPage extends StatefulWidget {
  final String? initEmail;
  const SigninPage({super.key, this.initEmail});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignInWithEmailEvent(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        switch (state.authStatus) {
          case AuthStatus.initial:
            print("initial");
            break;
          case AuthStatus.loading:
            print("loading");
            break;
          case AuthStatus.authenticated:
            // After successful authentication, fetch the user's data.
            await context.read<UserCubit>().getSelfUser();
            // Ensure the widget is still mounted before navigating.
            if (!mounted) return;
            // Check if the user data was fetched successfully before navigating.
            if (context.read<UserCubit>().state.user != null) {
              context.goNamed(AppRoutesName.home);
            }
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
              body: AppSafeArea(
                child: Center(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
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
                          key: _formKey,
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text("Login to continue"),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                readOnly:
                                    state.authStatus == AuthStatus.loading,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.email,
                                  filled: true,
                                  prefixIcon: Icon(Icons.email),
                                ),
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
                                controller: _passwordController,
                                obscureText: true,
                                onFieldSubmitted: (value) => _submit(),

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
                                        queryParameters: {
                                          'email': _emailController.text,
                                        },
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
                                      : _submit();
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
