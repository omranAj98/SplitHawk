import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splithawk/src/models/friend_model.dart';

class FriendRepository {
  final FirebaseFirestore firebaseFirestore;

  FriendRepository({required this.firebaseFirestore});

  Future<void> addFriend(FriendModel friend, FriendModel user) async {
    await firebaseFirestore
        .collection('users')
        .doc(user.id)
        .collection('friends')
        .doc(friend.id)
        .set(friend.toMap());
    await firebaseFirestore
        .collection('users')
        .doc(friend.id)
        .collection('friends')
        .doc(user.id)
        .set(user.toMap());

    debugPrint('Friend added successfully');
  }

  Future<bool> isFriend(String userId, String friendId) async {
    final snapshot =
        await firebaseFirestore
            .collection('users')
            .doc(userId)
            .collection('friends')
            .doc(friendId)
            .get();

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
