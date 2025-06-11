// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'expense_cubit.dart';

enum ExpenseActionType { add, delete, update, fetch }

class ExpenseState extends Equatable {
  final RequestStatus requestStatus;
  final ExpenseActionType? actionType;
  
  final List<ExpenseDataModel>? expenseData;
  final CustomError error;

  const ExpenseState({
    required this.requestStatus,
    this.actionType,
    this.expenseData,
    required this.error,
  });

  factory ExpenseState.initial() {
    return ExpenseState(
      requestStatus: RequestStatus.initial,
      error: CustomError(),
      expenseData: [],
    );
  }
  @override
  List<Object?> get props => [requestStatus, actionType, error, expenseData];

  ExpenseState copyWith({
    RequestStatus? requestStatus,
    ExpenseActionType? actionType,
    List<ExpenseDataModel>? expenseData,
    CustomError? error,
  }) {
    return ExpenseState(
      requestStatus: requestStatus ?? this.requestStatus,
      actionType: actionType ?? this.actionType,
      expenseData: expenseData ?? this.expenseData,
      error: error ?? this.error,
    );
  }

  @override
  bool get stringify => true;
}
