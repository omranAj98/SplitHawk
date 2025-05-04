part of 'profile_screen.dart';

class AccountSettings extends StatelessWidget {
  final BuildContext context;

  const AccountSettings({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      // shrinkWrap: true,
      children: [
        const SizedBox(height: 32),
        Shimmer.fromColors(
          // enabled: false,
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: SizedBox(
            height: 200,
            width: 200,
            // decoration: BoxDecoration(shape: BoxShape.circle),
            child: GestureDetector(
              onTap: () {
                dialogQRCode(context);
              },
              child: Image.asset(
                "assets/images/qr-code.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          label: Text(AppLocalizations.of(context)!.scanYourFriendQrCode),
          icon: Icon(Icons.qr_code_scanner),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocConsumer<UserCubit, UserState>(
                  listener: (context, state) {
                    if (state.requestStatus == RequestStatus.error) {
                      state.error.showErrorDialog(context);
                    }
                  },
                  builder: (context, state) {
                    final loading =
                        state.requestStatus == RequestStatus.loading;
                    return ListTile(
                      leading: Icon(Icons.person),
                      title:
                          loading
                              ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 20,
                                  // width: double.minPositive,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                              )
                              : Text(
                                // context.watch<UserCubit>().state.user!.fullName,
                                state.user!.fullName,
                              ),
                      subtitle: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state.user!.emailVerified == false) {
                            context.read<AuthBloc>().add(
                              AuthReloadVerificationEvent(),
                            );
                          }
                        },

                        builder: (context, state) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text(state.user!.email!),
                                  state.user!.emailVerified
                                      ? Icon(
                                        Icons.verified,
                                        color: colorScheme.primary,
                                        size: 16,
                                      )
                                      : SizedBox(),
                                ],
                              ),
                              state.user!.emailVerified
                                  ? SizedBox()
                                  : TextButton(
                                    onPressed: () {
                                      context.read<AuthBloc>().add(
                                        AuthReloadVerificationEvent(),
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.sendVerficationEmail,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                const Divider(),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    // tilePadding:
                    //     EdgeInsets
                    //         .zero, // Optional: remove left/right padding
                    childrenPadding: EdgeInsets.only(left: 16.0),

                    leading: Icon(Icons.account_circle),
                    title: Text(AppLocalizations.of(context)!.accountSettings),
                    // trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text(
                          AppLocalizations.of(context)!.changePassword,
                        ),
                        onTap: () {
                          // Reset logic
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.lock_reset),
                        title: Text(
                          AppLocalizations.of(context)!.resetPassword,
                        ),
                        onTap: () {
                          // Reset logic
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.block_rounded),
                        title: Text(
                          AppLocalizations.of(context)!.manageBlockList,
                        ),
                        onTap: () {
                          // Reset logic
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.notifications_on),
                  title: Text(AppLocalizations.of(context)!.notifications),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.only(left: 16.0),
                    leading: Icon(Icons.support_agent_rounded),
                    title: Text(AppLocalizations.of(context)!.contactUs),
                    children: [
                      ListTile(
                        leading: Icon(Icons.web_asset_rounded),
                        title: Text(
                          AppLocalizations.of(context)!.visitSplitHawkWebsite,
                        ),
                        onTap: () async {
                          // Open website
                          // Use url_launcher or any other package to open the URL
                          // For example:
                          final Uri url = Uri(
                            scheme: 'https',
                            path: 'www.splithawk.com',
                          );
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text(AppLocalizations.of(context)!.email),
                        onTap: () async {
                          await launchUrlString(
                            'mailto:contact@splithawk.com?subject=App Contact',
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.feedback),
                        title: Text(AppLocalizations.of(context)!.sendFeedback),
                        onTap: () {
                          // Reset logic
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.star_rounded),
                  title: Text(AppLocalizations.of(context)!.rateUs),

                  onTap: () {
                    context.read<AuthBloc>().add(AuthSignOutEvent());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(AppLocalizations.of(context)!.signOut),

                  onTap: () {
                    context.read<AuthBloc>().add(AuthSignOutEvent());
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
