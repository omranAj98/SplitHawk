import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/user_model.dart';
import 'package:splithawk/src/repositories/balance_repository.dart';

class UserRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseFunctions firebaseFunctions;
  final BalanceRepository balanceRepository;
  UserRepository({
    required this.firebaseFirestore,
    required this.firebaseFunctions,
    required this.balanceRepository,
  });

  Future<void> createUser(UserModel userModel) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(userModel.id)
          .set(userModel.toFirestoreMap());

      // final HttpsCallable callable = firebaseFunctions.httpsCallable(
      //   'createUser',
      // );
      // await callable.call(userModel.toFirestoreMap());
      debugPrint('User created successfully');
    } catch (e) {
      throw CustomError(
        message: e.toString(),
        code: 'createUser',
        plugin: 'user_repository',
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
        debugPrint('user found');
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
    } on Exception catch (e) {
      throw CustomError(
        message: e.toString(),
        code: 'getUserDoc',
        plugin: 'user_repository',
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
        final userModel = UserModel.fromUserDocAndBalanceModel(
          userDoc: userSnapShot.docs.first,
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
      final userSnapshot =
          await firebaseFirestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (userSnapshot.docs.isNotEmpty) {
        debugPrint('user already exist');

        return UserModel.fromUserDocAndBalanceModel(
          userDoc: userSnapshot.docs.first,
        );
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
          .update(updatedUserModel.toFirestoreMap());

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
      final userSnapshot =
          await firebaseFirestore
              .collection('users')
              .where('email', isEqualTo: currentUser.email)
              .get();

      final balanceList = await balanceRepository.getUserNetBalances(
        userSnapshot.docs.first.id,
      );

      if (userSnapshot.docs.isNotEmpty) {
        userSnapshot.docs.first.reference.get();
        UserModel userModel = UserModel.fromUserDocAndBalanceModel(
          userDoc: userSnapshot.docs.first,
          balanceList: balanceList,
        );
        return userModel;
      } else {
        debugPrint('GetSelfUser in user_repository.dart: User not found');
        return null;
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

  Future<DocumentSnapshot> getUserDocByRef(DocumentReference userRef) async {
    try {
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        return userSnapshot;
      } else {
        throw CustomError(
          message: 'User document does not exist',
          code: 'user_doc_not_found',
          plugin: 'firebase_firestore',
        );
      }
    } on FirebaseException catch (e) {
      throw CustomError(
        message:
            e.message ?? 'An error occurred during getting user doc by ref',
        code: e.code,
        plugin: e.plugin,
      );
    }
  }
}
