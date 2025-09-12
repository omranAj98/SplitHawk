import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class SplitModel extends Equatable {
  final String id;
  final DocumentReference userRef;
  final double? paidAmount;
  final double owedAmount;
  final DocumentReference owedToUserRef;
  final bool isSettled;
  final DateTime? settledAt;
  final DateTime? createdAt;

  final String userName;
  final String owedToName;

  SplitModel({
    String? id,
    required this.userRef,
    this.paidAmount = 0,
    required this.owedAmount,
    required this.owedToUserRef,
    this.isSettled = false,
    this.settledAt,
    this.createdAt,

    required this.userName,
    required this.owedToName,
  }) : id = id ?? uuid.v4();

  @override
  List<Object?> get props => [
    id,
    userRef,
    paidAmount,
    owedAmount,
    owedToUserRef,
    isSettled,
    settledAt,
    createdAt,
    userName,
    owedToName,
  ];

  factory SplitModel.fromFirestoreDoc({required DocumentSnapshot doc}) {
    Map data = doc.data() as Map<String, dynamic>;
    return SplitModel(
      id: doc.id,
      userRef: data['userRef'] as DocumentReference,
      paidAmount: (data['paidAmount'] as num?)?.toDouble(),
      owedAmount: (data['owedAmount'] as num).toDouble(),
      owedToUserRef: data['owedToUserRef'] as DocumentReference,
      isSettled: data['isSettled'] ?? false,
      settledAt:
          data['settledAt'] != null
              ? (data['settledAt'] as Timestamp).toDate()
              : null,
      createdAt:
          (data['createdAt'] is Timestamp)
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.parse(data['createdAt']),

      userName: '',
      owedToName: '',
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'userRef': userRef,
      'owedToUserRef': owedToUserRef,
      'paidAmount': paidAmount,
      'owedAmount': owedAmount,
      'isSettled': isSettled,
      'settledAt':
          (isSettled) ? settledAt ?? FieldValue.serverTimestamp() : null,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  SplitModel copyWith({
    String? id,
    DocumentReference? userRef,
    DocumentReference? owedToUserRef,
    double? paidAmount,
    double? owedAmount,
    bool? isSettled,
    DateTime? settledAt,
    DateTime? createdAt,

    String? userName,
    String? owedToName,
  }) {
    return SplitModel(
      id: id ?? this.id,
      userRef: userRef ?? this.userRef,
      owedToUserRef: owedToUserRef ?? this.owedToUserRef,
      paidAmount: paidAmount ?? this.paidAmount,
      owedAmount: owedAmount ?? this.owedAmount,
      isSettled: isSettled ?? this.isSettled,
      settledAt: settledAt ?? this.settledAt,
      createdAt: createdAt ?? this.createdAt,

      userName: userName ?? this.userName,
      owedToName: owedToName ?? this.owedToName,
    );
  }
}
