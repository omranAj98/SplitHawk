import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:splithawk/src/models/friend_model.dart';
import 'package:splithawk/src/models/user_model.dart';
import 'package:splithawk/src/repositories/balance_repository.dart';

class FriendRepository {
  final FirebaseFirestore firebaseFirestore;
  final BalanceRepository balanceRepository;

  FriendRepository({
    required this.firebaseFirestore,
    required this.balanceRepository,
  });

  Future<void> addFriend(FriendModel friend, FriendModel user) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.friendId)
          .collection('friends')
          .doc(friend.friendId)
          .set(friend.toFirestoreMap());
      await firebaseFirestore
          .collection('users')
          .doc(friend.friendId)
          .collection('friends')
          .doc(user.friendId)
          .set(user.toFirestoreMap());

      debugPrint('Friend added successfully');
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message ?? 'Error adding friend',
        code: e.code,
        plugin: e.plugin,
      );
    } on Exception catch (e) {
      throw CustomError(
        message: 'Error adding friend: $e',
        code: 'addFriend',
        plugin: 'friend_repository',
      );
    }
  }

  Future<List<FriendModel>?> getFriendsWithBalances(DocumentReference userRef) async {
    try {
      final snapshot = await userRef.collection('friends').get();

      final friendsListFutures = snapshot.docs.map((doc) async {
        final friendBalances = await balanceRepository.getFriendBalances(
          userRef,
          doc.reference,
        );
        return FriendModel.fromFriendDocAndBalanceModel(doc, friendBalances!);
      });

      final friendsList = await Future.wait(friendsListFutures);
      return friendsList;
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message ?? 'Error fetching friends',
        code: e.code,
        plugin: e.plugin,
      );
    } on Exception catch (e) {
      throw CustomError(
        message: 'Error fetching friends: $e',
        code: 'getFriends',
        plugin: 'friend_repository',
      );
    }
  }

  Future<List<FriendDataModel>?> getFriendsData(
    List<FriendModel> friendsModels,
  ) async {
    if (friendsModels.isEmpty) {
      debugPrint('No friends to fetch data for');
      return null;
    }

    List<FriendDataModel> friendDataList = [];

    final List<String> friendIds =
        friendsModels.map((friend) => friend.friendId).toList();

    try {
      final userSnapshot =
          await firebaseFirestore
              .collection('users')
              .where(FieldPath.documentId, whereIn: friendIds)
              .get();

      await Future.delayed(Duration(seconds: 3));

      // Create a map of userModels for quick lookup
      final Map<String, UserModel> userModelsMap = {};
      for (var userDoc in userSnapshot.docs) {
        userModelsMap[userDoc.id] = UserModel.fromUserDocAndBalanceModel(
          userDoc: userDoc,
        );
      }

      // Create FriendDataModel for each friend
      for (var friendModel in friendsModels) {
        final userModel = userModelsMap[friendModel.friendId];
        if (userModel != null) {
          friendDataList.add(
            FriendDataModel.fromModels(
              friendModel: friendModel,
              userModel: userModel,
            ),
          );
        }
      }

      if (friendDataList.isNotEmpty) {
        debugPrint(
          'Friend data retrieved successfully: ${friendDataList.length} friends',
        );
        return friendDataList;
      } else {
        debugPrint('No friend data found');
        return null;
      }
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message ?? 'Error fetching friend data',
        code: e.code,
        plugin: e.plugin,
      );
    } on Exception catch (e) {
      throw CustomError(
        message: 'Error fetching friend data: $e',
        code: 'friend_repository_exception',
        plugin: 'getFriendData',
      );
    }
  }

  Future<bool> isFriend(DocumentReference userRef, String friendId) async {
    final snapshot = await userRef.collection('friends').doc(friendId).get();

    return snapshot.exists;
  }

  Future<void> removeFriend(String userId, String friendId) async {
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .delete();
    await firebaseFirestore
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(userId)
        .delete();

    debugPrint('Friend removed successfully');
  }

  Future<void> blockFriend(String userId, String friendId) async {
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .update({'isBlocked': true});
    await firebaseFirestore
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(userId)
        .update({'isBlocked': true});

    debugPrint('Friend blocked successfully');
  }
}
