// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
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
  final double? totalBalance;
  DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastActivity;
  final DateTime? recentLogin;

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
    this.totalBalance = 0.0,
    this.createdAt,
    this.updatedAt,
    this.lastActivity,
    this.recentLogin,
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
    double? totalBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActivity,
    DateTime? recentLogin,
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
      totalBalance: totalBalance ?? this.totalBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActivity: lastActivity ?? this.lastActivity,
      recentLogin: recentLogin ?? this.recentLogin,
    );
  }

  Map<String, dynamic> toMapFirestore() {
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
      'totalBalance': totalBalance,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastActivity': lastActivity?.toIso8601String(),
      'recentLogin': recentLogin?.toIso8601String(),
    };
  }

  factory UserModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return UserModel(
      id: doc.id,
      userRef: doc.reference,
      email: data?['email'] as String,
      fullName: data?['fullName'] as String,
      phoneNo:
          data?['phoneNumber'] != null ? data!['phoneNumber'] as String : null,
      photoUrl: data?['photoUrl'] != null ? data!['photoUrl'] as String : null,
      signupMethod:
          data?['signupMethod'] != null
              ? data!['signupMethod'] as String
              : null,
      isPhoneVerified:
          data?['isPhoneVerified'] != null
              ? data!['isPhoneVerified'] as bool
              : null,
      isEmailVerified:
          data?['isEmailVerified'] != null
              ? data!['isEmailVerified'] as bool
              : null,
      isRegistered:
          data?['isRegistered'] != null ? data!['isRegistered'] as bool : null,
      isDeleted: data?['isDeleted'] != null ? data!['isDeleted'] as bool : null,
      isBlocked: data?['isBlocked'] != null ? data!['isBlocked'] as bool : null,
      receivingNotifications:
          data?['receivingNotifications'] != null
              ? data!['receivingNotifications'] as bool
              : null,
      totalTransactions:
          data?['totalTransactions'] != null
              ? data!['totalTransactions'] as int
              : null,
      totalBalance:
          data?['totalBalance'] != null
              ? data!['totalBalance'] as double
              : null,
      createdAt:
          (data?['createdAt'] is Timestamp)
              ? (data!['createdAt'] as Timestamp).toDate()
              : DateTime.parse(data!['createdAt']),
      updatedAt:
          (data['updatedAt'] is Timestamp)
              ? (data['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(data['updatedAt']),
      lastActivity:
          (data['lastActivity'] is Timestamp)
              ? (data['lastActivity'] as Timestamp).toDate()
              : DateTime.parse(data['lastActivity']),
      recentLogin:
          (data['recentLogin'] is Timestamp)
              ? (data['recentLogin'] as Timestamp).toDate()
              : DateTime.parse(data['recentLogin']),
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      userRef:
          map['userRef'] != null ? map['userRef'] as DocumentReference : null,
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] is Timestamp
                  ? (map['createdAt'] as Timestamp).toDate()
                  : DateTime.parse(map['createdAt'] as String))
              : null,
      updatedAt:
          map['updatedAt'] != null
              ? (map['updatedAt'] is Timestamp
                  ? (map['updatedAt'] as Timestamp).toDate()
                  : DateTime.parse(map['updatedAt'] as String))
              : null,
      lastActivity:
          map['lastActivity'] != null
              ? (map['lastActivity'] is Timestamp
                  ? (map['lastActivity'] as Timestamp).toDate()
                  : DateTime.parse(map['lastActivity'] as String))
              : null,
      recentLogin:
          map['recentLogin'] != null
              ? (map['recentLogin'] is Timestamp
                  ? (map['recentLogin'] as Timestamp).toDate()
                  : DateTime.parse(map['recentLogin'] as String))
              : null,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      phoneNo: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      signupMethod:
          map['signupMethod'] != null ? map['signupMethod'] as String : null,
      isPhoneVerified:
          map['isPhoneVerified'] != null
              ? map['isPhoneVerified'] as bool
              : null,

      isEmailVerified:
          map['isEmailVerified'] != null
              ? map['isEmailVerified'] as bool
              : null,
      isRegistered:
          map['isRegistered'] != null ? map['isRegistered'] as bool : null,
      isDeleted: map['isDeleted'] != null ? map['isDeleted'] as bool : null,
      isBlocked: map['isBlocked'] != null ? map['isBlocked'] as bool : null,
      receivingNotifications:
          map['receivingNotifications'] != null
              ? map['receivingNotifications'] as bool
              : null,
      totalTransactions:
          map['totalTransactions'] != null
              ? map['totalTransactions'] as int
              : 0,
      totalBalance:
          map['totalBalance'] != null ? map['totalBalance'] as double : 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userRef': userRef,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastActivity': lastActivity?.toIso8601String(),
      'recentLogin': recentLogin?.toIso8601String(),
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
      'totalBalance': totalBalance,
    };
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
      totalBalance ?? 0.0,
      createdAt ?? DateTime(1970, 1, 1),
      updatedAt ?? DateTime(1970, 1, 1),
      lastActivity ?? DateTime(1970, 1, 1),
      recentLogin ?? DateTime(1970, 1, 1),
    ];
  }
}
