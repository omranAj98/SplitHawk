import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/expense/split_model.dart';
import 'package:splithawk/src/models/friend_data_model.dart';

class SplitRepository {
  final FirebaseFirestore firestore;

  SplitRepository({required this.firestore});

  Future<List<SplitModel>> getSplitsByExpenseId(
    String expenseId,
    List<FriendDataModel> friends,
  ) async {
    try {
      final snapshot =
          await firestore
              .collection('expenses')
              .doc(expenseId)
              .collection('splits')
              .get();
      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<SplitModel> splits = [];

      for (var doc in snapshot.docs) {
        var split = SplitModel.fromFirestoreDoc(doc: doc);

        final userModel = friends.firstWhere(
          (friend) => friend.userRef == split.userRef,
          orElse: () => friends.first.copyWith(friendName: "you"),
        );

        final owedToUserModel = friends.firstWhere(
          (friend) => friend.userRef == split.owedToUserRef,
          orElse: () => friends.first.copyWith(friendName: "you"),
        );
        final splitWithUsersNames = split.copyWith(
          userName: userModel.friendName,
          owedToName: owedToUserModel.friendName,
        );

        splits.add(splitWithUsersNames);
      }

      return splits;
    } catch (e) {
      throw CustomError(
        message: 'Failed to fetch splits: $e',
        code: 'splits_fetch_error',
        plugin: 'split_repository',
      );
    }
  }

  Future<void> addSplits(String? expenseId, List<SplitModel> splits) async {
    try {
      final batch = firestore.batch();
      for (final split in splits) {
        final splitRef = firestore
            .collection('expenses')
            .doc(expenseId)
            .collection('splits')
            .doc(split.id);
        batch.set(splitRef, split.toFirestoreMap());
      }
      await batch.commit();
    } catch (e) {
      throw CustomError(
        message: '$e',
        code: 'addSplit',
        plugin: 'split_repository',
      );
    }
  }

  Future<void> updateSplit(
    String expenseId,
    String splitId,
    Map<String, dynamic> splitData,
  ) async {
    try {
      await firestore
          .collection('expenses')
          .doc(expenseId)
          .collection('splits')
          .doc(splitId)
          .update(splitData);
    } catch (e) {
      throw CustomError(
        message: '$e',
        code: 'supdateSplit',
        plugin: 'split_repository',
      );
    }
  }

  Future<void> deleteSplit(String expenseId, String splitId) async {
    try {
      await firestore
          .collection('expenses')
          .doc(expenseId)
          .collection('splits')
          .doc(splitId)
          .delete();
    } catch (e) {
      throw CustomError(
        message: '$e',
        code: 'sdeleteSplit',
        plugin: 'split_repository',
      );
    }
  }
}
