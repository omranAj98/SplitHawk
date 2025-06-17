import 'package:flutter/material.dart';

import 'package:splithawk/src/views/home/home_screen.dart';
import 'package:splithawk/src/views/account/account_screen.dart';

enum Menus { home, group, add, activity, account }

List<Widget> pages = [
  HomeScreen(),
  HomeScreen(),
  HomeScreen(),
  HomeScreen(),
  AccountScreen(),
];
