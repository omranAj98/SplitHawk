import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/core/enums/menus.dart';

class MenuCubit extends Cubit<Menus> {
  MenuCubit() : super(Menus.home);

  void updateMenu(Menus menu) {
    emit(menu);
  }
}
