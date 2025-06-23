import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/expense/expense_cubit.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/core/constants/app_icons.dart';
import 'package:splithawk/src/core/constants/app_size.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/widgets/app_safe_area.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:splithawk/src/views/new_expense/expense_details.dart';
import 'package:splithawk/src/views/home/widgets/friends_item.dart';
import 'package:splithawk/src/views/new_expense/selected_friends_list.dart';

class AddExpenseScreen extends StatefulWidget {
  final List<FriendDataModel> friendsList;
  const AddExpenseScreen({super.key, required this.friendsList});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final FocusNode searchFocusNode = FocusNode(debugLabel: 'searchFocusNode');

  // Add this flag to control list visibility
  bool _showFriendsList = true;

  @override
  void initState() {
    super.initState();
    // searchFocusNode.addListener(_handleFocusChange);
  }

  // void _handleFocusChange() {
  //   if (mounted && searchFocusNode.hasFocus) {
  //     setState(() {
  //       _showFriendsList = searchFocusNode.hasFocus;
  //     });
  //   }
  // }

  @override
  void dispose() {
    // searchFocusNode.removeListener(_handleFocusChange);
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          _showFriendsList
              ? TextButton(
                onPressed: () {
                  // When done is pressed, hide the list and focus out
                  setState(() {
                    _showFriendsList = false;
                  });
                  FocusScope.of(context).unfocus();
                },
                child: Text(AppLocalizations.of(context)!.next),
              )
              : TextButton(
                onPressed: null,
                child: Text(
                  AppLocalizations.of(context)!.done,
                  // style: const TextStyle(color: Colors.white),
                ),
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
                  child: Focus(
                    focusNode: searchFocusNode,
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _showFriendsList = hasFocus;
                      });
                    },
                    // key: Key('searchFieldFocus'),
                    child: TextField(
                      autofocus: true,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      // focusNode: searchFocusNode,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.search,
                      ),
                      onChanged:
                          (value) => context
                              .read<FriendCubit>()
                              .updateSearchText(value),
                    ),
                  ),
                ),
              ],
            ),

            // const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<FriendCubit, FriendState>(
                builder: (context, friendState) {
                  return friendState.selectedFriends!.isEmpty ||
                          _showFriendsList
                      ? ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            friendState.filteredFriends != null
                                ? friendState.filteredFriends!.length
                                : widget.friendsList.length,
                        itemBuilder: (context, index) {
                          final friend =
                              friendState.filteredFriends != null
                                  ? friendState.filteredFriends![index]
                                  : widget.friendsList[index];
                          return GestureDetector(
                            onTap: () {
                              // Set flag to keep showing list temporarily
                              setState(() {
                                _showFriendsList = true;
                              });
                              context.read<FriendCubit>().selectFriendToExpense(
                                friend,
                              );
                              debugPrint(
                                'Selected Friend: ${friend.friendName}',
                              );

                              // Refocus the search field after a short delay
                              Future.delayed(Duration(milliseconds: 100), () {
                                if (mounted) {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(searchFocusNode);
                                }
                              });
                            },
                            child: FriendItem(friend: friend),
                          );
                        },
                      )
                      : ExpenseDetails();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
