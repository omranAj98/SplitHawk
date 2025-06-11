import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:splithawk/src/models/expense/split_model.dart';

enum SplitOption {
  youPaidFullTheyOweHalf,
  theyPaidFullYouOweHalf,
  youPaidFullTheyOweFull,
  theyPaidFullYouOweFull,
}

class ExpenseSplitOptionsScreen extends StatelessWidget {
  final double amount;
  final List<FriendDataModel> selectedFriends;
  final String currency;
  final DocumentReference userRef;

  const ExpenseSplitOptionsScreen({
    Key? key,
    required this.amount,
    required this.selectedFriends,
    this.currency = '\$',
    required this.userRef,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Split Option')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildSplitOption(
              context,
              AppLocalizations.of(context)!.youPaidFullTheyOweHalf,
              '${AppLocalizations.of(context)!.youPaid} $currency ${amount.toStringAsFixed(2)}\n${AppLocalizations.of(context)!.eachFriendOwesYou} $currency ${(amount / (selectedFriends.length + 1)).toStringAsFixed(2)}',
              Icons.arrow_forward,
              () => _handleSplitSelection(
                context,
                SplitOption.youPaidFullTheyOweHalf,
              ),
            ),
            const SizedBox(height: 16),
            _buildSplitOption(
              context,
              AppLocalizations.of(context)!.theyPaidFullYouOweFull,
              '${AppLocalizations.of(context)!.theyPaid} $currency ${amount.toStringAsFixed(2)}\n${AppLocalizations.of(context)!.youOweEachFriend} $currency ${(amount / (selectedFriends.length + 1)).toStringAsFixed(2)}',
              Icons.arrow_back,
              () => _handleSplitSelection(
                context,
                SplitOption.theyPaidFullYouOweHalf,
              ),
            ),
            const SizedBox(height: 16),
            _buildSplitOption(
              context,
              AppLocalizations.of(context)!.youPaidFullTheyOweFull,
              '${AppLocalizations.of(context)!.youPaid} $currency ${amount.toStringAsFixed(2)}\n${AppLocalizations.of(context)!.eachFriendOwesYou} $currency ${(amount / selectedFriends.length).toStringAsFixed(2)}',
              Icons.arrow_upward,
              () => _handleSplitSelection(
                context,
                SplitOption.youPaidFullTheyOweFull,
              ),
            ),
            const SizedBox(height: 16),
            _buildSplitOption(
              context,
              AppLocalizations.of(context)!.theyPaidFullYouOweFull,
              '${AppLocalizations.of(context)!.theyPaid} $currency ${amount.toStringAsFixed(2)}\n${AppLocalizations.of(context)!.youOwe} $currency ${amount.toStringAsFixed(2)}',
              Icons.arrow_downward,
              () => _handleSplitSelection(
                context,
                SplitOption.theyPaidFullYouOweFull,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.expenseAmount} $currency ${amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          '${selectedFriends.length} ${AppLocalizations.of(context)!.friendsSelected}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Text(
          '${AppLocalizations.of(context)!.splitMethod} :',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSplitOption(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSplitSelection(BuildContext context, SplitOption option) {
    List<SplitModel> splits = [];

    switch (option) {
      case SplitOption.youPaidFullTheyOweHalf:
        // You paid full amount, each friend owes their portion
        final perPersonShare = amount / (selectedFriends.length + 1);
        for (var friend in selectedFriends) {
          if (friend.userRef != null) {
            splits.add(
              SplitModel(
                friendRef: friend.userRef!,
                amount: perPersonShare,
                owedAmount: perPersonShare,
              ),
            );
          }
        }
        break;

      case SplitOption.theyPaidFullYouOweHalf:
        // Friend paid full, you owe your portion
        final perPersonShare = amount / (selectedFriends.length + 1);
        for (var friend in selectedFriends) {
          if (friend.userRef != null) {
            splits.add(
              SplitModel(
                friendRef: friend.userRef!,
                amount: -perPersonShare,
                paidAmount: amount / selectedFriends.length,
                owedAmount: 0,
              ),
            );
          }
        }
        break;

      case SplitOption.youPaidFullTheyOweFull:
        // You paid full, friends owe entire amount split between them
        final perPersonShare = amount / selectedFriends.length;
        for (var friend in selectedFriends) {
          if (friend.userRef != null) {
            splits.add(
              SplitModel(
                friendRef: friend.userRef!,
                amount: perPersonShare,
                owedAmount: perPersonShare,
              ),
            );
          }
        }
        break;

      case SplitOption.theyPaidFullYouOweFull:
        // Friend paid full, you owe entire amount
        for (var friend in selectedFriends) {
          if (friend.userRef != null) {
            splits.add(
              SplitModel(
                friendRef: friend.userRef!,
                amount: -amount / selectedFriends.length,
                paidAmount: amount / selectedFriends.length,
                owedAmount: 0,
              ),
            );
          }
        }
        break;
    }

    Navigator.pop(context, splits);
  }
}
