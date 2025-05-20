import 'dart:async';
import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/user_model.dart';
import 'package:splithawk/src/repositories/user_repository.dart';
import 'package:splithawk/src/core/config/encryption_setup.dart';

part 'user_state.dart';

class UserCubit extends HydratedCubit<UserState> {
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

  @override
  UserState? fromJson(Map<String, dynamic> json) {
    try {
      final encryptedData = json['data'] as String;
      final encryptedObject = Encrypted.fromBase64(encryptedData);
      final decrypted = EncryptionSetup.encrypter.decrypt(
        encryptedObject,
        iv: EncryptionSetup.iv,
      );

      final decoded = jsonDecode(decrypted);

      Timer? timer;
      if (decoded['resetPasswordTimeoutEnd'] != null) {
        _resetPasswordTimeoutEnd = DateTime.parse(
          decoded['resetPasswordTimeoutEnd'],
        );
        final remaining = _resetPasswordTimeoutEnd!.difference(DateTime.now());

        if (remaining.inSeconds > 0) {
          timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            final now = DateTime.now();
            if (now.isAfter(_resetPasswordTimeoutEnd!)) {
              timer.cancel();
            }
          });
        } else {
          _resetPasswordTimeoutEnd = null;
        }
      }

      final state = UserState(
        user:
            decoded['user'] != null ? UserModel.fromMap(decoded['user']) : null,
        requestStatus: RequestStatus.values[decoded['requestStatus'] as int],
        error: null,
        timer: timer,
      );

      debugPrint('Restored State from user_cubit: $state');
      return state;
    } catch (e) {
      debugPrint('Error in fromJson in user_cubit: $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    try {
      final json = {
        'user': state.user?.toMap(),
        'requestStatus': state.requestStatus.index,
        'resetPasswordTimeoutEnd': _resetPasswordTimeoutEnd?.toIso8601String(),
      };

      final encrypted = EncryptionSetup.encrypter.encrypt(
        jsonEncode(json),
        iv: EncryptionSetup.iv,
      );

      return {'data': encrypted.base64};
    } catch (e) {
      debugPrint('Error in toJson in user_cubit: $e');
      return null;
    }
  }
}
