import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/services/service_locator.dart';
import 'package:splithawk/src/views/add_expense_model.dart';
import 'package:splithawk/src/views/home_screen.dart';
import 'package:splithawk/src/views/account/profile_screen.dart';

enum Menus { home, group, add, activity, account }

List<Widget> pages = [
  HomeScreen(),
  HomeScreen(),
  AddExpenseModel(),
  HomeScreen(),
  BlocProvider<UserCubit>.value(
    value: locator<UserCubit>(),
    child: ProfileScreen(),
  ),
];
