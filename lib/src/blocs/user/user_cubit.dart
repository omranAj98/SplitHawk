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
  UserCubit({required this.userRepository}) : super(UserState.initial());

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
          error: CustomError(message: e.toString()),
        ),
      );
    }
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) {
    try {
      // Decrypt the encrypted data
      final encryptedData = json['data'] as String;
      final encryptedObject = Encrypted.fromBase64(
        encryptedData,
      ); // Convert to Encrypted object
      final decrypted = EncryptionSetup.encrypter.decrypt(
        encryptedObject,
        iv: EncryptionSetup.iv,
      );

      // Decode the decrypted JSON string
      final decoded = jsonDecode(decrypted);

      // Restore the state
      final state = UserState(
        user:
            decoded['user'] != null ? UserModel.fromMap(decoded['user']) : null,
        requestStatus: RequestStatus.values[decoded['requestStatus'] as int],
        error: null, // Handle error if needed
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
      // Serialize the state to JSON
      final json = {
        'user': state.user?.toMap(),
        'requestStatus': state.requestStatus.index,
      };

      // Encrypt the serialized JSON string
      final encrypted = EncryptionSetup.encrypter.encrypt(
        jsonEncode(json),
        iv: EncryptionSetup.iv,
      );

      // Return the encrypted data
      return {'data': encrypted.base64};
    } catch (e) {
      debugPrint('Error in toJson in user_cubit: $e');
      return null;
    }
  }

  // void getUser(String userId) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   try {
  //     final user = await userRepository.getUser(userId);
  //     emit(state.copyWith(user: user, requestStatus: RequestStatus.success));
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.error,
  //         error: CustomError(message: e.toString()),
  //       ),
  //     );
  //   }
  // }

  // void updateUser(UserModel user) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   try {
  //     final updatedUser = await userRepository.updateUser(user);
  //     emit(
  //       state.copyWith(user: updatedUser, requestStatus: RequestStatus.success),
  //     );
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.error,
  //         error: CustomError(message: e.toString()),
  //       ),
  //     );
  //   }
  // }

  // void deleteUser(String userId) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   try {
  //     await userRepository.deleteUser(userId);
  //     emit(state.copyWith(user: null, requestStatus: RequestStatus.success));
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.error,
  //         error: CustomError(message: e.toString()),
  //       ),
  //     );
  //   }
  // }
}
