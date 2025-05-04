library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/core/widgets/not_found_page.dart';
import 'package:splithawk/src/pages/main_page.dart';
import 'package:splithawk/src/pages/reset_password_screen.dart';
import 'package:splithawk/src/pages/signin_page.dart';
import 'package:splithawk/src/pages/signup/signup_screen.dart';
import 'package:splithawk/src/pages/splash_page.dart';
import 'routes.dart';

final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      name: AppRoutesName.init,
      builder: (context, state) => SplashPage(),
      routes: [
        GoRoute(
          path: 'signin',
          name: AppRoutesName.signin,

          builder: (context, state) {
            final email = state.uri.queryParameters['email'];
            return PopScope(
              canPop: false,
              child: SigninPage(initEmail: email ?? ''),
            );
          },
        ),
        GoRoute(
          path: 'home',
          name: AppRoutesName.home,
          builder: (context, state) {
            return PopScope(canPop: false, child: MainPage());
          },
        ),
        GoRoute(
          path: 'reset_password',
          name: AppRoutesName.resetPassword,
          builder: (context, state) {
            final email = state.uri.queryParameters['email'];
            return ResetPasswordScreen(initEmail: email);
          },
        ),
        GoRoute(
          path: 'signup',
          name: AppRoutesName.signup,
          builder: (context, state) {
            final email = state.uri.queryParameters['email'];
            return SignupScreen();
          },
        ),
      ],
    ),
  ],
  errorBuilder:
      (context, state) => const NotFoundPage(), // Handles unknown routes
);
