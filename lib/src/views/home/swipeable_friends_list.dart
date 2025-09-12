import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/cubit/menu_cubit.dart';
import 'package:splithawk/src/core/enums/menus.dart';
import 'package:splithawk/src/core/routes/names.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:splithawk/src/blocs/expense/expense_cubit.dart';
import 'package:splithawk/src/views/home/widgets/friends_item.dart';
import 'package:splithawk/src/views/home/widgets/swipeable_card.dart';

class SwipeableFriendsList extends StatelessWidget {
  final List<FriendDataModel> friendsList;

  const SwipeableFriendsList({super.key, required this.friendsList});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: friendsList.length,
      itemBuilder: (context, index) {
        final friend = friendsList[index];
        return SwipeableCard(
          addExpenseCallback: () {
            context.read<MenuCubit>().updateMenu(Menus.add);
            context.read<FriendCubit>().selectFriendToExpense(friend);
          },
          editCallback: () {
            // Handle edit action
            // Example: Show edit dialog or navigate to edit screen
          },
          onTap: () {
            context.read<ExpenseCubit>().fetchUserExpenses(
              friend.userRef,
              friendsList,
            );
            context.pushNamed(
              AppRoutesName.friendExpenses,
              extra: {
                'friend': friend,
                'selfUserRef': context.read<UserCubit>().state.user!.userRef,
              },
            );
          },
          colorScheme: colorScheme,
          child: FriendItem(friend: friend),
        );
      },
    );
  }
}
