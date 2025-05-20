// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/friend_model.dart';
import 'package:splithawk/src/models/user_model.dart';
import 'package:splithawk/src/repositories/friend_repository.dart';
import 'package:splithawk/src/repositories/user_repository.dart';

part 'friend_state.dart';

class FriendCubit extends Cubit<FriendState> {
  final FriendRepository friendRepository;
  final UserRepository userRepository;
  FriendCubit({required this.friendRepository, required this.userRepository})
    : super(FriendState.initial()) {
    // getFriends();
  }

  void addFriend({
    required String email,
    required String name,
    required UserModel selfUserModel,
  }) async {
    emit(state.copyWith(requestStatus: FriendRequestStatus.loading));
    try {
      UserModel? friendUserModel = await userRepository.checkExistingUser(
        email,
      );

      FriendModel selfFriendModel = FriendModel(
        id: selfUserModel.id,
        userRef: selfUserModel.userRef,
        status: 'pending',
        friendedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isFavorite: false,
        isBlocked: false,
      );

      if (friendUserModel == null) {
        FriendModel friend = FriendModel(
          status: 'pending',
          friendedAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isFavorite: false,
          isBlocked: false,
        );

        UserModel newUserModel = UserModel(
          id: friend.id,
          email: email,
          fullName: name,
          createdAt: DateTime.now(),
        );
        await userRepository.createUser(newUserModel);
        QueryDocumentSnapshot? newUserDoc = await userRepository.getUserDoc(
          email,
        );

        friend = friend.copyWith(userRef: newUserDoc!.reference);
        await friendRepository.addFriend(friend, selfFriendModel);
      } else {
        FriendModel friend = FriendModel(
          id: friendUserModel.id,
          userRef: friendUserModel.userRef,
          status: 'pending',
          friendedAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isFavorite: false,
          isBlocked: false,
        );
        bool isFriend = await friendRepository.isFriend(
          selfUserModel.id,
          friend.id,
        );
        debugPrint("isFriend: $isFriend");
        if (isFriend) {
          emit(
            state.copyWith(
              requestStatus: FriendRequestStatus.error,
              error: CustomError(
                message: "Already friends",
                code: "already_friends",
                plugin: "friend_cubit",
              ),
            ),
          );
          return;
        } else {
          friend = friend.copyWith(
            id: friendUserModel.id,
            userRef: friendUserModel.userRef,
          );
          await friendRepository.addFriend(friend, selfFriendModel);
        }
      }


      emit(
        state.copyWith(
          requestStatus: FriendRequestStatus.addingSuccess,
          
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(requestStatus: FriendRequestStatus.error, error: e));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          requestStatus: FriendRequestStatus.error,
          error: CustomError(
            message: e.toString(),
            code: "unknown",
            plugin: "friend_cubit",
          ),
        ),
      );
    }
  }

  // void getFriends() async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   try {
  //     List<FriendModel> friends = await friendRepository.getFriends();
  //     emit(
  //       state.copyWith(requestStatus: RequestStatus.success, friends: friends),
  //     );
  //   } on CustomError catch (e) {
  //     emit(state.copyWith(requestStatus: RequestStatus.error, error: e));
  //   } on Exception catch (e) {
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.error,
  //         error: CustomError(
  //           message: e.toString(),
  //           code: "unknown",
  //           plugin: "friend_cubit",
  //         ),
  //       ),
  //     );
  //   }
  // }

  // void removeFriend(FriendModel friend) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   try {
  //     await friendRepository.removeFriend(friend);
  //     List<FriendModel> updatedFriends = List.from(state.friends);
  //     updatedFriends.remove(friend);
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         friends: updatedFriends,
  //       ),
  //     );
  //   } on CustomError catch (e) {
  //     emit(state.copyWith(requestStatus: RequestStatus.error, error: e));
  //   } on Exception catch (e) {
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.error,
  //         error: CustomError(
  //           message: e.toString(),
  //           code: "unknown",
  //           plugin: "friend_cubit",
  //         ),
  //       ),
  //     );
  //   }
  // }

  // void blockFriend(FriendModel friend) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   try {
  //     await friendRepository.blockFriend(friend);
  //     List<FriendModel> updatedFriends = List.from(state.friends);
  //     updatedFriends.remove(friend);
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         friends: updatedFriends,
  //       ),
  //     );
  //   } on CustomError catch (e) {
  //     emit(state.copyWith(requestStatus: RequestStatus.error, error: e));
  //   } on Exception catch (e) {
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.error,
  //         error: CustomError(
  //           message: e.toString(),
  //           code: "unknown",
  //           plugin: "friend_cubit",
  //         ),
  //       ),
  //     );
  //   }
  // }

  // void unblockFriend(FriendModel friend) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   try {
  //     await friendRepository.unblockFriend(friend);
  //     List<FriendModel> updatedFriends = List.from(state.friends);
  //     updatedFriends.remove(friend);
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         friends: updatedFriends,
  //       ),
  //     );
  //   } on CustomError catch (e) {
  //     emit(state.copyWith(requestStatus: RequestStatus.error, error: e));
  //   } on Exception catch (e) {
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.error,
  //         error: CustomError(
  //           message: e.toString(),
  //           code: "unknown",
  //           plugin: "friend_cubit",
  //         ),
  //       ),
  //     );
  //   }
  // }
}
