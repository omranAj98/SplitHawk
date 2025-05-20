// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'friend_cubit.dart';

enum FriendRequestStatus {
  initial,
  loading,
  addingSuccess,
  removingSuccess,
  blockingSuccess,
  unblockingSuccess,
  updatingSuccess,
  error,
}

class FriendState extends Equatable {
  final FriendRequestStatus requestStatus;
  final List<FriendModel> friends;
  final CustomError error;
  FriendState({
    required this.requestStatus,
    required this.friends,
    required this.error,
  });

  factory FriendState.initial() {
    return FriendState(
      requestStatus: FriendRequestStatus.initial,
      friends: [],
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [requestStatus, friends, error];

  FriendState copyWith({
    FriendRequestStatus? requestStatus,
    List<FriendModel>? friends,
    CustomError? error,
  }) {
    return FriendState(
      requestStatus: requestStatus ?? this.requestStatus,
      friends: friends ?? this.friends,
      error: error ?? this.error,
    );
  }
}
