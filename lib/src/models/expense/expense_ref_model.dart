import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ExpenseRefModel extends Equatable {
  final String id;
  final DocumentReference expenseRef;
  final bool? isSettled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ExpenseRefModel({
    required this.id,
    required this.expenseRef,
    this.isSettled,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, expenseRef, isSettled, createdAt, updatedAt];

  factory ExpenseRefModel.fromFirestoreDoc(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ExpenseRefModel(
      id: doc.id,
      expenseRef: data['expenseRef'],
      isSettled: data['isSettled'] ?? false,
      createdAt:
          (data['createdAt'] is Timestamp)
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.parse(data['createdAt']),
      updatedAt:
          (data['updatedAt'] is Timestamp)
              ? (data['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'expenseRef': expenseRef,
      'isSettled': isSettled ?? false,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }
}
