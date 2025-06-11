import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/names.dart';
import 'package:splithawk/src/core/theme/shimmer/shimmer_box_decoration.dart';
import 'package:splithawk/src/core/widgets/app_safe_area.dart';
import 'package:splithawk/src/core/widgets/app_snack_bar.dart';
import 'package:splithawk/src/views/home/swipeable_friends_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _refreshUserData(BuildContext context) async {
    await context.read<UserCubit>().getSelfUser();
    final userRef = context.read<UserCubit>().state.user!.userRef;
    await context.read<FriendCubit>().getFriendsWithBalances(userRef!);
  }

  Widget _buildLoadingState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        TextField(
          enabled: false,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: AppLocalizations.of(context)!.search,
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 8,
            padding: const EdgeInsets.only(top: 16),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Shimmer.fromColors(
                  baseColor: colorScheme.onPrimary,
                  highlightColor: colorScheme.primary,
                  // highlightColor: colorScheme.primary.withAlpha(1),
                  child: Container(
                    height: 50,
                    // width: double.minPositive,
                    decoration: shimmerBoxDecoration(colorScheme),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, FriendState friendState) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          children: [
            Container(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.errorFetchingFriends,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      friendState.error!.message,

                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFriendListContent(
    BuildContext context,
    FriendState friendState,
  ) {
    return Column(
      children: [
        TextField(
          autocorrect: false,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: AppLocalizations.of(context)!.search,
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged:
              (value) => context.read<FriendCubit>().updateSearchText(value),
        ),
        // const SizedBox(height: 16),
        Expanded(
          child: SwipeableFriendsList(
            friendsList:
                (friendState.filteredFriends != null)
                    ? friendState.filteredFriends!
                    : friendState.friendsData,
          ),
        ),
      ],
    );
  }

  Widget _buildNoFriendsState(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          children: [
            Container(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.noFriendsFound,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.tryAddingSomeFriends,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person_add_alt_1),
                      label: Text(AppLocalizations.of(context)!.addFriend),
                      onPressed: () {
                        context.pushNamed(AppRoutesName.addFriend);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            context.read<AuthBloc>().add(AuthSignOutEvent());
            AppSnackBar.show(
              context,
              type: SnackBarType.success,
              message: AppLocalizations.of(context)!.home,
            );
          },
          child: Text(AppLocalizations.of(context)!.home),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              context.pushNamed(AppRoutesName.addFriend);
            },
          ),
        ],
      ),
      body: AppSafeArea(
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            if (userState.user == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.somethingWentWrong,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              return BlocBuilder<FriendCubit, FriendState>(
                builder: (context, friendState) {
                  Widget content;
                  if (friendState.requestStatus == RequestStatus.loading &&
                      friendState.actionType == FriendActionType.fetch) {
                    content = _buildLoadingState(context);
                  } else if (friendState.requestStatus == RequestStatus.error &&
                      friendState.actionType == FriendActionType.fetch) {
                    content = _buildErrorState(context, friendState);
                  } else if (friendState.friendsData.isNotEmpty) {
                    content = _buildFriendListContent(context, friendState);
                  } else {
                    content = _buildNoFriendsState(context);
                  }

                  return RefreshIndicator(
                    // elevation: 0,
                    displacement: 600,
                    onRefresh:
                        () => _refreshUserData(
                          context,
                        ), // Correctly pass the Future
                    child: content,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
