import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/services/service_locator.dart';
import 'package:splithawk/src/pages/add_expense_model.dart';
import 'package:splithawk/src/pages/home_screen.dart';
import 'package:splithawk/src/pages/account/profile_screen.dart';
import 'package:splithawk/src/repositories/user_repository.dart';

enum Menus { home, group, add, activity, account }

List<Widget> pages = [
  HomeScreen(),
  HomeScreen(),
  AddExpenseModel(),
  HomeScreen(),
  BlocProvider<UserCubit>(
    create: (context) => UserCubit(userRepository: locator<UserRepository>()),
    child: ProfileScreen(),
  ),
];
