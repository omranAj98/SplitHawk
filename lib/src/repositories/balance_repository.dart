import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/balance_model.dart';

class BalanceRepository {
  final FirebaseFirestore firebaseFirestore;
  BalanceRepository({required this.firebaseFirestore});

  Future<List<BalanceModel>>? getFriendBalances(
    DocumentReference userRef,
    DocumentReference friendRef,
  ) async {
    try {
      final snapshot =
          await userRef
              .collection('friends')
              .doc(friendRef.id)
              .collection('balances')
              .get();
      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs
          .map((doc) => BalanceModel.fromFirebaseDocument(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message ?? 'Failed to fetch balances',
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'Failed to fetch balances: ${e.toString()}',
        code: 'getBalances',
        plugin: 'balance_repository',
      );
    }
  }

  Future<List<BalanceModel>> getUserNetBalances(String id) async {
    try {
      final snapshot =
          await firebaseFirestore
              .collection("users")
              .doc(id)
              .collection('netBalances')
              .get();
      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs
          .map((doc) => BalanceModel.fromFirebaseDocument(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message ?? 'Failed to fetch balances',
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'Failed to fetch balances: ${e.toString()}',
        code: 'getBalances',
        plugin: 'balance_repository',
      );
    }
  }

  Future<void> updateBalanceBetwseenFriend(List<BalanceModel> balances) async {
    try {
      await firebaseFirestore.runTransaction((transaction) async {
        for (final balance in balances) {
          transaction.set(
            balance.docRef,
            balance.toFirebaseMap(),
            SetOptions(merge: true),
          );
        }
      });
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message ?? 'Failed to update balance',
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'Failed to update balance: ${e.toString()}',
        code: 'updateBalance',
        plugin: 'balance_repository',
      );
    }
  }
}
