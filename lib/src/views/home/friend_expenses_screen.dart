import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/blocs/expense/expense_cubit.dart';
import 'package:splithawk/src/core/enums/request_status.dart';

class FriendExpensesScreen extends StatelessWidget {
  final String friendName;
  final String friendId;
  final dynamic friendUserRef;
  const FriendExpensesScreen({
    super.key,
    required this.friendName,
    required this.friendId,
    required this.friendUserRef,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses with $friendName')),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          if (state.requestStatus == RequestStatus.loading &&
              state.actionType == ExpenseActionType.fetch) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.requestStatus == RequestStatus.error &&
              state.actionType == ExpenseActionType.fetch) {
            return Center(child: Text(state.error.message));
          } else if (state.expenseData == null || state.expenseData!.isEmpty) {
            return const Center(child: Text('No expenses found.'));
          } else {
            // Filter expenses to only those with this friend, if needed
            final friendExpenses =
                state.expenseData!.where((expenseData) {
                  // Filter by friendUserRef in splits
                  return expenseData.splits.any(
                    (split) => split.userRef == friendUserRef,
                  );
                }).toList();
            if (friendExpenses.isEmpty) {
              return const Center(child: Text('No expenses with this friend.'));
            }
            return ListView.builder(
              itemCount: friendExpenses.length,
              itemBuilder: (context, index) {
                final expense = friendExpenses[index];
                return ListTile(
                  title: Text(expense.expense.expenseName),
                  subtitle: Text('Amount: ${expense.expense.amount}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
