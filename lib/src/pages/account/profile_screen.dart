import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/constants/app_size.dart';
import 'package:splithawk/src/core/cubit/localization_cubit.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/theme/cubit/theme_cubit.dart';
import 'package:splithawk/src/pages/account/dialog_qrcode.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'app_settings.dart';
part 'account_settings.dart';
part 'qr_section.dart';

class ProfileScreen extends StatelessWidget {
  bool initLoad = false;
  ProfileScreen({super.key});

  Future<void> _refreshUserData(BuildContext context) async {
    // Call the method to reload user data
    await context.read<UserCubit>().getSelfUser();
  }

  @override
  Widget build(BuildContext context) {
    initLoad ? null : (_refreshUserData(context), initLoad = true);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refreshUserData(context),
        child: ListView(
          padding: const EdgeInsets.all(AppSize.paddingSizeL2),
          children: [
            AccountSettings(context: context),
            const SizedBox(height: 32),

            Text(
              AppLocalizations.of(context)!.settings,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            AppSettings(context: context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
