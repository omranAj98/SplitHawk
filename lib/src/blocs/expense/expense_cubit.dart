import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/enums/split_options.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/expense/expense_data_model.dart';
import 'package:splithawk/src/models/expense/expense_model.dart';
import 'package:splithawk/src/models/expense/expense_ref_model.dart';
import 'package:splithawk/src/models/expense/temp_expense_details.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:splithawk/src/repositories/balance_repository.dart';
import 'package:splithawk/src/repositories/expense_repository.dart';
import 'package:splithawk/src/repositories/split_repository.dart';
import 'package:splithawk/src/usecases/new_expense/create_balances_usecase.dart';
import 'package:splithawk/src/usecases/new_expense/split_bill_usecase.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseRepository expenseRepository;
  final SplitRepository splitRepository;
  final BalanceRepository balanceRepository;
  final SplitEquallyBillUseCase splitEquallyBillUseCase =
      SplitEquallyBillUseCase();
  final CreateBalancesUseCase createBalancesUseCase = CreateBalancesUseCase();

  ExpenseCubit({
    required this.expenseRepository,
    required this.splitRepository,
    required this.balanceRepository,
  }) : super(ExpenseState.initial());

  Future<void> fetchUserExpenses(
    DocumentReference userRef,
    List<FriendDataModel> friends,
  ) async {
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
        final splits = await splitRepository.getSplitsByExpenseId(
          expense.id,
          friends,
        );

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

  Future<void> addExpense(
    ExpenseModel expense,
    FriendDataModel friendDataModel,
    SplitOptions splitOption,
  ) async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.loading,
        actionType: ExpenseActionType.add,
      ),
    );
    try {
      final expenseWithRef = await expenseRepository.addExpense(expense);

      final splits = splitEquallyBillUseCase.execute(
        amount: expense.amount,
        selectedFriend: friendDataModel,
        selfUserRef: expense.createdBy,
        splitOption: splitOption,
      );

      await splitRepository.addSplits(expense.id, splits);

      final balances = createBalancesUseCase.execute(
        expense: expenseWithRef,
        splits: splits,
      );

      await balanceRepository.updateBalanceBetwseenFriend(balances);

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

  void updateExpenseName(String name) {
    emit(
      state.copyWith(
        tempExpenseDetails: state.tempExpenseDetails?.copyWith(name: name),
      ),
    );
  }

  void updateExpenseSplitOption(SplitOptions splitOption) {
    emit(
      state.copyWith(
        tempExpenseDetails: state.tempExpenseDetails?.copyWith(
          splitOption: splitOption,
        ),
      ),
    );
  }

  void updateExpenseAmount(double amount) {
    emit(
      state.copyWith(
        tempExpenseDetails: state.tempExpenseDetails?.copyWith(amount: amount),
      ),
    );
  }

  void updateExpenseDate(DateTime date) {
    emit(
      state.copyWith(
        tempExpenseDetails: state.tempExpenseDetails?.copyWith(date: date),
      ),
    );
  }

  void updateExpenseCurrency(String currency) {
    final currentDetails = state.tempExpenseDetails ?? TempExpenseDetails();
    emit(state.copyWith(
      tempExpenseDetails: currentDetails.copyWith(currency: currency),
    ));
  }

  void resetTempExpenseDetails() {
    emit(
      state.copyWith(
        tempExpenseDetails: TempExpenseDetails(), // Create a new empty instance
      ),
    );
  }
}
