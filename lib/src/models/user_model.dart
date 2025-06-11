// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:splithawk/src/models/balance_model.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class UserModel extends Equatable {
  final String id;
  final DocumentReference? userRef;
  final String email;
  final String fullName;
  final String? phoneNo;
  final String? photoUrl;
  final String? signupMethod;
  final bool? isPhoneVerified;
  final bool? isEmailVerified;
  final bool? isRegistered;
  final bool? isDeleted;
  final bool? isBlocked;
  final bool? receivingNotifications;
  final int? totalTransactions;
  final DateTime? createdAt;
  final DateTime? lastActivity;
  final DateTime? recentLogin;

  final List<BalanceModel>? balance;

  UserModel({
    String? id,
    this.userRef,
    required this.email,
    required this.fullName,
    this.phoneNo = '',
    this.photoUrl = '',
    this.signupMethod = '',
    this.isPhoneVerified = false,
    this.isEmailVerified = false,
    this.isRegistered = false,
    this.isDeleted = false,
    this.isBlocked = false,
    this.receivingNotifications = false,
    this.totalTransactions = 0,
    this.createdAt,
    this.lastActivity,
    this.recentLogin,

    this.balance,
  }) : id = id ?? uuid.v4();

  UserModel copyWith({
    String? id,
    DocumentReference? userRef,
    String? email,
    String? fullName,
    String? phoneNo,
    String? photoUrl,
    String? signupMethod,
    bool? isPhoneVerified,
    bool? isEmailVerified,
    bool? isRegistered,
    bool? isDeleted,
    bool? isBlocked,
    bool? receivingNotifications,
    int? totalTransactions,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActivity,
    DateTime? recentLogin,

    List<BalanceModel>? balance,
  }) {
    return UserModel(
      id: id ?? this.id,
      userRef: userRef ?? this.userRef,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNo: phoneNo ?? this.phoneNo,
      photoUrl: photoUrl ?? this.photoUrl,
      signupMethod: signupMethod ?? this.signupMethod,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isRegistered: isRegistered ?? this.isRegistered,
      isDeleted: isDeleted ?? this.isDeleted,
      isBlocked: isBlocked ?? this.isBlocked,
      receivingNotifications:
          receivingNotifications ?? this.receivingNotifications,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      createdAt: createdAt ?? this.createdAt, 
      lastActivity: lastActivity ?? this.lastActivity,
      recentLogin: recentLogin ?? this.recentLogin,

      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNo,
      'photoUrl': photoUrl,
      'signupMethod': signupMethod,
      'isPhoneVerified': isPhoneVerified,
      'isEmailVerified': isEmailVerified,
      'isRegistered': isRegistered,
      'isDeleted': isDeleted,
      'isBlocked': isBlocked,
      'receivingNotifications': receivingNotifications,
      'totalTransactions': totalTransactions,
      'createdAt': createdAt?.toIso8601String()?? FieldValue.serverTimestamp(),
      'lastActivity': FieldValue.serverTimestamp(),
      'recentLogin': recentLogin?.toIso8601String()??FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromUserDocAndBalanceModel({
    required DocumentSnapshot userDoc,
    List<BalanceModel>? balanceList,
  }) {
    final data = userDoc.data() as Map<String, dynamic>;
    return UserModel(
      id: userDoc.id,
      userRef: userDoc.reference,
      email: data['email'] as String,
      fullName: data['fullName'] as String,
      phoneNo:
          data['phoneNumber'] != null ? data['phoneNumber'] as String : null,
      photoUrl: data['photoUrl'] != null ? data['photoUrl'] as String : null,
      signupMethod:
          data['signupMethod'] != null ? data['signupMethod'] as String : null,
      isPhoneVerified:
          data['isPhoneVerified'] != null
              ? data['isPhoneVerified'] as bool
              : null,
      isEmailVerified:
          data['isEmailVerified'] != null
              ? data['isEmailVerified'] as bool
              : null,
      isRegistered:
          data['isRegistered'] != null ? data['isRegistered'] as bool : null,
      isDeleted: data['isDeleted'] != null ? data['isDeleted'] as bool : null,
      isBlocked: data['isBlocked'] != null ? data['isBlocked'] as bool : null,
      receivingNotifications:
          data['receivingNotifications'] != null
              ? data['receivingNotifications'] as bool
              : null,
      totalTransactions:
          data['totalTransactions'] != null
              ? data['totalTransactions'] as int
              : null,

      createdAt:
          (data['createdAt'] is Timestamp)
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.parse(data['createdAt']),
      lastActivity:
          data['lastActivity'] != null
              ? (data['lastActivity'] is Timestamp)
                  ? (data['lastActivity'] as Timestamp).toDate()
                  : DateTime.parse(data['lastActivity'])
              : null,
      recentLogin:
          data['recentLogin'] != null
              ? (data['recentLogin'] is Timestamp)
                  ? (data['recentLogin'] as Timestamp).toDate()
                  : DateTime.parse(data['recentLogin'])
              : null,

      balance: balanceList,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      userRef ?? '',
      email,
      fullName,
      phoneNo ?? '',
      photoUrl ?? '',
      signupMethod ?? '',
      isPhoneVerified ?? false,
      isEmailVerified ?? false,
      isRegistered ?? false,
      isDeleted ?? false,
      isBlocked ?? false,
      receivingNotifications ?? false,
      totalTransactions ?? 0,
      createdAt ?? DateTime(1970, 1, 1),
      lastActivity ?? DateTime(1970, 1, 1),
      recentLogin ?? DateTime(1970, 1, 1),
      balance ?? <BalanceModel>[],
    ];
  }
}
