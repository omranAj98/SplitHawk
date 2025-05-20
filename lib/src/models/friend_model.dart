// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class FriendModel extends Equatable {
  final DocumentReference? userRef;
  final String id;
  final String? status;
  final DateTime? friendedAt;
  final DateTime? updatedAt;
  final bool? isBlocked;
  final bool? isFavorite;

  FriendModel({
    String? id,
    this.userRef,
    this.status,
    this.friendedAt,
    this.updatedAt,
    this.isBlocked,
    this.isFavorite,
  }) : id = id ?? uuid.v4();

  @override
  List<Object?> get props {
    return [id, userRef, status, friendedAt, updatedAt, isBlocked, isFavorite];
  }

  FriendModel copyWith({
    String? id,
    DocumentReference? userRef,
    String? status,
    DateTime? friendedAt,
    DateTime? updatedAt,
    bool? isBlocked,
    bool? isFavorite,
  }) {
    return FriendModel(
      id: id ?? this.id,
      userRef: userRef ?? this.userRef,
      status: status ?? this.status,
      friendedAt: friendedAt ?? this.friendedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isBlocked: isBlocked ?? this.isBlocked,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userRef': userRef,
      'status': status,
      'friendedAt': friendedAt,
      'updatedAt': updatedAt,
      'isBlocked': isBlocked,
      'isFavorite': isFavorite,
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      userRef:
          map['userRef'] != null ? map['userRef'] as DocumentReference : null,
      status: map['status'] != null ? map['status'] as String : 'pending',
      friendedAt:
          map['friendedAt'] != null
              ? (map['friendedAt'] is Timestamp
                  ? (map['friendedAt'] as Timestamp).toDate()
                  : DateTime.parse(map['friendedAt'] as String))
              : null,
      updatedAt:
          map['updatedAt'] != null
              ? (map['updatedAt'] is Timestamp
                  ? (map['updatedAt'] as Timestamp).toDate()
                  : DateTime.parse(map['updatedAt'] as String))
              : null,
      isBlocked: map['isBlocked'] != null ? map['isBlocked'] as bool : false,
      isFavorite: map['isFavorite'] != null ? map['isFavorite'] as bool : false,
    );
  }

  factory FriendModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FriendModel(
      id: doc.id,
      userRef: data['userRef'],
      status: data['status'] ?? 'pending',
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
    );
  }

  @override
  bool get stringify => true;

  String fromJson(String source) => json.encode(toMap());

  String toJson() => json.encode(toMap());
  factory FriendModel.fromJson(String source) =>
      FriendModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
