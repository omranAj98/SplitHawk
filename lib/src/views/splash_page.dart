import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/core/constants/app_icons.dart';
import 'package:splithawk/src/core/routes/routes.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    bool hasNavigated = false; // Flag to prevent redundant navigation

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        debugPrint("Splash screen Listener called");
        Future.delayed(const Duration(seconds: 2), () {
          if (hasNavigated == false) {
            hasNavigated = true;

            if (state.authStatus == AuthStatus.authenticated) {
              debugPrint("Navigating to the home screen from splash screen");
              context.pushReplacementNamed(AppRoutesName.home);
            } else if (state.authStatus == AuthStatus.initial ||
                state.authStatus == AuthStatus.unauthenticated) {
              debugPrint("Navigating to the signin screen from splash screen");
              context.pushReplacementNamed(AppRoutesName.signin);
            }

            return;
          }
          if (state.authStatus == AuthStatus.unauthenticated) {
            debugPrint("Navigating to the signin screen from splash screen");
            context.pushReplacementNamed(AppRoutesName.signin);

            return;
          }
        });
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(AppIcons.splashImage),
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                "${AppLocalizations.of(context)!.home} ${AppLocalizations.of(context)!.appName}",
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.appDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              CircularProgressIndicator(
                color: colorScheme.primary,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
