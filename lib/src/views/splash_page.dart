import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/core/constants/app_icons.dart';
import 'package:splithawk/src/core/routes/routes.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool hasNavigated = false; // Flag to prevent redundant navigation
  Timer? _navigationTimer;

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        debugPrint("Splash screen Listener called");
        _navigationTimer?.cancel(); // Cancel any existing timer
        _navigationTimer = Timer(const Duration(seconds: 2), () {
          if (!hasNavigated) {
            hasNavigated = true;

            if (state.authStatus == AuthStatus.authenticated) {
              debugPrint("Navigating to the home screen from splash screen");
              context.goNamed(AppRoutesName.main);
            } else if (state.authStatus == AuthStatus.initial ||
                state.authStatus == AuthStatus.unauthenticated) {
              debugPrint("Navigating to the signin screen from splash screen");
              context.goNamed(AppRoutesName.signin);
            }

            return;
          }
          if (state.authStatus == AuthStatus.unauthenticated) {
            debugPrint("Navigating to the signin screen from splash screen");
            context.goNamed(AppRoutesName.signin);
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
