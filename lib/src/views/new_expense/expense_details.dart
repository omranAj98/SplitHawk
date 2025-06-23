import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/expense/expense_cubit.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/enums/split_options.dart';
import 'package:splithawk/src/core/routes/names.dart';
import 'package:splithawk/src/core/validators/app_text_validators.dart';
import 'package:splithawk/src/models/expense/expense_model.dart';
import 'package:splithawk/src/models/expense/split_model.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:splithawk/src/views/new_expense/expense_split_options_screen.dart';

class ExpenseDetails extends StatefulWidget {
  ExpenseDetails({super.key});
  // final FocusNode expensesFieldsFocusNode = FocusNode();
  // final FocusNode expensesFieldsFocusNode = FocusNode(
  //   debugLabel: 'expensesFieldsFocusNode',
  // );

  @override
  State<ExpenseDetails> createState() => _AddExpenseModelState();
}

class _AddExpenseModelState extends State<ExpenseDetails> {
  final TextEditingController _expenseNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _expenseNameFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode(canRequestFocus: true);
  SplitOptions _splitOption = SplitOptions.youPaidFullSplitEqual;

  final bool _isEqualSplit = true;

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

    void splittingOptionsFor1FriendOnly() async {
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
      final selectedFriendsList =
          context.read<FriendCubit>().state.selectedFriends;

      SplitOptions? Option = await context.pushNamed(
        AppRoutesName.splitOptions,
        extra: {'amount': amount, 'selectedFriends': selectedFriendsList},
      );
      if (Option == null) return;
      _splitOption = Option;
      setState(() {});
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
            TextFormField(
              validator:
                  (value) => AppTextValidators.validateName(context, value),
              textInputAction: TextInputAction.next,
              onFieldSubmitted:
                  (_) => FocusScope.of(context).requestFocus(_amountFocusNode),
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.name,
              focusNode: _expenseNameFocusNode,
              autofocus: true,
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
              focusNode: _amountFocusNode,
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
              child: BlocBuilder<FriendCubit, FriendState>(
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                    ),
                    onPressed:
                        state.selectedFriends!.isEmpty ||
                                _expenseNameController.text.isEmpty ||
                                _amountController.text.isEmpty
                            ? null
                            : splittingOptionsFor1FriendOnly,
                    child: Text(
                      "Select Split Options",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Friends Selection
            const SizedBox(height: 24),

            // Create Expense Button
            BlocBuilder<FriendCubit, FriendState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed:
                        state.selectedFriends!.isEmpty ||
                                _expenseNameController.text.isEmpty ||
                                _amountController.text.isEmpty
                            ? null
                            : _createEqualExpenseFor1FriendOnly,
                    child: Text('Create Expense'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createEqualExpenseFor1FriendOnly() async {
    // Get the entered amount
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    final userRef = context.read<UserCubit>().state.user!.userRef;
    final selectedFriends = context.read<FriendCubit>().state.selectedFriends;

    // Navigate to split options screen
    if (userRef != null) {
      // Create expense object
      final newExpense = ExpenseModel(
        expenseName: _expenseNameController.text,
        amount: amount,
        currency: "USD",
        createdBy: userRef,
        participantsRef:
            [userRef] +
            selectedFriends!
                .map((p) => p.userRef)
                .where((ref) => ref != null)
                .cast<DocumentReference<Object?>>()
                .toList(),
      );

      // Uncomment and use this line to save the expense with splits
      await context.read<ExpenseCubit>().addExpense(
        newExpense,
        selectedFriends.first,
        _splitOption,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Expense created successfully')));
      context.replaceNamed(AppRoutesName.main);
    }
  }
}
