part of '../account_screen.dart';

class AppSettings extends StatelessWidget {
  final BuildContext context;
  const AppSettings({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.darkMode),
              dragStartBehavior:
                  context.read<ThemeCubit>().state.themeMode == ThemeMode.dark
                      ? DragStartBehavior.down
                      : DragStartBehavior.start,
              secondary: const Icon(Icons.dark_mode),
              value:
                  context.watch<ThemeCubit>().state.themeMode == ThemeMode.dark,
              onChanged: (bool value) {
                context.read<ThemeCubit>().toggleTheme(value);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.language),
              trailing: DropdownButton<Locale>(
                value: context.watch<LocalizationCubit>().state,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                items: [
                  const DropdownMenuItem(
                    value: Locale('en'),
                    child: Text('English'),
                    // onTap: () => context.read<LocalizationCubit>().changeLocale(Locale('en', 'US')),
                  ),
                  const DropdownMenuItem(
                    value: Locale('ar'),
                    child: Text('العربية'),
                  ),
                  const DropdownMenuItem(
                    value: Locale('fr'),
                    child: Text('Français'),
                  ),
                ],
                onChanged: (Locale? newValue) {
                  context.read<LocalizationCubit>().changeLocale(
                    newValue ?? const Locale('en'),
                  );
                  print("Language selected: $newValue");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
