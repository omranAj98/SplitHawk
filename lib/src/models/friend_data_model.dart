import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:splithawk/src/models/balance_model.dart';
import 'package:splithawk/src/models/friend_model.dart';
import 'package:splithawk/src/models/user_model.dart';

/// A model that combines friend relationship data with user profile data
/// for easier access in the UI and state management
class FriendDataModel extends Equatable {
  // Relationship properties (from FriendModel)
  final String friendId;
  final DocumentReference? userRef;
  final String friendName;
  final String status;
  final DateTime? friendedAt;
  final DateTime? updatedAt;
  final bool isBlocked;
  final bool isFavorite;
  final List<BalanceModel> friendBalances;

  // Profile properties (from UserModel)
  final String email;
  final String fullName;
  final String? phoneNo;
  final String? photoUrl;

  const FriendDataModel({
    required this.friendId,
    this.userRef,
    required this.friendName,
    required this.status,
    this.friendedAt,
    this.updatedAt,
    this.isBlocked = false,
    this.isFavorite = false,
    required this.friendBalances,

    required this.email,
    required this.fullName,
    this.phoneNo,
    this.photoUrl,
  });

  /// Create a FriendWithProfileModel from separate FriendModel and UserModel
  factory FriendDataModel.fromModels({
    required FriendModel friendModel,
    required UserModel userModel,
  }) {
    return FriendDataModel(
      friendId: friendModel.friendId,
      userRef: friendModel.userRef,
      friendName: friendModel.nickname ?? userModel.fullName,
      status: friendModel.status ?? 'friends',
      friendedAt: friendModel.friendedAt,
      updatedAt: friendModel.updatedAt,
      isBlocked: friendModel.isBlocked ?? false,
      isFavorite: friendModel.isFavorite ?? false,
      friendBalances: friendModel.balances ?? [],

      email: userModel.email,
      fullName: userModel.fullName,
      phoneNo: userModel.phoneNo,
      photoUrl: userModel.photoUrl,
    );
  }

  /// Convert to a map for persistence if needed
  Map<String, dynamic> toMap() {
    return {
      'friendId': friendId,
      'userRef': userRef,
      'status': status,
      'friendName': friendName,
      'friendedAt': friendedAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isBlocked': isBlocked,
      'isFavorite': isFavorite,

      'email': email,
      'fullName': fullName,
      'phoneNo': phoneNo,
      'photoUrl': photoUrl,
    };
  }

  /// Create a new instance with updated properties
  FriendDataModel copyWith({
    String? friendId,
    DocumentReference? userRef,
    String? friendName,
    String? status,
    DateTime? friendedAt,
    DateTime? updatedAt,
    bool? isBlocked,
    bool? isFavorite,
    List<BalanceModel>? friendBalances,

    String? email,
    String? fullName,
    String? phoneNo,
    String? photoUrl,
  }) {
    return FriendDataModel(
      friendId: friendId ?? this.friendId,
      userRef: userRef ?? this.userRef,
      friendName: friendName ?? this.friendName,
      status: status ?? this.status,
      friendedAt: friendedAt ?? this.friendedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isBlocked: isBlocked ?? this.isBlocked,
      isFavorite: isFavorite ?? this.isFavorite,
      friendBalances: this.friendBalances,

      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNo: phoneNo ?? this.phoneNo,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [
    friendId,
    userRef,
    friendName,
    status,
    friendedAt,
    updatedAt,
    isBlocked,
    isFavorite,
    friendBalances,

    email,
    fullName,
    phoneNo,
    photoUrl,
  ];
}
