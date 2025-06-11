import 'package:cloud_firestore/cloud_firestore.dart';

class BalanceModel {
  final DocumentReference? docRef;
  final String currency;
  final double netAmount;
  final DateTime updatedAt;

  BalanceModel({
    this.docRef,
    required this.currency,
    required this.netAmount,
    required this.updatedAt,
  });

  factory BalanceModel.fromFirebaseDocument(DocumentSnapshot map) {
    final data = map.data() as Map<String, dynamic>?;
    return BalanceModel(
      docRef: map.reference,
      currency: data!['currency'] as String? ?? 'USD',
      netAmount: data['netAmount'] as double? ?? 0.0,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'currency': currency,
      'netAmount': FieldValue.increment(netAmount),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
