import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/core/constants/app_size.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/names.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              context.pushNamed(AppRoutesName.addFriend);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: AppLocalizations.of(context)!.search,
              prefixIcon: Icon(Icons.search),
            ),
          ),
          // FriendsList(
          //   friendsList: context.read<FriendCubit>().state.friends,
          // ),
        ],
      ),
    );
  }
}
