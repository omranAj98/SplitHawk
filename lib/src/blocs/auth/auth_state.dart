// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  authenticated,
  unauthenticated,
  error,
}

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final CustomError? error;
  final fbAuth.User? user;
  const AuthState({required this.authStatus, this.error, this.user});

  factory AuthState.initial() {
    return AuthState(authStatus: AuthStatus.initial);
  }

  @override
  List<Object?> get props => [authStatus, user, error];

  @override
  bool get stringify => true;

  AuthState copyWith({
    AuthStatus? authStatus,
    fbAuth.User? user,
    CustomError? error,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
