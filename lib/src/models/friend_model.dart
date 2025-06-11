// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:splithawk/src/models/balance_model.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class FriendModel extends Equatable {
  final DocumentReference? userRef;
  final String friendId;
  final String? nickname;
  final String? status;
  final DateTime? friendedAt;
  final DateTime? updatedAt;
  final bool? isBlocked;
  final bool? isFavorite;

  final List<BalanceModel>? balances;

  FriendModel({
    String? friendId,
    this.userRef,
    this.nickname,
    this.status = "friends",
    this.friendedAt,
    this.updatedAt,
    this.isBlocked= false,
    this.isFavorite = false,
    

    this.balances,
  }) : friendId = friendId ?? uuid.v4();

  @override
  List<Object?> get props {
    return [
      friendId,
      userRef,
      status,
      friendedAt,
      updatedAt,
      isBlocked,
      isFavorite,
      nickname,

      balances,
    ];
  }

  FriendModel copyWith({
    String? friendId,
    DocumentReference? userRef,
    String? nickname,
    String? status,
    DateTime? friendedAt,
    DateTime? updatedAt,
    bool? isBlocked,
    bool? isFavorite,

    List<BalanceModel>? balances,
  }) {
    return FriendModel(
      friendId: friendId ?? this.friendId,
      userRef: userRef ?? this.userRef,
      nickname: nickname ?? this.nickname,
      status: status ?? this.status,
      friendedAt: friendedAt ?? this.friendedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isBlocked: isBlocked ?? this.isBlocked,
      isFavorite: isFavorite ?? this.isFavorite,

      balances: balances ?? this.balances,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      'userRef': userRef,
      'status': status,
      'nickname': nickname,
      'friendedAt': friendedAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isBlocked': isBlocked,
      'isFavorite': isFavorite,
    };
  }

  // factory FriendModel.fromFirestoreMap(Map<String, dynamic> map) {
  //   return FriendModel(
  //     userRef:
  //         map['userRef'] != null ? map['userRef'] as DocumentReference : null,
  //     status: map['status'] != null ? map['status'] as String : 'pending',
  //     nickname: map['nickname'] != null ? map['nickname'] as String : null,
  //     friendedAt:
  //         map['friendedAt'] != null
  //             ? (map['friendedAt'] is Timestamp
  //                 ? (map['friendedAt'] as Timestamp).toDate()
  //                 : DateTime.parse(map['friendedAt'] as String))
  //             : null,
  //     updatedAt:
  //         map['updatedAt'] != null
  //             ? (map['updatedAt'] is Timestamp
  //                 ? (map['updatedAt'] as Timestamp).toDate()
  //                 : DateTime.parse(map['updatedAt'] as String))
  //             : null,
  //     isBlocked: map['isBlocked'] != null ? map['isBlocked'] as bool : false,
  //     isFavorite: map['isFavorite'] != null ? map['isFavorite'] as bool : false,
  //   );
  // }

  factory FriendModel.fromFriendDocAndBalanceModel(
    DocumentSnapshot doc,
    List<BalanceModel> balanceModel,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    return FriendModel(
      friendId: doc.id,
      userRef: data['userRef'],
      status: data['status'] ?? 'pending',
      nickname: data['nickname'] != null ? data['nickname'] as String : null,
      friendedAt:
          data['friendedAt'] != null
              ? (data['friendedAt'] is Timestamp
                  ? (data['friendedAt'] as Timestamp).toDate()
                  : DateTime.parse(data['friendedAt'] as String))
              : null,
      updatedAt:
          data['updatedAt'] != null
              ? (data['updatedAt'] is Timestamp
                  ? (data['updatedAt'] as Timestamp).toDate()
                  : DateTime.parse(data['updatedAt'] as String))
              : null,
      isBlocked: data['isBlocked'] != null ? data['isBlocked'] as bool : false,
      isFavorite:
          data['isFavorite'] != null ? data['isFavorite'] as bool : false,

      balances: balanceModel,
    );
  }

  @override
  bool get stringify => true;
}
