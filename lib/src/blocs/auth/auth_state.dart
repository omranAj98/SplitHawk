// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  authenticated,
  unauthenticated,
  error,
  linkingSuccess,
  linkingFailed,
  unlinkingSuccess,
  unlinkingFailed,
  accountConflict,
}

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final CustomError? error;
  final fbAuth.User? user;
  final List<String> signInMethods;

  const AuthState({
    required this.authStatus,
    this.error,
    this.user,
    this.signInMethods = const [],
  });

  factory AuthState.initial() {
    return const AuthState(authStatus: AuthStatus.initial);
  }

  @override
  List<Object?> get props => [authStatus, user, error, signInMethods];

  @override
  bool get stringify => true;

  AuthState copyWith({
    AuthStatus? authStatus,
    fbAuth.User? user,
    CustomError? error,
    List<String>? signInMethods,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      error: error ?? this.error,
      signInMethods: signInMethods ?? this.signInMethods,
    );
  }
}
