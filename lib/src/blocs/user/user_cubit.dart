import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/user_model.dart';
import 'package:splithawk/src/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserRepository userRepository;

  UserCubit({required this.userRepository}) : super(UserState.initial()) {
    if (state.user == null) {
      getSelfUser();
    }
  }

  Future createUser(UserModel user) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      await userRepository.createUser(user);
      emit(state.copyWith(user: user, requestStatus: RequestStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          error: CustomError(message: e.toString()),
        ),
      );
    }
  }

  Future getSelfUser() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      final userModel = await userRepository.getSelfUser();
      print(userModel);
      emit(
        state.copyWith(user: userModel, requestStatus: RequestStatus.success),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(requestStatus: RequestStatus.error, error: e));
    } on Error catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          error: CustomError(
            message: e.toString(),
            code: "unknown",
            plugin: 'user_cubit',
          ),
        ),
      );
    }
  }

  DateTime? _resetPasswordTimeoutEnd;

  void startResetPasswordTimer() {
    if (state.timer != null) {
      state.timer!.cancel();
    }

    _resetPasswordTimeoutEnd = DateTime.now().add(const Duration(minutes: 2));

    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(_resetPasswordTimeoutEnd!)) {
        timer.cancel();
        emit(state.copyWith(timer: null));
      } else {
        emit(state.copyWith(timer: timer));
      }
    });

    emit(state.copyWith(timer: timer));
  }

  int? getRemainingResetPasswordTime() {
    if (_resetPasswordTimeoutEnd == null) return null;

    final now = DateTime.now();
    if (now.isAfter(_resetPasswordTimeoutEnd!)) return null;

    return _resetPasswordTimeoutEnd!.difference(now).inSeconds;
  }

  bool get canResetPassword => getRemainingResetPasswordTime() == null;

  @override
  Future<void> close() {
    if (state.timer != null) {
      state.timer!.cancel();
    }
    return super.close();
  }

}
