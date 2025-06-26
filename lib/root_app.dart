import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/core/cubit/localization_cubit.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/services/service_locator.dart';
import 'package:splithawk/src/core/theme/app_theme.dart';
import 'package:splithawk/src/core/theme/cubit/theme_cubit.dart';

import 'package:flutter/material.dart';
import 'src/core/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, ch) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ThemeCubit()),
              BlocProvider<LocalizationCubit>(
                create:
                    (context) => LocalizationCubit(systemLocale: systemLocale),
              ),
              BlocProvider<AuthBloc>.value(value: locator<AuthBloc>()),
            ],

            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return MaterialApp.router(
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: [Locale('en'), Locale('ar'), Locale('fr')],
                  theme: AppTheme.lightTheme(),
                  darkTheme: AppTheme.darkTheme(),
                  themeMode: state.themeMode,
                  debugShowCheckedModeBanner: false,
                  routerConfig: appRouter,
                  locale: context.watch<LocalizationCubit>().state,
                );
              },
            ),
          ),
    );
  }
}
