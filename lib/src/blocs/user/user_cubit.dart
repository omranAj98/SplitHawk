import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/user_model/user_model.dart';
import 'package:splithawk/src/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserRepository userRepository;
  UserCubit({required this.userRepository}) : super(UserState.initial());

  void createUser(UserModel user) async {
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
