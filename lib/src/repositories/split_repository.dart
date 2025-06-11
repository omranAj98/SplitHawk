import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/expense/split_model.dart';

class SplitRepository {
  final FirebaseFirestore firestore;

  SplitRepository({required this.firestore});

  Future<List<SplitModel>> getSplitsByExpenseId(String expenseId) async {
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
      return snapshot.docs
          .map((doc) => SplitModel.fromFirestoreDoc(doc))
          .toList();
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
