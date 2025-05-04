// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthChangeEvent extends AuthEvent {
  final fbAuth.User? user;
  const AuthChangeEvent({this.user});
  @override
  List<Object?> get props => [user];
}

class AuthSignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInWithEmailEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpWithEmailEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  const AuthSignUpWithEmailEvent({
    required this.name,
    required this.email,
    required this.password,
  });
  @override
  List<Object?> get props => [name, email, password];
}

class AuthSignInWithGoogleEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AuthResetPasswordEvent extends AuthEvent {
  final String email;
  const AuthResetPasswordEvent({required this.email});
  @override
  List<Object?> get props => [email];
}

class AuthReloadVerificationEvent extends AuthEvent {
  const AuthReloadVerificationEvent();
  @override
  List<Object?> get props => [];
}

// class AuthSignInWithPhoneEvent extends AuthEvent {
//   final String phoneNumber;
//   final fbAuth.RecaptchaVerifier recaptchaVerifier;
//   const AuthSignInWithPhoneEvent({
//     required this.phoneNumber,
//     required this.recaptchaVerifier,
//   });
//   @override
//   List<Object?> get props => [phoneNumber, recaptchaVerifier];
// }

// class AuthSignInWithAppleEvent extends AuthEvent {
//   final String email;
//   final String password;
//   AuthSignInWithAppleEvent({
//     required this.email,
//     required this.password,
//   });
//   @override
//   List<Object?> get props => [email, password];
// }

class AuthSignOutEvent extends AuthEvent {}
