import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:splithawk/src/core/enums/request_status.dart';

import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:splithawk/src/models/friend_model.dart';
import 'package:splithawk/src/models/user_model.dart';
import 'package:splithawk/src/repositories/balance_repository.dart';
import 'package:splithawk/src/repositories/friend_repository.dart';
import 'package:splithawk/src/repositories/user_repository.dart';

part 'friend_state.dart';

class FriendCubit extends Cubit<FriendState> {
  final FriendRepository friendRepository;
  final UserRepository userRepository;
  final BalanceRepository balanceRepository;
  final StreamController<String> _searchController =
      StreamController<String>.broadcast();

  FriendCubit({
    required this.friendRepository,
    required this.userRepository,
    required this.balanceRepository,
  }) : super(FriendState.initial()) {
    // Listen to search text changes
    _searchController.stream.listen((searchText) {
      searchContacts(searchText);
    });
  }

  @override
  Future<void> close() {
    _searchController.close();
    return super.close();
  }

  void clearSelectedFriends() async {
    try {
      emit(state.copyWith(selectedFriends: []));
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          actionType: FriendActionType.fetch,
          error: e,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          actionType: FriendActionType.fetch,
          error: CustomError(
            message: e.toString(),
            code: "unknown",
            plugin: "friend_cubit",
          ),
        ),
      );
    }
  }

  Future<void> selectFriendToExpense(FriendDataModel friendData) async {
    try {
      if (state.selectedFriends != null &&
          state.selectedFriends!.contains(friendData)) {
        final updatedList = List<FriendDataModel>.from(state.selectedFriends!)
          ..remove(friendData);
        emit(state.copyWith(selectedFriends: updatedList));

        return;
      }
      emit(
        state.copyWith(
          selectedFriends:
              state.selectedFriends != null
                  ? [...state.selectedFriends!, friendData]
                  : [friendData],
        ),
      );
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          actionType: FriendActionType.fetch,
          error: e,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          actionType: FriendActionType.fetch,
          error: CustomError(
            message: e.toString(),
            code: "unknown",
            plugin: "friend_cubit",
          ),
        ),
      );
    }
  }

  Future<void> addFriend({
    required String email,
    required String name,
    required UserModel selfUserModel,
  }) async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.loading,
        actionType: FriendActionType.add,
      ),
    );
    try {
      UserModel? friendUserModel = await userRepository.checkExistingUser(
        email,
      );
      if (friendUserModel != null) {
        bool isFriend = await friendRepository.isFriend(
          selfUserModel.userRef,
          friendUserModel.id,
        );
        debugPrint("isFriend: $isFriend");
        if (isFriend) {
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              actionType: FriendActionType.add,
              error: CustomError(
                message: "addFriend method error",
                code: "already_friends",
                plugin: "friend_cubit",
              ),
            ),
          );
          return;
        }
      }

      FriendModel selfFriendModel = FriendModel(
        friendId: selfUserModel.id,
        userRef: selfUserModel.userRef,
        nickname: selfUserModel.fullName,
        isFavorite: false,
        isBlocked: false,
      );
      FriendModel friend = FriendModel(
        nickname: name,
        userRef: FirebaseFirestore.instance.doc('users/${selfUserModel.id}'),
      );

      if (friendUserModel == null) {
        // FriendModel friend = FriendModel(nickname: name);
        UserModel newUserModel = UserModel(
          id: friend.friendId,
          userRef: friend.userRef,
          email: email,
          fullName: name,
          createdAt: DateTime.now(),
        );
        await userRepository.createUser(newUserModel);
        QueryDocumentSnapshot? newUserDoc = await userRepository.getUserDoc(
          email,
        );
        friendUserModel = UserModel.fromUserDocAndBalanceModel(
          userDoc: newUserDoc!,
        );

        friend = friend.copyWith(userRef: newUserDoc.reference);
        await friendRepository.addFriend(friend, selfFriendModel);
      } else {
        friend = friend.copyWith(
          friendId: friendUserModel.id,
          userRef: friendUserModel.userRef,
        );

        // friend = friend.copyWith(
        //   friendId: friendUserModel.id,
        //   userRef: friendUserModel.userRef,
        // );
        await friendRepository.addFriend(friend, selfFriendModel);
      }

      final newFriendData = FriendDataModel.fromModels(
        friendModel: friend,
        userModel: friendUserModel,
      );

      emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          actionType: FriendActionType.add,
          error: null,
          friends: state.friends + [friend],
          friendsData: state.friendsData + [newFriendData],
        ),
      );
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          actionType: FriendActionType.add,
          error: e,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          actionType: FriendActionType.add,
          error: CustomError(
            message: e.toString(),
            code: "unknown",
            plugin: "friend_cubit",
          ),
        ),
      );
    }
  }

  Future<void> getFriendsWithBalances(DocumentReference userRef) async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.loading,
        actionType: FriendActionType.fetch,
      ),
    );
    try {
      List<FriendModel>? friends = await friendRepository
          .getFriendsWithBalances(userRef);

      if (friends!.isEmpty) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            actionType: FriendActionType.fetch,
            friends: [],
            friendsData: [],
          ),
        );
        return;
      }

      final friendsData = await friendRepository.getFriendsData(friends);

      if (friendsData == null || friendsData.isEmpty) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            actionType: FriendActionType.fetch,
            friends: friends,
            friendsData: [],
          ),
        );
        return;
      }
      for (var friend in friendsData) {
        friendsData[friendsData.indexOf(friend)] = friend.copyWith();
      }

      emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          actionType: FriendActionType.fetch,
          error: null,
          friends: friends,
          friendsData: friendsData,
        ),
      );
      debugPrint("Friends loaded successfully");
      debugPrint("Friends: ${friends.length}");
      debugPrint("FriendsData: ${friendsData.length}");
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          actionType: FriendActionType.fetch,
          error: e,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          actionType: FriendActionType.fetch,
          error: CustomError(
            message: e.toString(),
            code: "unknown",
            plugin: "friend_cubit",
          ),
        ),
      );
    }
  }

  void updateSearchText(String searchText) {
    _searchController.add(searchText);
  }

  void searchContacts(String name) {
    List<FriendDataModel> filteredFriends = [];
    if (name.isNotEmpty) {
      filteredFriends =
          state.friendsData
              .where(
                (friend) => friend.friendName.toLowerCase().contains(
                  name.toLowerCase(),
                ),
              )
              .toList();
    } else {
      filteredFriends = state.friendsData;
    }
    debugPrint("Filtered friends: ${filteredFriends.length}");
    emit(state.copyWith(filteredFriends: filteredFriends));
  }

  void resetSelectedFriends() {
    emit(state.copyWith(selectedFriends: []));
  }

  //  void updateBalances(String userId, List<FriendDataModel> friendsData) async {
  //   emit(
  //     state.copyWith(
  //       requestStatus: RequestStatus.loading,
  //       actionType: FriendActionType.update,
  //     ),
  //   );
  //   try {
  //     // List<FriendDataModel> updatedFriendsData =
  //     // await balanceRepository.updateBalanceBetwseenFriend(userId, friendsData);
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         actionType: FriendActionType.update,
  //         // friendsData: updatedFriendsData,
  //       ),
  //     );
  //   } on CustomError catch (e) {
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.error,
  //         actionType: FriendActionType.update,
  //         error: e,
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     emit(
  //       state.copyWith(
  //         requestStatus: RequestStatus.error,
  //         actionType: FriendActionType.update,
  //         error: CustomError(
  //           message: e.toString(),
  //           code: "unknown",
  //           plugin: "friend_cubit",
  //         ),
  //       ),
  //     );
  //   }
  // }

  /// Add a friend from a user reference
  /// This is used when a participant in an expense is not in the friends list
}
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

