import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalObserver extends BlocObserver {
  // @override
  // void onChange(BlocBase bloc, Change change) {
  //   // This logs all Cubit and Bloc changes
  //   debugPrint('${bloc.runtimeType} state changed: $change');
  //   super.onChange(bloc, change);
  // }

  @override
  void onCreate(BlocBase bloc) {
    // This logs all Cubit and Bloc creations
    debugPrint('${bloc.runtimeType} created');
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    // This logs all Cubit and Bloc closures
    debugPrint('${bloc.runtimeType} closed');
    super.onClose(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // This logs all Cubit and Bloc errors
    debugPrint('${bloc.runtimeType} error: $error');
    super.onError(bloc, error, stackTrace);
  }
}
