import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/models/friend_data_model.dart';

class SelectedFriendsList extends StatelessWidget {
  final List<FriendDataModel> friendsList;
  const SelectedFriendsList({super.key, required this.friendsList});

  @override
  Widget build(BuildContext context) {
    return friendsList.isEmpty
        ? const SizedBox.shrink()
        : _buildFriendsList(context);
  }

  Widget _buildFriendsList(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: friendsList.length,
        itemBuilder: (context, index) {
          final friend = friendsList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Make container fit the content
                children: [
                  Text(
                    friend.friendName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.close),
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      iconSize: 16.0,
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    onPressed:
                        () => context.read<FriendCubit>().selectFriendToExpense(
                          friend,
                        ),
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
