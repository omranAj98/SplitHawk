import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      body: Center(
        child: Text(
          'Welcome to the Home Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
