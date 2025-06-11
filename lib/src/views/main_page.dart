import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/core/cubit/menu_cubit.dart';
import 'package:splithawk/src/core/enums/menus.dart';
import 'package:splithawk/src/core/routes/names.dart';
import 'package:splithawk/src/core/widgets/nav_bar/wd_bottom_navigation_bar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    Menus previousMenu = Menus.home;

    return BlocConsumer<MenuCubit, Menus>(
      listener: (context, currentMenu) {
        if (currentMenu == Menus.add) {
          _showAddExpenseScreen(context, previousMenu);
        } else {
          previousMenu = currentMenu;
        }
      },
      builder: (context, currentMenu) {
        final displayMenu =
            currentMenu == Menus.add ? previousMenu : currentMenu;

        return Scaffold(
          extendBody: true,
          body: Builder(
            builder: (context) {
              switch (displayMenu) {
                case Menus.home:
                case Menus.account:
                case Menus.activity:
                case Menus.group:
                  return pages[displayMenu.index];
                default:
                  return const Center(child: Text('Error!'));
              }
            },
          ),
          bottomNavigationBar: WdBottomNavigationBar(
            currentIndex: currentMenu,
            onTap: (value) => context.read<MenuCubit>().updateMenu(value),
          ),
        );
      },
    );
  }

  void _showAddExpenseScreen(BuildContext context, Menus previousMenu) {
    context
        .pushNamed(
          AppRoutesName.addExpense,
          extra: {'friendsList': context.read<FriendCubit>().state.friendsData},
        )
        .then((_) {
          context.read<MenuCubit>().updateMenu(previousMenu);
        });
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   builder: (context) {
    //     return  AddExpenseModel();
    //   },
    // ).then((_) {
    //   context.read<MenuCubit>().updateMenu(previousMenu);
    // });
  }
}
