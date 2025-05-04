import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/user_model/user_model.dart';
import 'package:splithawk/src/repositories/auth_repository.dart';
import 'package:splithawk/src/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  StreamSubscription? authSubscription;
  AuthBloc({
    required this.authRepository,
    required this.userRepository,
    this.authSubscription,
  }) : super(AuthState.initial()) {
    authSubscription = authRepository.user.listen((fbAuth.User? user) {
      add(AuthChangeEvent(user: user));
    });

    on<AuthChangeEvent>((event, emit) {
      if (event.user != null) {
        print("user has been changed");
        bool isVerified = event.user!.emailVerified ?? false;
        if (isVerified) userRepository.verifyEmail(event.user!.email!);
        print("user verified:  $isVerified");

        emit(
          state.copyWith(
            authStatus: AuthStatus.authenticated,
            user: event.user,
          ),
        );
      } else {
        emit(
          state.copyWith(authStatus: AuthStatus.unauthenticated, user: null),
        );
      }
    });

    on<AuthSignUpWithEmailEvent>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      try {
        final existedUserModel = await userRepository.checkExistingUser(
          event.email,
        );
        if (existedUserModel == null) {
          final userCredential = await authRepository
              .signUpWithEmailAndPassword(
                email: event.email,
                password: event.password,
              );
          print(userCredential.user!.displayName);
          if (userCredential.user != null) {
            UserModel userModel = UserModel(
              fullName: event.name,
              email: event.email,
              phoneNo: '',
              signupMethod: 'email and password',
              photoUrl: null,
              isActive: true,
              isDeleted: false,
              isBlocked: false,
              receivingNotifications: false,
              isPhoneVerified: false,
              isEmailVerified: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              lastActivity: null,
              recentLogin: DateTime.now(),
              totalTransactions: 0,
              totalFriends: 0,
              totalBalance: 0,
            );
            emit(
              state.copyWith(
                authStatus: AuthStatus.authenticated,
                user: userCredential.user,
              ),
            );
            return await userRepository.createUser(userModel);
          }
        } else {
          emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
        }
      } on CustomError catch (e) {
        emit(
          state.copyWith(authStatus: AuthStatus.error, user: null, error: e),
        );
      } catch (e) {
        CustomError error = e as CustomError;
        emit(
          state.copyWith(
            authStatus: AuthStatus.error,
            user: null,
            error: error,
          ),
        );
      }
    });

    on<AuthSignInWithEmailEvent>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      try {
        await authRepository.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        if (state.user != null) {
          emit(state.copyWith(authStatus: AuthStatus.authenticated));
        } else {
          emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
        }
      } on CustomError catch (e) {
        emit(
          state.copyWith(authStatus: AuthStatus.error, user: null, error: e),
        );
        rethrow;
      }
    });

    on<AuthSignInWithGoogleEvent>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      try {
        final fbAuth.UserCredential? userCredential =
            await authRepository.signInWithGoogle();
        if (userCredential!.user != null) {
          final user = userCredential.user!;
          final userModel = UserModel(
            email: user.email!,
            fullName: user.displayName ?? user.email!,
            phoneNo: user.phoneNumber ?? '',
            signupMethod: 'google',
            photoUrl: user.photoURL,
            isActive: true,
            isDeleted: false,
            isBlocked: false,
            receivingNotifications: false,
            isPhoneVerified: false,
            isEmailVerified: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            lastActivity: null,
            recentLogin: DateTime.now(),
            totalTransactions: 0,
            totalFriends: 0,
            totalBalance: 0,
          );
          UserModel? existingUserModel = await userRepository.checkExistingUser(
            user.email!,
          );
          if (existingUserModel == null) {
            await userRepository.createUser(userModel);
          } else if (existingUserModel.isEmailVerified == false) {
            await userRepository.verifyEmail(user.uid);
          }

          emit(
            state.copyWith(authStatus: AuthStatus.authenticated, user: user),
          );
        } else {
          emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
        }
      } on CustomError catch (e) {
        emit(
          state.copyWith(authStatus: AuthStatus.error, user: null, error: e),
        );
        rethrow;
      }
    });

    on<AuthResetPasswordEvent>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      try {
        final result = await authRepository.resetPassword(email: event.email);

        emit(state.copyWith(authStatus: AuthStatus.success));
      } on CustomError catch (e) {
        emit(
          state.copyWith(authStatus: AuthStatus.error, user: null, error: e),
        );
      }
    });

    on<AuthReloadVerificationEvent>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      try {
        await authRepository.reloadVerification();

        emit(state.copyWith(authStatus: AuthStatus.success));
      } on CustomError catch (e) {
        emit(
          state.copyWith(authStatus: AuthStatus.error, user: null, error: e),
        );
      }
    });

    // on<AuthSignInWithPhoneEvent>((event, emit) async {
    //   emit(state.copyWith(authStatus: AuthStatus.loading));
    //   try {
    //     final fbAuth.User? user = await authRepository.signInWithPhoneNumber(
    //       phoneNumber: event.phoneNumber,
    //       recaptchaVerifier: event.recaptchaVerifier,
    //     );
    //     if (user != null) {
    //       emit(
    //         state.copyWith(authStatus: AuthStatus.authenticated, user: user),
    //       );
    //     } else {
    //       emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
    //     }
    //   } catch (e) {
    //     CustomError error = e as CustomError;
    //     emit(state.copyWith(authStatus: AuthStatus.error, user: null,error: e));
    //   }
    // });

    // on<AuthSignInWithAppleEvent>((event, emit) async {
    //   emit(state.copyWith(authStatus: AuthStatus.loading));
    //   try {
    //     final fbAuth.User? user = await authRepository.signInWithApple();
    //     if (user != null) {
    //       await userRepository.createUser(userCredential: user);
    //       emit(
    //         state.copyWith(authStatus: AuthStatus.authenticated, user: user),
    //       );
    //     } else {
    //       emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
    //     }
    //   } catch (e) {
    //     emit(state.copyWith(authStatus: AuthStatus.error, user: null));
    //   }
    // });

    on<AuthSignOutEvent>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      try {
        await authRepository.signOut();
        emit(
          state.copyWith(authStatus: AuthStatus.unauthenticated, user: null),
        );
      } catch (e) {
        emit(state.copyWith(authStatus: AuthStatus.error, user: null));
      }
    });
  }
}
