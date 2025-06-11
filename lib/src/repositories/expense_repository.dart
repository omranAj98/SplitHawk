import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/expense/expense_model.dart';
import 'package:splithawk/src/models/expense/expense_ref_model.dart';

class ExpenseRepository {
  final FirebaseFirestore firebaseFirestore;
  ExpenseRepository({required this.firebaseFirestore});

  Future<List<ExpenseModel>>? getExpenses() async {
    try {
      final snapshot = await firebaseFirestore.collection('expenses').get();
      return snapshot.docs
          .map((doc) => ExpenseModel.fromFirestoreDoc(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message.toString(),
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'Failed to fetch expenses: ${e.toString()}',
        code: 'getExpenses',
        plugin: 'expense_repository',
      );
    }
  }

  Future<List<ExpenseRefModel>>? getExpensesRefByUserRef(
    DocumentReference userRef,
  ) async {
    try {
      final snapshot =
          await firebaseFirestore
              .collection('users')
              .doc(userRef.id)
              .collection('expensesRef')
              .get();

      return snapshot.docs
          .map((doc) => ExpenseRefModel.fromFirestoreDoc(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message.toString(),
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'Failed to fetch expenses references: ${e.toString()}',
        code: 'getExpensesRefByUserRef',
        plugin: 'expense_repository',
      );
    }
  }

  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    try {
      final expenseRef = firebaseFirestore
          .collection('expenses')
          .doc(expense.id);

      await expenseRef.set(expense.toFirestoreMap());

      final expenseRefModel = ExpenseRefModel(
        id: expense.id,
        expenseRef: expenseRef,
      );

      final expenseRefMap = expenseRefModel.toFirestoreMap();

      for (final participant in expense.participantsRef ?? []) {
        await firebaseFirestore
            .collection('users')
            .doc(participant.id)
            .collection('expensesRef')
            .doc(expense.id)
            .set(expenseRefMap);
      }
      return expense.copyWith(expenseRef: expenseRef);
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message.toString(),
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'Failed to add expense: ${e.toString()}',
        code: 'addExpense',
        plugin: 'expense_repository',
      );
    }
  }

  Future<void> updateExpense(
    String expenseId,
    Map<String, dynamic> expenseData,
  ) async {
    try {
      await firebaseFirestore
          .collection('expenses')
          .doc(expenseId)
          .update(expenseData);
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message.toString(),
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'Failed to update expense: ${e.toString()}',
        code: 'updateExpense',
        plugin: 'expense_repository',
      );
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await firebaseFirestore.collection('expenses').doc(expenseId).delete();
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message.toString(),
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw Exception('Failed to delete expense:  ${e.toString()}');
    }
  }

  Future<ExpenseModel?> getExpenseById(String expenseId) async {
    try {
      final doc =
          await firebaseFirestore.collection('expenses').doc(expenseId).get();
      if (doc.exists) {
        return ExpenseModel.fromFirestoreDoc(doc);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw CustomError(
        message: e.message.toString(),
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'Failed to fetch expense by ID: $e',
        code: 'getExpenseById',
        plugin: 'expense_repository',
      );
    }
  }

  Future<List<ExpenseModel>>? getExpensesByUserRef(
    DocumentReference userRef,
  ) async {
    try {
      final snapshot =
          await firebaseFirestore
              .collection('expenses')
              .where('participantsRef', arrayContains: userRef)
              .get();

      return snapshot.docs
          .map((doc) => ExpenseModel.fromFirestoreDoc(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw CustomError(
        message: 'Failed to add expense: ${e.message}',
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'Failed to fetch expenses by user reference: $e',
        code: 'getExpensesByUserRef',
        plugin: 'expense_repository',
      );
    }
  }
}
