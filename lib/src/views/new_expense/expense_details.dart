import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
import 'package:splithawk/src/views/new_expense/currency_search_dialog.dart';
import 'package:splithawk/src/widgets/collapsible_date_picker.dart';

class ExpenseDetails extends StatefulWidget {
  const ExpenseDetails({super.key});

  @override
  State<ExpenseDetails> createState() => ExpenseDetailsState();
}

String _getCurrencySymbol(String currency) {
  switch (currency) {
    case "USD":
      return "\$ ";
    case "EUR":
      return "€ ";
    case "GBP":
      return "£ ";
    case "JPY":
      return "¥ ";
    case "CAD":
      return "C\$ ";
    case "AUD":
      return "A\$ ";
    case "CNY":
      return "¥ ";
    case "HKD":
      return "HK\$ ";
    case "NZD":
      return "NZ\$ ";
    case "CHF":
      return "CHF ";
    case "SEK":
      return "kr ";
    case "NOK":
      return "kr ";
    case "DKK":
      return "kr ";
    case "SGD":
      return "S\$ ";
    case "INR":
      return "₹ ";
    case "BRL":
      return "R\$ ";
    case "ZAR":
      return "R ";
    case "RUB":
      return "₽ ";
    case "MXN":
      return "MX\$ ";
    case "AED":
      return "AED ";
    default:
      return "";
  }
}

class ExpenseDetailsState extends State<ExpenseDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController expenseNameController;
  late TextEditingController amountController;
  late FocusNode expenseNameFocusNode;
  late FocusNode amountFocusNode;
  String selectedCurrency = "USD";

  // Expanded list of available currencies
  final List<String> currencies = [
    "USD",
    "SYP"
        "TRY",
    "QAR",
    "SAR",
    "KWD",
    "OMR",
    "BHD",
    "YER",
    "JOD",
    "LBP",
    "EGP",
    "TND",
    "MAD",
    "DZD",
    "LYD",
    "IQD",
    "SDG",
    "AFN",
    "PKR",
    "BDT",
    "LKR",
    "MMK",
    "THB",
    "VND",
    "MYR",
    "IDR",
    "PHP",
    "SGD",
    "EUR",
    "GBP",
    "JPY",
    "CAD",
    "AUD",
    "CNY",
    "HKD",
    "NZD",
    "CHF",
    "SEK",
    "NOK",
    "DKK",
    "SGD",
    "INR",
    "BRL",
    "ZAR",
    "RUB",
    "MXN",
    "AED",
  ];

  bool isDatePickerExpanded = false;

  @override
  void initState() {
    super.initState();
    expenseNameController = TextEditingController();
    amountController = TextEditingController();
    expenseNameFocusNode = FocusNode();
    amountFocusNode = FocusNode(canRequestFocus: true);
    // Initialize the ExpenseCubit with today's date and default currency
    context.read<ExpenseCubit>().updateExpenseCurrency(selectedCurrency);
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

  // Show currency search dialog
  void _showCurrencySearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CurrencySearchDialog(
            currencies: currencies,
            selectedCurrency: selectedCurrency,
            onCurrencySelected: (currency) {
              setState(() {
                selectedCurrency = currency;
              });
              context.pop();
              context.read<ExpenseCubit>().updateExpenseCurrency(currency);
            },
          ),
    );
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

            // Amount Field with Currency Dropdown
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Currency Selector with Search
                SizedBox(
                  width: 100,
                  child: InkWell(
                    onTap: _showCurrencySearchDialog,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        prefixText: _getCurrencySymbol(selectedCurrency),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
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
            // Date Picker with label
            CollapsibleDatePicker(
              onDateChanged: (value) {
                context.read<ExpenseCubit>().updateExpenseDate(value);
              },
            ),

            const SizedBox(height: 8),

            // Collapsible Date Picker
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
      AppSnackBar.show(
        context,
        type: SnackBarType.error,
        message: AppLocalizations.of(context)!.addExpenseAmount,
      );

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
    final amount =
        context.read<ExpenseCubit>().state.tempExpenseDetails?.amount;

    if (amount == null || amount <= 0) {
      AppSnackBar.show(
        context,
        type: SnackBarType.error,
        message: AppLocalizations.of(context)!.invalidAmount,
      );
      return;
    }

    final userRef = context.read<UserCubit>().state.user!.userRef;
    final selectedFriends = context.read<FriendCubit>().state.selectedFriends;
    final expenseName =
        context.read<ExpenseCubit>().state.tempExpenseDetails?.name ?? '';
    final splitOption =
        context.read<ExpenseCubit>().state.tempExpenseDetails?.splitOption ??
        SplitOptions.youPaidFullSplitEqual;

    final newExpense = ExpenseModel(
      expenseName: expenseName,
      amount: amount,
      currency: selectedCurrency, // Use the selected currency
      createdBy: userRef,
      participantsRef:
          [userRef] +
          selectedFriends!
              .map((p) => p.userRef)
              .where((ref) => ref != null)
              .cast<DocumentReference<Object?>>()
              .toList(),
    );

    context.read<ExpenseCubit>().addExpense(
      newExpense,
      selectedFriends.first,
      splitOption,
    );

    _resetFormFields(context);
    context.read<FriendCubit>().resetSelectedFriends();
    context.read<ExpenseCubit>().resetTempExpenseDetails();

    AppSnackBar.show(
      context,
      type: SnackBarType.success,
      message: AppLocalizations.of(context)!.addExpenseSuccess,
      duration: const Duration(seconds: 2),
    );

    context.goNamed(AppRoutesName.main);
  }

  void _resetFormFields(BuildContext context) {
    context.read<ExpenseCubit>().resetTempExpenseDetails();
    expenseNameController.clear();
    amountController.clear();
    setState(() {
      selectedCurrency = "USD";
    });
    context.read<ExpenseCubit>().updateExpenseCurrency("USD");
  }
}
