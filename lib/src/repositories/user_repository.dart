import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore firebaseFirestore;

  UserRepository({required this.firebaseFirestore});

  Future<void> createUser(UserModel userModel) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'createUser',
      );
      await callable.call(userModel.toMapFirestore());
      debugPrint('User created successfully via Cloud Function');
    } catch (e) {
      throw CustomError(
        message: e.toString(),
        code: 'cloud_function_error',
        plugin: 'createUser',
      );
    }
  }

  Future<QueryDocumentSnapshot?> getUserDoc(String email) async {
    try {
      final snapshot =
          await firebaseFirestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        debugPrint('user already exist');
        final existingDoc = snapshot.docs.first;
        return existingDoc;
      } else {
        debugPrint('User not found');
        return null;
      }
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred during checking user',
        code: e.code,
        plugin: e.plugin,
      );
    }
  }

  Future<void> verifyEmail(String email) async {
    try {
      final userSnapShot =
          await firebaseFirestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (userSnapShot.docs.isNotEmpty) {
        final userModel = UserModel.fromDocumentSnapshot(
          userSnapShot.docs.first,
        );
        if (userModel.isEmailVerified == false) {
          await firebaseFirestore.collection('users').doc(userModel.id).update({
            'isEmailVerified': true,
            'updatedAt': DateTime.now(),
          });
          debugPrint('${userModel.email} verified successfully');
        } else {
          debugPrint('${userModel.email} already exist and verified');
          return;
        }
      } else {
        throw CustomError(
          message: 'User not found',
          code: 'user_not_found',
          plugin: 'firebase_firestore',
        );
      }
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred during verifying email',
        code: e.code,
        plugin: e.plugin,
      );
    }
  }

  Future<UserModel?> checkExistingUser(String email) async {
    try {
      final snapshot =
          await firebaseFirestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        debugPrint('user already exist');
        return UserModel.fromDocumentSnapshot(snapshot.docs.first);
      } else {
        debugPrint('User not found');
        return null;
      }
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred during checking user',
        code: e.code,
        plugin: e.plugin,
      );
    }
  }

  Future<void> updateUser({
    required UserModel userModel,
    required UserModel updatedUserModel,
  }) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(userModel.id)
          .update(updatedUserModel.toMapFirestore());
      debugPrint('User updated successfully');
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred during updating user',
        code: e.code,
        plugin: e.plugin,
      );
    } on Exception catch (e) {
      throw CustomError(
        message: e.toString(),
        code: 'user_repository_exception',
        plugin: 'updateUser',
      );
    }
  }

  Future<void> deleteUser({required String userId}) async {
    try {
      await firebaseFirestore.collection('users').doc(userId).delete();
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred during deleting user',
        code: e.code,
        plugin: e.plugin,
      );
    }
  }

  Future<UserModel?> getSelfUser() async {
    try {
      final currentUser = fbAuth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw CustomError(
          message: 'No user is currently signed in',
          code: 'no_user_signed_in',
          plugin: 'firebase_auth',
        );
      }
      final snapshot =
          await firebaseFirestore
              .collection('users')
              .where('email', isEqualTo: currentUser.email)
              .get();

      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.first.reference.get();
        UserModel userModel = UserModel.fromDocumentSnapshot(
          snapshot.docs.first,
        );
        return userModel;
      } else {
        throw CustomError(
          message: 'User not found',
          code: 'user_not_found',
          plugin: 'firebase_firestore',
        );
      }
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred during getting self user',
        code: e.code,
        plugin: e.plugin,
      );
    } on Exception catch (e) {
      throw CustomError(
        message: e.toString(),
        code: 'user_repository_exception',
        plugin: 'getSelfUser',
      );
    }
  }
}
