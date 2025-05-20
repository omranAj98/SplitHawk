import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/blocs/contact/contact_cubit.dart';
import 'package:splithawk/src/core/constants/app_icons.dart';
import 'package:splithawk/src/models/user_model.dart';

class FriendsList extends StatelessWidget {
  final List<UserModel> friendsList;
  const FriendsList({super.key, required this.friendsList});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      builder: (context, state) {
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: friendsList.length,
          itemBuilder: (context, index) {
            final friend = friendsList[index];
            return ListTile(
              title: Text(friend.fullName.toString()),
              subtitle: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(friend.fullName)],
                  ),
                ],
              ),
              trailing: GestureDetector(
                onTap: () {
                  // context.read<ContactCubit>().selectContact(friend);
                },
                child:
                    state.selectedContacts.contains(friend)
                        ? Icon(Icons.circle)
                        : Icon(Icons.circle_outlined),
              ),
              leading: CircleAvatar(child: Icon(AppIcons.contactIcon)),
            );
          },
        );
      },
    );
  }
}
