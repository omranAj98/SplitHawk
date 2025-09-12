// In a new file or alongside your models
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:splithawk/src/models/expense/expense_model.dart';
import 'package:splithawk/src/models/expense/expense_ref_model.dart';
import 'package:splithawk/src/models/expense/split_model.dart';

class ExpenseDataModel extends Equatable {
  final ExpenseRefModel expenseRef;
  final ExpenseModel expense;
  final List<SplitModel> splits;

  const ExpenseDataModel({
    required this.expense,
    required this.splits,
    required this.expenseRef,
  });

  factory ExpenseDataModel.fromModels(
    ExpenseModel expense,
    List<SplitModel> splits,
    ExpenseRefModel expenseRef,
  ) {
    return ExpenseDataModel(
      expense: expense,
      splits: splits,
      expenseRef: expenseRef,
    );
  }

  factory ExpenseDataModel.fromFirestoreDoc({
    required DocumentSnapshot expenseDoc,
    required List<SplitModel> splits,
    required ExpenseRefModel expenseRef,
  }) {
    return ExpenseDataModel(
      expense: ExpenseModel.fromFirestoreDoc(expenseDoc),
      splits: splits,
      expenseRef: expenseRef,
    );
  }

  @override
  List<Object?> get props => [expense, splits];
}
