import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/expense/expense_cubit.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/routes/names.dart';
import 'package:splithawk/src/core/validators/app_text_validators.dart';
import 'package:splithawk/src/models/expense/expense_model.dart';
import 'package:splithawk/src/models/expense/split_model.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:splithawk/src/models/friend_model.dart';
import 'package:splithawk/src/views/expense_split_options_screen.dart';

class AddExpenseModel extends StatefulWidget {
  const AddExpenseModel({super.key});

  @override
  State<AddExpenseModel> createState() => _AddExpenseModelState();
}

class _AddExpenseModelState extends State<AddExpenseModel> {
  final TextEditingController _expenseNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<FriendDataModel> _selectedFriendIds = [];
  bool _isEqualSplit = true;

  @override
  void dispose() {
    _expenseNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SplitModel>? splits = [];
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    void splittingOptions() async {
      var validate = formKey.currentState?.validate();
      if (validate == false) return;
      final double? amount = double.tryParse(_amountController.text);
      final userRef = context.read<UserCubit>().state.user!.userRef;
      if (amount == null || userRef == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
        return;
      }

      splits = await context.pushNamed(
        AppRoutesName.splitOptions,
        extra: {'amount': amount, 'selectedFriends': _selectedFriendIds},
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add Expense",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Expense Name Field
            TextFormField(
              validator:
                  (value) => AppTextValidators.validateName(context, value),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.name,
              autocorrect: false,
              // onFieldSubmitted: (value) => setState(() {}),
              onEditingComplete: () => setState(() {}),
              controller: _expenseNameController,
              decoration: InputDecoration(
                labelText: "Expense Name",

                hintText: "Dinner, Movies, Groceries...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Amount Field
            TextFormField(
              validator:
                  (value) => AppTextValidators.validateAmount(context, value),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              onEditingComplete: () => setState(() {}),
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: "Amount",
                prefixText: "\$ ",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Split Options
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
                onPressed:
                    _selectedFriendIds.isEmpty ||
                            _expenseNameController.text.isEmpty ||
                            _amountController.text.isEmpty
                        ? null
                        : splittingOptions,
                child: Text(
                  "Select Split Options",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Friends Selection
            Text(
              "Select Friends",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            BlocBuilder<FriendCubit, FriendState>(
              builder: (context, state) {
                if (state.requestStatus == RequestStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final friends = state.friendsData;
                if (friends.isEmpty) {
                  return Center(
                    child: Text(
                      "No friends yet. Add friends to split expenses.",
                    ),
                  );
                }

                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      final isSelected = _selectedFriendIds.contains(friend);

                      return CheckboxListTile(
                        title: Text(friend.friendName),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedFriendIds.add(friend);
                            } else {
                              _selectedFriendIds.remove(friend);
                            }
                          });
                        },
                        secondary: CircleAvatar(
                          child: Text(friend.friendName.toUpperCase()),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Create Expense Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed:
                    _selectedFriendIds.isEmpty ||
                            _expenseNameController.text.isEmpty ||
                            _amountController.text.isEmpty
                        ? null
                        : _createExpense,
                child: Text('Create Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createExpense() async {
    // Get the entered amount
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    final userRef = context.read<UserCubit>().state.user!.userRef;

    // Navigate to split options screen
    if (userRef != null) {
      final List<SplitModel>? splits = await Navigator.push<List<SplitModel>>(
        context,
        MaterialPageRoute(
          builder:
              (context) => ExpenseSplitOptionsScreen(
                amount: amount,
                selectedFriends: _selectedFriendIds,
                userRef: userRef,
              ),
        ),
      );

      // If user cancelled selection, return
      if (splits == null) return;

      // Create expense object
      final newExpense = ExpenseModel(
        expenseName: _expenseNameController.text,
        amount: amount,
        currency: "USD",
        createdBy: userRef,
        participantsRef:
            _selectedFriendIds
                .map((p) => p.userRef)
                .where((ref) => ref != null)
                .cast<DocumentReference<Object?>>()
                .toList(),
      );

      // Uncomment and use this line to save the expense with splits
      await context.read<ExpenseCubit>().addExpense(newExpense, splits);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Expense created successfully')));
      Navigator.pop(context);
    }
  }
}
