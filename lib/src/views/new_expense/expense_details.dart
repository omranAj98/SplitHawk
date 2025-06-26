import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/expense/expense_cubit.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/enums/split_options.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/names.dart';
import 'package:splithawk/src/core/validators/app_text_validators.dart';
import 'package:splithawk/src/core/widgets/app_snack_bar.dart';
import 'package:splithawk/src/models/expense/expense_model.dart';

class ExpenseDetails extends StatefulWidget {
  const ExpenseDetails({Key? key}) : super(key: key);

  @override
  State<ExpenseDetails> createState() => ExpenseDetailsState();
}

class ExpenseDetailsState extends State<ExpenseDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController expenseNameController;
  late TextEditingController amountController;
  late FocusNode expenseNameFocusNode;
  late FocusNode amountFocusNode;

  @override
  void initState() {
    super.initState();
    expenseNameController = TextEditingController(
      text: context.read<ExpenseCubit>().state.tempExpenseDetails?.name ?? '',
    );
    amountController = TextEditingController();
    expenseNameFocusNode = FocusNode();
    amountFocusNode = FocusNode(canRequestFocus: true);
  }

  @override
  void dispose() {
    expenseNameController.dispose();
    amountController.dispose();
    expenseNameFocusNode.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  // Method to submit expense from outside
  void submitExpense() {
    _createEqualExpenseFor1FriendOnly(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Form(
        key: _formKey,
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
                  (_) => FocusScope.of(context).requestFocus(amountFocusNode),
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.name,
              focusNode: expenseNameFocusNode,
              autofocus: true,
              autocorrect: false,

              onChanged:
                  (value) => context.read<ExpenseCubit>().updateExpenseName(
                    value.trim(),
                  ),
              controller: expenseNameController,

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
              focusNode: amountFocusNode,
              controller: amountController,
              onChanged:
                  (value) => context.read<ExpenseCubit>().updateExpenseAmount(
                    double.tryParse(value) ?? 0.0,
                  ),
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
                buildWhen: (previous, current) {
                  return previous.selectedFriends != current.selectedFriends;
                },
                builder: (context, friendState) {
                  return BlocBuilder<ExpenseCubit, ExpenseState>(
                    builder: (context, expenseState) {
                      final splitOption =
                          expenseState.tempExpenseDetails!.splitOption;
                      String splitText;
                      switch (splitOption) {
                        case SplitOptions.youPaidFullSplitEqual:
                          splitText =
                              AppLocalizations.of(context)!.youPaidSplitEqual;
                          break;
                        case SplitOptions.youPaidFullTheyOweFull:
                          splitText =
                              AppLocalizations.of(context)!.youOwedFullAmount;
                          break;
                        case SplitOptions.theyPaidFullSplitEqual:
                          splitText = AppLocalizations.of(
                            context,
                          )!.theyPaidFullSplitEqual('');
                          break;
                        case SplitOptions.theyPaidFullYouOweFull:
                          splitText = AppLocalizations.of(
                            context,
                          )!.theyPaidFullYouOweFull('');
                          break;
                        default:
                          splitText =
                              AppLocalizations.of(context)!.selectSplitOption;
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16),
                        ),
                        onPressed:
                            (friendState.selectedFriends == null ||
                                    friendState.selectedFriends!.isEmpty ||
                                    expenseState.tempExpenseDetails == null ||
                                    expenseState.tempExpenseDetails!.name ==
                                        null ||
                                    expenseState
                                        .tempExpenseDetails!
                                        .name!
                                        .isEmpty ||
                                    expenseState.tempExpenseDetails!.amount ==
                                        null ||
                                    expenseState.tempExpenseDetails!.amount! <=
                                        0)
                                ? null
                                : () => _splittingOptionsFor1FriendOnly(
                                  context,
                                  amountController,
                                ),
                        child: Text(
                          splitText,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Friends Selection
            const SizedBox(height: 24),

            // Create Expense Button
            BlocBuilder<FriendCubit, FriendState>(
              builder: (context, friendState) {
                return SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<ExpenseCubit, ExpenseState>(
                    builder: (context, expenseState) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed:
                            (friendState.selectedFriends == null ||
                                    friendState.selectedFriends!.isEmpty ||
                                    expenseState.tempExpenseDetails == null ||
                                    expenseState.tempExpenseDetails!.name ==
                                        null ||
                                    expenseState
                                        .tempExpenseDetails!
                                        .name!
                                        .isEmpty ||
                                    expenseState.tempExpenseDetails!.amount ==
                                        null ||
                                    expenseState.tempExpenseDetails!.amount! <=
                                        0)
                                ? null
                                : () =>
                                    _createEqualExpenseFor1FriendOnly(context),
                        child: Text(AppLocalizations.of(context)!.addExpense),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _splittingOptionsFor1FriendOnly(
    BuildContext context,
    TextEditingController amountController,
  ) async {
    var validate = _formKey.currentState?.validate();
    if (validate == false) return;

    final double? amount = double.tryParse(amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    final selectedFriendsList =
        context.read<FriendCubit>().state.selectedFriends;

    SplitOptions? option = await context.pushNamed(
      AppRoutesName.splitOptions,
      extra: {'amount': amount, 'selectedFriends': selectedFriendsList},
    );

    if (option == null) return;
    context.read<ExpenseCubit>().updateExpenseSplitOption(option);
  }

  void _createEqualExpenseFor1FriendOnly(BuildContext context) async {
    // Since we don't have direct access to the amount controller now,
    // we'll get the amount from the Cubit
    final amount =
        context.read<ExpenseCubit>().state.tempExpenseDetails?.amount;

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    final userRef = context.read<UserCubit>().state.user!.userRef;
    final selectedFriends = context.read<FriendCubit>().state.selectedFriends;
    final expenseName =
        context.read<ExpenseCubit>().state.tempExpenseDetails?.name ?? '';
    final splitOption =
        context.read<ExpenseCubit>().state.tempExpenseDetails?.splitOption ??
        SplitOptions.youPaidFullSplitEqual;

    // Create expense object
    final newExpense = ExpenseModel(
      expenseName: expenseName,
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

    // Save the expense with splits
    context.read<ExpenseCubit>().addExpense(
      newExpense,
      selectedFriends.first,
      splitOption,
    );

    // Reset all relevant state
    _resetFormFields(context);
    context.read<FriendCubit>().resetSelectedFriends();
    context.read<ExpenseCubit>().resetTempExpenseDetails();

    AppSnackBar.show(
      context,
      type: SnackBarType.success,
      message: AppLocalizations.of(context)!.addExpenseSuccess,
      duration: const Duration(seconds: 2),
    );
    context.replaceNamed(AppRoutesName.main);
  }

  // Reset method now only resets Cubit state, not local controllers
  void _resetFormFields(BuildContext context) {
    context.read<ExpenseCubit>().resetTempExpenseDetails();
    expenseNameController.clear();
    amountController.clear();
  }

  // Add a new method to reset the form fields
}
