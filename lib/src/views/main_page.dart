import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/core/cubit/menu_cubit.dart';
import 'package:splithawk/src/core/enums/menus.dart';
import 'package:splithawk/src/core/widgets/nav_bar/wd_bottom_navigation_bar.dart';
import 'package:splithawk/src/views/add_expense_model.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuCubit, Menus>(
      listener: (context, currentMenu) {
        if (currentMenu == Menus.add) {
          // Show the modal bottom sheet when Menus.add is selected
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return const AddExpenseModel();
            },
          );
        }
      },
      builder: (context, currentMenu) {
        return Scaffold(
          extendBody: true,
          body: Builder(
            builder: (context) {
              switch (currentMenu) {
                case Menus.home:
                case Menus.account:
                case Menus.activity:
                case Menus.group:
                  return pages[currentMenu.index];
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
}
