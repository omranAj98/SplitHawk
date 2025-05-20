import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/constants/app_size.dart';
import 'package:splithawk/src/core/cubit/localization_cubit.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/routes.dart';
import 'package:splithawk/src/core/theme/cubit/theme_cubit.dart';
import 'package:splithawk/src/core/theme/shimmer/shimmer_box_decoration.dart';
import 'package:splithawk/src/core/widgets/app_snack_bar.dart';
import 'package:splithawk/src/views/account/widgets/dialog_qrcode.dart';
import 'package:url_launcher/url_launcher.dart';

part 'widgets/app_settings.dart';
part 'widgets/account_settings.dart';
part 'widgets/qr_section.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  Future<void> _refreshUserData(BuildContext context) async {
    // Call the method to reload user data
    await context.read<UserCubit>().getSelfUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state.requestStatus == RequestStatus.error) {
            state.error!.showErrorDialog(context);
          } 
          if (state.user!.isEmailVerified == false) {
            context.read<AuthBloc>().add(AuthReloadVerificationEvent());
          }
        },
        child: RefreshIndicator(
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
      ),
    );
  }
}
