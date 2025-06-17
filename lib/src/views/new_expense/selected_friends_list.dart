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
    return Container(
      child: Wrap(
        spacing: 8.0, // horizontal spacing
        runSpacing: 8.0, // vertical spacing between rows
        alignment: WrapAlignment.start,
        children:
            friendsList.map((friend) {
              return Container(
                padding: const EdgeInsets.only(left: 8.0, right: 4.0, top: 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 5.0,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(30),
                      radius: 12,
                      child: Icon(
                        Icons.person,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      friend.friendName,
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap:
                            () => context
                                .read<FriendCubit>()
                                .selectFriendToExpense(friend),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.close_rounded,
                            size: 16.0,
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
