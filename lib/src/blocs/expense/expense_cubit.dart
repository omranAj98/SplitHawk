import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/expense/expense_data_model.dart';
import 'package:splithawk/src/models/expense/expense_model.dart';
import 'package:splithawk/src/models/expense/expense_ref_model.dart';
import 'package:splithawk/src/models/expense/split_model.dart';
import 'package:splithawk/src/repositories/expense_repository.dart';
import 'package:splithawk/src/repositories/split_repository.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseRepository expenseRepository;
  final SplitRepository splitRepository;

  ExpenseCubit({required this.expenseRepository, required this.splitRepository})
    : super(ExpenseState.initial());

  Future<void> fetchUserExpenses(DocumentReference userRef) async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.loading,
        actionType: ExpenseActionType.fetch,
      ),
    );
    try {
      final expensesRef = await expenseRepository.getExpensesRefByUserRef(
        userRef,
      );
      if (expensesRef == null || expensesRef.isEmpty) {
        debugPrint('No expenses references found for user: ${userRef.id}');
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            actionType: ExpenseActionType.fetch,
            expenseData: [],
          ),
        );
        return;
      }

      final List<ExpenseDataModel> expensesData = [];
      for (final expenseRef in expensesRef) {
        final expense = await expenseRepository.getExpenseById(expenseRef.id);
        if (expense == null) continue;
        final splits = await splitRepository.getSplitsByExpenseId(expense.id);

        final newExpenseData = ExpenseDataModel(
          expense: expense,
          splits: splits,
          expenseRef: ExpenseRefModel(
            id: expense.id,
            expenseRef: expense.expenseRef!,
          ),
        );

        expensesData.add(newExpenseData);
      }

      emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          actionType: ExpenseActionType.fetch,
          expenseData: expensesData,
        ),
      );
    } on CustomError catch (error) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          actionType: ExpenseActionType.fetch,
          error: error,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          actionType: ExpenseActionType.fetch,
          error: CustomError(
            message: error.toString(),
            code: 'fetchUserExpenses',
            plugin: 'expense_cubit',
          ),
        ),
      );
    }
  }

  
  Future<void> addExpense(ExpenseModel expense, List<SplitModel> splits) async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.loading,
        actionType: ExpenseActionType.add,
      ),
    );
    try {
      final expenseWithRef = await expenseRepository.addExpense(expense);

      await splitRepository.addSplits(expense.id, splits);

      emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          actionType: ExpenseActionType.add,
          expenseData:
              state.expenseData! +
              [
                ExpenseDataModel(
                  expense: expenseWithRef,
                  splits: splits,
                  expenseRef: ExpenseRefModel(
                    id: expense.id,
                    expenseRef: expenseWithRef.expenseRef!,
                  ),
                ),
              ],
        ),
      );
    } on CustomError catch (error) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          actionType: ExpenseActionType.add,
          error: error,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          actionType: ExpenseActionType.add,
          error: CustomError(
            message: error.toString(),
            code: 'addExpense',
            plugin: 'expense_cubit',
          ),
        ),
      );
    }
  }
}
