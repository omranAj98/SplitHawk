import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
            // Navigate to add expense page
            // context.pushNamed(
            //   AppRoutesName.addExpense,
            //   extra: {
            //     'friendId': friend.friendId,
            //     'friendName': friend.friendName,
            //   },
            // );
          },
          editCallback: () {
            // Handle edit action
            // Example: Show edit dialog or navigate to edit screen
          },
          onTap: () async {
            await context.read<ExpenseCubit>().fetchUserExpenses(
              friend.userRef,
            );

            context.pushNamed(
              AppRoutesName.friendExpenses,
              extra: {
                'friendName': friend.friendName,
                'friendId': friend.friendId,
                'friendUserRef': friend.userRef,
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
