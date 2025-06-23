import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class ExpenseModel extends Equatable {
  final String id;
  final DocumentReference? expenseRef;
  final String expenseName;
  final String? description;
  final double amount;
  final String currency;
  final DocumentReference createdBy;
  final DateTime? createdAt;
  final DateTime? expenseDate;
  final bool? isDeleted;
  final String? category;
  final List<DocumentReference> participantsRef;

  ExpenseModel({
    String? id,
    this.expenseRef,
    required this.expenseName,
    this.description,
    required this.amount,
    required this.currency,
    required this.createdBy,
    this.createdAt,
    this.expenseDate,
    this.isDeleted = false,
    this.category,
    required this.participantsRef,
  }) : id = id ?? uuid.v4();

  @override
  List<Object?> get props => [
    id,
    expenseRef,
    expenseName,
    description,
    amount,
    currency,
    createdBy,
    createdAt,
    expenseDate,
    isDeleted,
    category,
    participantsRef,
  ];

  factory ExpenseModel.fromFirestoreDoc(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      expenseRef: doc.reference,
      expenseName: data['expenseName'] ?? '',
      description: data['description'],
      amount: (data['amount'] as num).toDouble(),
      currency: data['currency'] ?? 'USD',
      createdBy: data['createdBy'] as DocumentReference,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isDeleted: data['isDeleted'] ?? false,
      category: data['category'],
      expenseDate: (data['expenseDate'] as Timestamp).toDate(),
      participantsRef: List<DocumentReference>.from(data['participantsRef']),
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'expenseName': expenseName,
      'description': description,
      'amount': amount,
      'currency': currency,
      'createdBy': createdBy,
      'expenseDate': expenseDate ?? FieldValue.serverTimestamp(),
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'isDeleted': isDeleted,
      'category': category,
      'participantsRef': participantsRef,
    };
  }

  ExpenseModel copyWith({
    String? id,
    DocumentReference? expenseRef,
    String? expenseName,
    String? description,
    double? amount,
    String? currency,
    DocumentReference? createdBy,
    DateTime? createdAt,
    DateTime? expenseDate,
    bool? isDeleted,
    String? category,
    List<DocumentReference>? participantsRef,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      expenseRef: expenseRef ?? this.expenseRef,
      expenseName: expenseName ?? this.expenseName,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      expenseDate: expenseDate ?? this.expenseDate,
      isDeleted: isDeleted ?? this.isDeleted,
      category: category ?? this.category,
      participantsRef: participantsRef ?? this.participantsRef,
    );
  }
}
