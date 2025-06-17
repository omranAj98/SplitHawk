import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SplitModel extends Equatable {
  final String? id;
  final DocumentReference friendRef;
  final double amount;
  final double? paidAmount;
  final double? owedAmount;
  final bool isSettled;
  final DateTime? settledAt;
  final DateTime? createdAt;

  const SplitModel({
    this.id,
    required this.friendRef,
    required this.amount,
    this.paidAmount = 0,
    this.owedAmount,
    this.isSettled = false,
    this.settledAt,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    friendRef,
    amount,
    paidAmount,
    owedAmount,
    isSettled,
    settledAt,
    createdAt,
  ];

  factory SplitModel.fromFirestoreDoc(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return SplitModel(
      id: doc.id,
      friendRef: data['friendRef'],
      amount: (data['amount'] as num).toDouble(),
      paidAmount: (data['paidAmount'] as num?)?.toDouble(),
      owedAmount: (data['owedAmount'] as num?)?.toDouble(),
      isSettled: data['isSettled'] ?? false,
      settledAt:
          data['settledAt'] != null
              ? (data['settledAt'] as Timestamp).toDate()
              : null,
      createdAt:
          (data['createdAt'] is Timestamp)
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'friendRef': friendRef,
      'amount': amount,
      'paidAmount': paidAmount,
      'owedAmount': owedAmount,
      'isSettled': isSettled,
      'settledAt': Timestamp.fromDate(settledAt!),
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  SplitModel copyWith({
    String? id,
    DocumentReference? friendRef,
    double? amount,
    double? paidAmount,
    double? owedAmount,
    bool? isSettled,
    DateTime? settledAt,
    DateTime? createdAt,
  }) {
    return SplitModel(
      id: id ?? this.id,
      friendRef: friendRef ?? this.friendRef,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      owedAmount: owedAmount ?? this.owedAmount,
      isSettled: isSettled ?? this.isSettled,
      settledAt: settledAt ?? this.settledAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
