// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class UserModel extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNo;
  final String? photoUrl;
  final String? signupMethod;
  final bool? isPhoneVerified;
  final bool? isEmailVerified;
  final bool? isActive;
  final bool? isDeleted;
  final bool? isBlocked;
  final bool? receivingNotifications;
  final int? totalTransactions;
  final int? totalFriends;
  final int? totalBalance;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastActivity;
  final DateTime? recentLogin;

  UserModel({
    String? id,
    required this.email,
    required this.fullName,
    this.phoneNo,
    this.photoUrl,
    this.signupMethod,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.isActive,
    this.isDeleted,
    this.isBlocked,
    this.receivingNotifications,
    this.totalTransactions,
    this.totalFriends,
    this.totalBalance,
    this.createdAt,
    this.updatedAt,
    this.lastActivity,
    this.recentLogin,
  }) : id = id ?? uuid.v4();

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNo,
    String? photoUrl,
    String? signupMethod,
    bool? isPhoneVerified,
    bool? isEmailVerified,
    bool? isActive,
    bool? isDeleted,
    bool? isBlocked,
    bool? receivingNotifications,
    int? totalTransactions,
    int? totalFriends,
    int? totalBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActivity,
    DateTime? recentLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNo: phoneNo ?? this.phoneNo,
      photoUrl: photoUrl ?? this.photoUrl,
      signupMethod: signupMethod ?? this.signupMethod,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      isBlocked: isBlocked ?? this.isBlocked,
      receivingNotifications:
          receivingNotifications ?? this.receivingNotifications,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      totalFriends: totalFriends ?? this.totalFriends,
      totalBalance: totalBalance ?? this.totalBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActivity: lastActivity ?? this.lastActivity,
      recentLogin: recentLogin ?? this.recentLogin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNo,
      'photoUrl': photoUrl,
      'signupMethod': signupMethod,
      'isPhoneVerified': isPhoneVerified,
      'isEmailVerified': isEmailVerified,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'isBlocked': isBlocked,
      'receivingNotifications': receivingNotifications,
      'totalTransactions': totalTransactions,
      'totalFriends': totalFriends,
      'totalBalance': totalBalance,
      'createdAt': createdAt!.toIso8601String(),
      'updatedAt': updatedAt!.toIso8601String(),
      'lastActivity': lastActivity!.toIso8601String(), // Convert DateTime to String
      'recentLogin': recentLogin!.toIso8601String(), // Convert DateTime to String
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
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
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      isDeleted: map['isDeleted'] != null ? map['isDeleted'] as bool : null,
      isBlocked: map['isBlocked'] != null ? map['isBlocked'] as bool : null,
      receivingNotifications:
          map['receivingNotifications'] != null
              ? map['receivingNotifications'] as bool
              : null,
      totalTransactions:
          map['totalTransactions'] != null
              ? map['totalTransactions'] as int
              : null,
      totalFriends:
          map['totalFriends'] != null ? map['totalFriends'] as int : null,
      totalBalance:
          map['totalBalance'] != null ? map['totalBalance'] as int : null,
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
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      email,
      fullName,
      phoneNo ?? '',
      photoUrl ?? '',
      signupMethod ?? '',
      isPhoneVerified ?? false,
      isEmailVerified ?? false,
      isActive ?? false,
      isDeleted ?? false,
      isBlocked ?? false,
      receivingNotifications ?? false,
      totalTransactions ?? 0,
      totalFriends ?? 0,
      totalBalance ?? 0,
      createdAt ?? DateTime(1970, 1, 1),
      updatedAt ?? DateTime(1970, 1, 1),
      lastActivity ?? DateTime(1970, 1, 1),
      recentLogin ?? DateTime(1970, 1, 1),
    ];
  }
}
