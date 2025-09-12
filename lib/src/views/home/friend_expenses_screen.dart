import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:splithawk/src/blocs/expense/expense_cubit.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/core/constants/app_icons.dart';
import 'package:splithawk/src/core/cubit/menu_cubit.dart';
import 'package:splithawk/src/core/enums/menus.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/routes.dart';
import 'package:splithawk/src/core/widgets/app_safe_area.dart';
import 'package:splithawk/src/core/widgets/app_snack_bar.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
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

                return CustomScrollView(
                  slivers: [
                    // Friend name app bar
                    SliverAppBar.medium(
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      // actions: [
                      //   IconButton(
                      //     padding: const EdgeInsets.only(right: 28),
                      //     icon: const Icon(Icons.arrow_drop_down_outlined),
                      //     onPressed: () {
                      //       // context.pushNamed(
                      //       //   AppRoutes.friendSettings,
                      //       //   pathParameters: {'friendId': friend.id},
                      //       // );
                      //     },
                      //   ),
                      // ],
                      expandedHeight: 220.0,
                      // floating: false,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      title: _buildCollapsedSummary(context),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      flexibleSpace: FlexibleSpaceBar(
                        background: _buildExpandedSummary(context, colorScheme),
                        expandedTitleScale: 1,
                      ),
                    ),

                    // Section title for expenses
                    SliverToBoxAdapter(
                      child: Padding(
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
                    ),

                    // Expenses list or empty state
                    friendExpenses.isEmpty
                        ? SliverFillRemaining(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
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
                            ),
                          ),
                        )
                        : SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
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
                            if (expenseMonthYear != previousExpenseMonthYear) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        expenseMonthYear,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  _buildExpenseCard(context, expenseData),
                                ],
                              );
                            } else {
                              return _buildExpenseCard(context, expenseData);
                            }
                          }, childCount: friendExpenses.length),
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
          context.read<MenuCubit>().updateMenu(Menus.add);
          context.read<FriendCubit>().selectFriendToExpense(friend);
        },
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.addExpense),
      ),
    );
  }

  _buildSettleUpDialog(
    BuildContext context,
    FriendDataModel friend,
    TextTheme textTheme,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Default to first currency if available
        String selectedCurrency =
            friend.friendBalances.isNotEmpty
                ? friend.friendBalances.first.currency
                : 'USD';
        final TextEditingController amountController = TextEditingController();

        // Pre-fill with balance amount if available
        if (friend.friendBalances.isNotEmpty) {
          amountController.text = friend.friendBalances.first.netAmount
              .abs()
              .toStringAsFixed(2);
        }

        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.settleUp),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.settleUpWith(friend.friendName),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),

                // Amount field
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.amount,
                    prefixText: '$selectedCurrency ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Payment method selection
                Text(
                  AppLocalizations.of(context)!.paymentMethod,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),

                // Payment options
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text('Cash'),
                      selected: true,
                      onSelected: (_) {},
                    ),
                    ChoiceChip(
                      label: Text('Online'),
                      selected: false,
                      onSelected: (_) {},
                    ),
                    ChoiceChip(
                      label: Text('Other'),
                      selected: false,
                      onSelected: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement actual settle up functionality
                Navigator.of(context).pop();

                // Show confirmation message
                AppSnackBar.show(
                  context,
                  message: AppLocalizations.of(
                    context,
                  )!.settledUpWith(friend.friendName),
                  type: SnackBarType.success,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                AppLocalizations.of(context)!.confirm,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
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
          context.pushNamed(
            AppRoutesName.expenesDetails,
            extra: {
              'expenseData': expenseData,
              'friend': friend,
              'selfUserRef': selfUserRef,
            },
          );
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
                      color: Theme.of(context).primaryColor.withAlpha(10),
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
                        Hero(
                          tag: 'expense-${expense.expenseName}-${expense.id}',
                          child: Text(
                            expense.expenseName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
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
                                    .withAlpha(15),
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
                      Hero(
                        tag: 'expense-amount-${expense.id}',
                        child: Text(
                          '${expense.currency} ${expense.amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
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

  Widget _buildExpandedSummary(BuildContext context, ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;
    final BorderSide border = BorderSide(
      width: 2.5,
      color: colorScheme.onTertiary.withAlpha(200),
    );

    return AppSafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        margin: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'friend-${friend.friendId}',
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,

                    child: Icon(AppIcons.contactIcon, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    friend.friendName,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (friend.friendBalances.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.noActiveBalancesFound,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...friend.friendBalances.map((balance) {
                      return Hero(
                        tag: 'balance-${balance.docRef.id}',
                        child: Row(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                border: BorderDirectional(
                                  bottom: border,
                                  start: border,
                                ),
                              ),
                              child: const SizedBox(height: 20.0, width: 21.0),
                            ),
                            Expanded(
                              // Add this to constrain the text width
                              child:
                                  (balance.netAmount > 0)
                                      ? Text(
                                        '${friend.friendName} ${AppLocalizations.of(context)!.owesYou} ${balance.netAmount} ${balance.currency}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.primary,
                                        ),
                                        overflow:
                                            TextOverflow
                                                .ellipsis, // Handle text overflow
                                      )
                                      : (balance.netAmount < 0)
                                      ? Text(
                                        '${AppLocalizations.of(context)!.youOwe} ${friend.friendName} ${balance.netAmount.abs()} ${balance.currency}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.error,
                                        ),
                                        overflow:
                                            TextOverflow
                                                .ellipsis, // Handle text overflow
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            () => _buildSettleUpDialog(
                              context,
                              friend,
                              Theme.of(context).textTheme,
                            ),
                        icon: const Icon(Icons.handshake, size: 20),
                        label: Text(
                          AppLocalizations.of(context)!.settleUp,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedSummary(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (friend.friendBalances.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.noActiveBalances,
            style: textTheme.bodyMedium,
          ),
        ),
      );
    }

    // Get the first balance to display in compact mode
    final balance = friend.friendBalances.first;
    final isPositive = balance.netAmount >= 0;
    final amountText =
        '${balance.currency} ${balance.netAmount.abs().toStringAsFixed(2)}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Balance info
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                color: isPositive ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPositive
                        ? AppLocalizations.of(
                          context,
                        )!.userOwesYou(friend.friendName)
                        : AppLocalizations.of(
                          context,
                        )!.youOweUser(friend.friendName),
                    style: textTheme.bodyMedium,
                  ),
                  Text(
                    amountText,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Compact settle up button
          ElevatedButton.icon(
            onPressed:
                () => _buildSettleUpDialog(
                  context,
                  friend,
                  Theme.of(context).textTheme,
                ),
            icon: const Icon(Icons.handshake, size: 16),
            label: Text(
              AppLocalizations.of(context)!.settleUp,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              minimumSize: const Size(80, 36),
            ),
          ),
        ],
      ),
    );
  }
}
