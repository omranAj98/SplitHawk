import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/core/enums/split_options.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/names.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:splithawk/src/models/expense/split_model.dart';

class ExpenseSplitOptionsScreen extends StatelessWidget {
  final double amount;
  final List<FriendDataModel> selectedFriends;
  final String currency;

  const ExpenseSplitOptionsScreen({
    super.key,
    required this.amount,
    required this.selectedFriends,
    this.currency = '\$',
  });

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
              AppLocalizations.of(context)!.youPaidSplitEqual,
              '${AppLocalizations.of(context)!.userOwesYou("Eng.Omran")} $currency ${(amount / 2).toStringAsFixed(2)}',
              Icons.arrow_forward,
              () => _handleSplitSelection(
                context,
                SplitOptions.youPaidFullSplitEqual,
              ),
            ),
            const SizedBox(height: 16),

            _buildSplitOption(
              context,
              AppLocalizations.of(context)!.youOwedFullAmount,
              '${AppLocalizations.of(context)!.userOwesYou("Eng.Omran")} $currency ${amount.toStringAsFixed(2)}',
              Icons.arrow_upward,
              () => _handleSplitSelection(
                context,
                SplitOptions.youPaidFullTheyOweFull,
              ),
            ),
            const SizedBox(height: 16),
            _buildSplitOption(
              context,
              AppLocalizations.of(context)!.theyPaidFullSplitEqual("Eng.Omran"),
              '${AppLocalizations.of(context)!.youOweUser("Eng.Omran")} $currency ${(amount / 2).toStringAsFixed(2)}',
              Icons.arrow_back,
              () => _handleSplitSelection(
                context,
                SplitOptions.theyPaidFullSplitEqual,
              ),
            ),
            const SizedBox(height: 16),
            _buildSplitOption(
              context,
              AppLocalizations.of(context)!.theyPaidFullYouOweFull("Eng.Omran"),
              '${AppLocalizations.of(context)!.youOweUser("Eng.Omran")} $currency ${amount.toStringAsFixed(2)}',
              Icons.arrow_downward,
              () => _handleSplitSelection(
                context,
                SplitOptions.theyPaidFullYouOweFull,
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: _buildMoreOption(
                context,
                AppLocalizations.of(context)!.moreOptions,
                () => context.replaceNamed(
                  AppRoutesName.splitOptionsUnequal,
                  extra: {
                    'amount': amount,
                    'selectedFriends': selectedFriends,
                  },
                ),
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

  Widget _buildMoreOption(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
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

  void _handleSplitSelection(BuildContext context, SplitOptions option) {
    context.pop(option);
  }
}
