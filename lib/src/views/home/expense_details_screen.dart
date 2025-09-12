import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/widgets/app_safe_area.dart';
import 'package:splithawk/src/models/expense/expense_data_model.dart';
import 'package:splithawk/src/models/friend_data_model.dart';

class ExpenseDetailsScreen extends StatefulWidget {
  final ExpenseDataModel expenseData;
  final FriendDataModel? friend;
  final DocumentReference selfUserRef;

  const ExpenseDetailsScreen({
    super.key,
    required this.expenseData,
    this.friend,
    required this.selfUserRef,
  });

  @override
  State<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      print('Navigator hashCode: ${Navigator.of(context).hashCode}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final expense = widget.expenseData.expense;
    final splits = widget.expenseData.splits;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Format dates
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    final formattedDate =
        expense.createdAt != null
            ? dateFormat.format(expense.createdAt!)
            : AppLocalizations.of(context)!.unknownDate;

    final formattedTime =
        expense.createdAt != null ? timeFormat.format(expense.createdAt!) : '';

    // Calculate who paid and who owes
    final payers =
        splits
            .where((split) => split.paidAmount != null && split.paidAmount! > 0)
            .toList();

    final friendSplit = splits.firstWhere(
      (split) => split.userRef == widget.friend?.userRef,
      orElse: () => splits.first,
    );

    final selfSplit = splits.firstWhere(
      (split) => split.userRef == widget.selfUserRef,
      orElse: () => splits.first,
    );

    final friendPaid = friendSplit.paidAmount ?? 0;
    final selfPaid = selfSplit.paidAmount ?? 0;
    final friendOwes = friendSplit.owedAmount;
    final selfOwes = selfSplit.owedAmount;

    final friendNetAmount = friendPaid - friendOwes;
    final selfNetAmount = selfPaid - selfOwes;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(widget.expenseData.expense.expenseName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit expense functionality
            },
          ),
        ],
      ),
      body: AppSafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expense Name & Amount
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Hero(
                              tag:
                                  'expense-${expense.expenseName}-${expense.id}',
                              child: Text(
                                expense.expenseName,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Hero(
                            tag: 'expense-amount-${expense.id}',
                            child: Text(
                              '${expense.currency} ${expense.amount.toStringAsFixed(2)}',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(formattedDate, style: textTheme.bodyMedium),
                              if (formattedTime.isNotEmpty)
                                Text(
                                  formattedTime,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      if (expense.category != null &&
                          expense.category!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.category, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                expense.category!,
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Payment details
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.paymentDetails,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Who paid
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: payers.length,
                        itemBuilder: (context, index) {
                          final payer = payers[index];
                          final isPaidByFriend =
                              payer.userRef == widget.friend?.userRef;
                          final payerName =
                              isPaidByFriend
                                  ? widget.friend!.friendName
                                  : AppLocalizations.of(context)!.you;

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor:
                                  isPaidByFriend
                                      ? Colors.amber.withAlpha(20)
                                      : Theme.of(
                                        context,
                                      ).primaryColor.withAlpha(20),
                              child: Icon(
                                Icons.person,
                                color:
                                    isPaidByFriend
                                        ? Colors.amber.shade800
                                        : Theme.of(context).primaryColor,
                              ),
                            ),
                            title: Text(payerName),
                            subtitle: Text(AppLocalizations.of(context)!.paid),
                            trailing: Text(
                              '${expense.currency} ${payer.paidAmount!.toStringAsFixed(2)}',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Split details
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.splitDetails,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // You
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withAlpha(20),
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        title: Text(AppLocalizations.of(context)!.you),
                        subtitle: Text(
                          selfNetAmount < 0
                              ? AppLocalizations.of(context)!.youOwe
                              : selfNetAmount > 0
                              ? AppLocalizations.of(context)!.lent
                              : AppLocalizations.of(context)!.settled,
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.owes}: ${expense.currency} ${selfOwes.toStringAsFixed(2)}',
                              style: textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selfNetAmount < 0
                                  ? '${expense.currency} ${selfNetAmount.abs().toStringAsFixed(2)}'
                                  : selfNetAmount > 0
                                  ? '+${expense.currency} ${selfNetAmount.toStringAsFixed(2)}'
                                  : '${expense.currency} 0.00',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    selfNetAmount < 0
                                        ? Colors.red
                                        : selfNetAmount > 0
                                        ? Colors.green
                                        : null,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(),

                      // Friend
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber.withAlpha(20),
                          child: Icon(
                            Icons.person,
                            color: Colors.amber.shade800,
                          ),
                        ),
                        title: Text(widget.friend!.friendName),
                        subtitle: Text(
                          friendNetAmount < 0
                              ? AppLocalizations.of(context)!.owes
                              : friendNetAmount > 0
                              ? AppLocalizations.of(context)!.lent
                              : AppLocalizations.of(context)!.settled,
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.owes}: ${expense.currency} ${friendOwes.toStringAsFixed(2)}',
                              style: textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              friendNetAmount < 0
                                  ? '${expense.currency} ${friendNetAmount.abs().toStringAsFixed(2)}'
                                  : friendNetAmount > 0
                                  ? '+${expense.currency} ${friendNetAmount.toStringAsFixed(2)}'
                                  : '${expense.currency} 0.00',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    friendNetAmount < 0
                                        ? Colors.red
                                        : friendNetAmount > 0
                                        ? Colors.green
                                        : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Notes section if available
              if (expense.description != null &&
                  expense.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.description,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            expense.description!,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
