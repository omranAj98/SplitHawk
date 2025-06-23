// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'expense_cubit.dart';

enum ExpenseActionType { add, delete, update, fetch }

class ExpenseState extends Equatable {
  final RequestStatus requestStatus;
  final ExpenseActionType? actionType;

  final ExpenseDataModel? newExpenseData;

  final List<ExpenseDataModel>? expenseData;
  final CustomError error;

  const ExpenseState({
    required this.requestStatus,
    this.actionType,
    this.expenseData,
    this.newExpenseData,
    required this.error,
  });

  factory ExpenseState.initial() {
    return ExpenseState(
      requestStatus: RequestStatus.initial,
      error: CustomError(),
      newExpenseData: null,
      expenseData: [],
    );
  }
  @override
  List<Object?> get props => [
    requestStatus,
    actionType,
    error,
    newExpenseData,
    expenseData,
  ];

  ExpenseState copyWith({
    RequestStatus? requestStatus,
    ExpenseActionType? actionType,
    List<ExpenseDataModel>? expenseData,
    ExpenseDataModel? newExpenseData,
    CustomError? error,
  }) {
    return ExpenseState(
      requestStatus: requestStatus ?? this.requestStatus,
      actionType: actionType ?? this.actionType,
      expenseData: expenseData ?? this.expenseData,
      newExpenseData: newExpenseData ?? this.newExpenseData,
      error: error ?? this.error,
    );
  }

  @override
  bool get stringify => true;
}
