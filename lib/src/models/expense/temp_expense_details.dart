// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:splithawk/src/core/enums/split_options.dart';

class TempExpenseDetails extends Equatable {
  String? name;
  String? description;
  String? category;
  String? currency;
  SplitOptions? splitOption;
  double? amount;
  DateTime? date;
  TempExpenseDetails({
    this.name,
    this.description,
    this.category,
    this.currency,
    this.splitOption,
    this.amount,
    this.date,
  });

  TempExpenseDetails copyWith({
    String? name,
    String? description,
    String? category,
    String? currency,
    SplitOptions? splitOption,
    double? amount,
    DateTime? date,
  }) {
    return TempExpenseDetails(
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      splitOption: splitOption ?? this.splitOption,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props {
    return [name, description, category, currency, splitOption, amount, date];
  }

  @override
  bool get stringify => true;
}
