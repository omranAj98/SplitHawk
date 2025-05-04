// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'user_cubit.dart';

class UserState extends Equatable {
  final RequestStatus requestStatus;
  final CustomError error;
  final UserModel? user;
  const UserState({
    required this.requestStatus,
    required this.error,
    this.user,
  });

  factory UserState.initial() {
    return const UserState(
      requestStatus: RequestStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [requestStatus, error, user ?? ''];

  @override
  bool get stringify => true;

  UserState copyWith({
    RequestStatus? requestStatus,
    CustomError? error,
    UserModel? user,
  }) {
    return UserState(
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}
