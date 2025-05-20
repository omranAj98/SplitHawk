part of 'user_cubit.dart';

class UserState extends Equatable {
  final RequestStatus requestStatus;
  final CustomError? error;
  final UserModel? user;
  final Timer? timer;
  const UserState({
    required this.requestStatus,
    required this.error,
    this.user,
    this.timer,
  });

  factory UserState.initial() {
    return const UserState(
      requestStatus: RequestStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object?> get props => [requestStatus, error, user, timer];

  @override
  bool get stringify => true;

  UserState copyWith({
    RequestStatus? requestStatus,
    CustomError? error,
    UserModel? user,
    Timer? timer,
  }) {
    return UserState(
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
      user: user ?? this.user,
      timer: timer ?? this.timer,
    );
  }
}
