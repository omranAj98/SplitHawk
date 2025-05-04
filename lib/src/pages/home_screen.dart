import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/core/cubit/localization_cubit.dart';
import 'package:splithawk/src/core/widgets/app_safe_area.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSafeArea(
      child: Scaffold(
        body: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<LocalizationCubit>().changeLocale(
                    const Locale('ar'),
                  );
                },
                child: const Text('العربية'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<LocalizationCubit>().changeLocale(
                    const Locale('en'),
                  );
                },
                child: const Text('English'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<LocalizationCubit>().changeLocale(
                    const Locale('fr'),
                  );
                },
                child: const Text('Français'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
