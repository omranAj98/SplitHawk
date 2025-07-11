import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:splithawk/src/blocs/expense/expense_cubit.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/models/expense/expense_data_model.dart';
import 'package:splithawk/src/models/friend_data_model.dart';

class FriendExpensesScreen extends StatelessWidget {
  final FriendDataModel friend;
  final DocumentReference selfUserRef;
  const FriendExpensesScreen({
    super.key,
    required this.friend,
    required this.selfUserRef,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const SizedBox.shrink(), // Removed title, keeping only back button
        elevation: 0,
      ),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, expenseState) {
          if (expenseState.requestStatus == RequestStatus.loading &&
              expenseState.actionType == ExpenseActionType.fetch) {
            return const Center(child: CircularProgressIndicator());
          } else if (expenseState.requestStatus == RequestStatus.error &&
              expenseState.actionType == ExpenseActionType.fetch) {
            return Center(child: Text(expenseState.error.message));
          } else {
            // Filter expenses to only those with this friend
            final friendExpenses =
                expenseState.expenseData?.where((expenseData) {
                  return expenseData.splits.any(
                    (split) => split.userRef == friend.userRef,
                  );
                }).toList() ??
                [];

            return BlocBuilder<FriendCubit, FriendState>(
              builder: (context, friendState) {
                if (friendState.requestStatus == RequestStatus.loading &&
                    friendState.actionType == FriendActionType.fetch) {
                  return const Center(child: CircularProgressIndicator());
                } else if (friendState.requestStatus == RequestStatus.error &&
                    friendState.actionType == FriendActionType.fetch) {
                  return Center(
                    child: Text(friendState.error!.getMessage(context)),
                  );
                }

                return Column(
                  children: [
                    // Friend balance summary section
                    _buildBalanceSummary(context),

                    // Section title for expenses
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.receipt_long, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.expenses,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    // Expenses list
                    Expanded(
                      child:
                          friendExpenses.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.receipt_long_outlined,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.noExpensesFound,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : ListView.builder(
                                itemCount: friendExpenses.length,
                                itemBuilder: (context, index) {
                                  final expenseData = friendExpenses[index];

                                  final expenseMonthYear = DateFormat(
                                    'MMMM yyyy',
                                  ).format(expenseData.expense.createdAt!);
                                  final previousExpenseMonthYear =
                                      index > 0
                                          ? DateFormat('MMMM yyyy').format(
                                            friendExpenses[index - 1]
                                                .expense
                                                .createdAt!,
                                          )
                                          : null;

                                  // Add a divider for new month/year
                                  if (expenseMonthYear !=
                                      previousExpenseMonthYear) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).primaryColor.withAlpha(30),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              expenseMonthYear,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        _buildExpenseCard(context, expenseData),
                                      ],
                                    );
                                  } else {
                                    return _buildExpenseCard(
                                      context,
                                      expenseData,
                                    );
                                  }
                                },
                              ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement add expense with this friend
        },
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.addExpense),
      ),
    );
  }

  Widget _buildBalanceSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.balanceSummary,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (friend.friendBalances.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.noActiveBalancesFound,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            ...friend.friendBalances.map((balance) {
              final isPositive = balance.netAmount >= 0;
              final amountText =
                  '${balance.currency} ${balance.netAmount.abs().toStringAsFixed(2)}';
              final owingText =
                  isPositive
                      ? '${friend.friendName} ${AppLocalizations.of(context)!.owesYou}'
                      : '${AppLocalizations.of(context)!.youOwe} ${friend.friendName}';

              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.green : Colors.red).withOpacity(
                    0.1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (isPositive ? Colors.green : Colors.red).withOpacity(
                      0.3,
                    ),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isPositive
                              ? Icons.arrow_circle_up
                              : Icons.arrow_circle_down,
                          color: isPositive ? Colors.green : Colors.red,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          owingText,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Text(
                      amountText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(BuildContext context, ExpenseDataModel expenseData) {
    final expense = expenseData.expense;
    final splits = expenseData.splits;

    // Format date
    final dayFromat = DateFormat('EEE');
    final dateFormat = DateFormat('d MMM');

    final formattedDay =
        expense.createdAt != null
            ? dayFromat.format(expense.createdAt!)
            : AppLocalizations.of(context)!.unknownDate;

    final formattedDate =
        expense.createdAt != null
            ? dateFormat.format(expense.createdAt!)
            : AppLocalizations.of(context)!.unknownDate;

    // Determine payers information
    final payers =
        splits
            .where((split) => split.paidAmount != null && split.paidAmount! > 0)
            .toList();
    String payerInfo;
    bool isPaidByFriend = false;
    bool isPaidByYou = false;

    if (payers.isEmpty) {
      payerInfo = AppLocalizations.of(context)!.unknown;
    } else if (payers.length == 1) {
      final payer = payers.first;
      isPaidByFriend = payer.userRef == friend.userRef;
      isPaidByYou = payer.userRef == selfUserRef;
      final payerName =
          isPaidByFriend
              ? friend.friendName
              : AppLocalizations.of(context)!.you;
      payerInfo = payerName;
    } else {
      payerInfo = '${payers.length} ${AppLocalizations.of(context)!.people}';
    }

    // Calculate total amount owed by self user
    double selfOwesTotal = 0;
    for (var split in splits) {
      if (split.userRef == selfUserRef && !split.isSettled) {
        selfOwesTotal += split.owedAmount - split.paidAmount!;
      }
    }

    // Find friend's splits
    final friendSplit = splits.firstWhere(
      (split) => split.userRef == friend.userRef,
      orElse: () => splits.first,
    );
    final friendOwes = friendSplit.owedAmount - (friendSplit.paidAmount ?? 0);
    final friendOwesAmount = friendOwes > 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Navigate to expense details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date circle
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formattedDay,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Expense details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.expenseName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: (isPaidByYou
                                        ? Colors.blue
                                        : isPaidByFriend
                                        ? Colors.amber
                                        : Colors.purple)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPaidByYou
                                        ? Icons.person
                                        : isPaidByFriend
                                        ? Icons.person_outline
                                        : Icons.group,
                                    size: 14,
                                    color:
                                        isPaidByYou
                                            ? Colors.blue
                                            : isPaidByFriend
                                            ? Colors.amber.shade800
                                            : Colors.purple,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${AppLocalizations.of(context)!.paidBy}: $payerInfo',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          isPaidByYou
                                              ? Colors.blue
                                              : isPaidByFriend
                                              ? Colors.amber.shade800
                                              : Colors.purple,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${expense.currency} ${expense.amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      if (selfOwesTotal > 0 || friendOwesAmount)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: (selfOwesTotal > 0
                                    ? Colors.red
                                    : Colors.green)
                                .withValues(alpha: 10),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (selfOwesTotal > 0
                                      ? Colors.red
                                      : Colors.green)
                                  .withValues(alpha: 30),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            selfOwesTotal > 0
                                ? '${AppLocalizations.of(context)!.youOwe}: ${expense.currency} ${selfOwesTotal.toStringAsFixed(2)}'
                                : '${friend.friendName} ${AppLocalizations.of(context)!.owes}: ${expense.currency} ${friendOwes.abs().toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  selfOwesTotal > 0 ? Colors.red : Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
