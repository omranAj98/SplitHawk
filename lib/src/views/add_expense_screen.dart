import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/expense/expense_cubit.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/core/constants/app_icons.dart';
import 'package:splithawk/src/core/constants/app_size.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/routes.dart';
import 'package:splithawk/src/core/widgets/app_safe_area.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:splithawk/src/views/home/swipeable_friends_list.dart';
import 'package:splithawk/src/views/home/widgets/friends_item.dart';
import 'package:splithawk/src/views/selected_friends_list.dart';

class AddExpenseScreen extends StatelessWidget {
  final List<FriendDataModel> friendsList;
  const AddExpenseScreen({super.key, required this.friendsList});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(AppLocalizations.of(context)!.addExpense),
        actions: [
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.done,
              // style: const TextStyle(color: Colors.white),
            ),
            onPressed: null,
          ),
        ],
      ),
      body: AppSafeArea(
        child: Column(
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: [
                // Selected Friends (multiple rows as needed)
                SelectedFriendsList(
                  friendsList:
                      context.watch<FriendCubit>().state.selectedFriends ?? [],
                ),

                // TextField in remaining space
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 200,
                    maxWidth: double.maxFinite,
                  ),
                  child: TextField(
                    autofocus: true,
                    autocorrect: false,
                    textInputAction: TextInputAction.search,
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.search,
                    ),
                    onChanged:
                        (value) =>
                            context.read<FriendCubit>().updateSearchText(value),
                  ),
                ),
              ],
            ),

            // const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<FriendCubit, FriendState>(
                builder: (context, friendState) {
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: friendsList.length,
                    itemBuilder: (context, index) {
                      final friend = friendsList[index];
                      return GestureDetector(
                        onTap: () {
                          context.read<FriendCubit>().selectFriendToExpense(
                            friend,
                          );
                          debugPrint('Selected Friend: ${friend.friendName} ');
                        },
                        child: FriendItem(friend: friend),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
