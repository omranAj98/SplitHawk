// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'friend_cubit.dart';

enum FriendActionType { add, remove, block, unblock, update, fetch }

class FriendState extends Equatable {
  final FriendActionType? actionType;
  final RequestStatus requestStatus;
  final List<FriendModel> friends;
  final List<FriendDataModel> friendsData;
  final List<FriendDataModel>? filteredFriends;
  final List<FriendDataModel>? selectedFriends;
  final FriendDataModel? selectedFriend;
  final CustomError? error;

  const FriendState({
    required this.requestStatus,
    this.actionType,
    required this.friends,
    required this.friendsData,
    this.selectedFriends,
    this.filteredFriends,
    this.selectedFriend,
    required this.error,
  });

  factory FriendState.initial() {
    return FriendState(
      requestStatus: RequestStatus.initial,
      actionType: null,
      friends: [],
      friendsData: [],
      selectedFriends: [],
      filteredFriends: null,
      selectedFriend: null,
      error: null,
    );
  }

  @override
  List<Object?> get props => [
    requestStatus,
    actionType,
    friends,
    friendsData,
    selectedFriends,
    filteredFriends,
    selectedFriend,
    error,
  ];

  FriendState copyWith({
    RequestStatus? requestStatus,
    FriendActionType? actionType,
    List<FriendModel>? friends,
    List<FriendDataModel>? friendsData,
    List<FriendDataModel>? filteredFriends,
    List<FriendDataModel>? selectedFriends,
    FriendDataModel? selectedFriend,
    CustomError? error,
  }) {
    return FriendState(
      requestStatus: requestStatus ?? this.requestStatus,
      actionType: actionType ?? this.actionType,
      friends: friends ?? this.friends,
      friendsData: friendsData ?? this.friendsData,
      filteredFriends: filteredFriends ?? this.filteredFriends,
      selectedFriends: selectedFriends ?? this.selectedFriends,
      selectedFriend: selectedFriend ?? this.selectedFriend,
      error: error ?? this.error,
    );
  }
}
