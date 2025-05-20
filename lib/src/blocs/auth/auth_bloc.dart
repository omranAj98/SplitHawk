import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart'; 
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/user_model.dart';
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
        if (event.user != state.user) {
          print("user has been changed");
          bool isVerified = event.user!.emailVerified ? true : false;
          if (isVerified) userRepository.verifyEmail(event.user!.email!);
          print("user verified:  $isVerified");

          emit(
            state.copyWith(
              authStatus: AuthStatus.authenticated,
              user: event.user,
            ),
          );
        }
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
        if (existedUserModel == null||
            existedUserModel.isRegistered == false) {
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
              photoUrl: '',
              isRegistered: true,
              isDeleted: false,
              isBlocked: false,
              receivingNotifications: false,
              isPhoneVerified: false,
              isEmailVerified: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              lastActivity: DateTime(1970, 1, 1),
              recentLogin: DateTime.now(),
              totalTransactions: 0,
              totalBalance: 0.0,
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
          emit(state.copyWith(authStatus: AuthStatus.unauthenticated,error: CustomError(
            message: 'User already exists',
            code: 'user-exists',
            plugin: 'auth_bloc',
          )));
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
            photoUrl: user.photoURL.toString(),
            isRegistered: true,
            isDeleted: false,
            isBlocked: false,
            receivingNotifications: false,
            isPhoneVerified: false,
            isEmailVerified: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            lastActivity: DateTime(1970, 1, 1),
            recentLogin: DateTime.now(),
            totalTransactions: 0,
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

    // Account linking event handlers
    on<AuthLinkWithGoogleEvent>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      try {
        // Check if user is authenticated
        if (state.user == null) {
          throw CustomError(
            message: 'You must be logged in to link accounts',
            code: 'not-authenticated',
            plugin: 'auth_bloc',
          );
        }

        // Check if Google is already linked
        final providers = authRepository.getLinkedProviders();
        if (providers.contains('google.com')) {
          emit(
            state.copyWith(
              authStatus: AuthStatus.linkingFailed,
              error: CustomError(
                message: 'Google account is already linked',
                code: 'already-linked',
                plugin: 'auth_bloc',
              ),
            ),
          );
          return;
        }

        // Link with Google
        final userCredential = await authRepository.linkWithGoogle();

        // Update user model if needed
        if (userCredential.user != null) {
          // Update user in Firestore if needed
          final userModel = await userRepository.getSelfUser();
          final updatedUserModel = userModel!.copyWith(
            signupMethod: 'google,email and password',
          );
          await userRepository.updateUser(
            updatedUserModel: updatedUserModel,
            userModel: userModel,
          );
        }

        emit(
          state.copyWith(
            authStatus: AuthStatus.linkingSuccess,
            user: userCredential.user,
          ),
        );
      } on CustomError catch (e) {
        // Special handling for account conflicts
        if (e.code == 'credential-already-in-use' ||
            e.code == 'email-already-in-use') {
          emit(
            state.copyWith(authStatus: AuthStatus.accountConflict, error: e),
          );
        } else {
          emit(state.copyWith(authStatus: AuthStatus.linkingFailed, error: e));
        }
      } catch (e) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.linkingFailed,
            error: CustomError(
              message: 'An unexpected error occurred: ${e.toString()}',
              code: 'unknown',
              plugin: 'auth_bloc',
            ),
          ),
        );
      }
    });

    on<AuthLinkWithEmailEvent>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      try {
        if (state.user == null) {
          emit(
            state.copyWith(
              authStatus: AuthStatus.linkingFailed,
              error: CustomError(
                message: 'You must be logged in to link accounts',
                code: 'not-authenticated',
                plugin: 'auth_bloc',
              ),
            ),
          );
        }

        // Check if email/password is already linked
        final providers = authRepository.getLinkedProviders();
        if (providers.contains('password')) {
          emit(
            state.copyWith(
              authStatus: AuthStatus.linkingFailed,
              error: CustomError(
                message: 'Email/password is already linked',
                code: 'already-linked',
                plugin: 'auth_bloc',
              ),
            ),
          );
          return;
        }

        // Link with email/password
        final userCredential = await authRepository.linkWithEmailAndPassword(
          email: state.user!.email ?? '',
          password: event.password,
        );

        // Update user model if needed
        if (userCredential.user != null) {
          // Update user in Firestore if needed
          final userModel = await userRepository.getSelfUser();
          final updatedUserModel = userModel!.copyWith(
            signupMethod: 'google,email and password',
          );
          await userRepository.updateUser(
            updatedUserModel: updatedUserModel,
            userModel: userModel,
          );
        }

        emit(
          state.copyWith(
            authStatus: AuthStatus.linkingSuccess,
            user: userCredential.user,
          ),
        );
      } on CustomError catch (e) {
        // Special handling for account conflicts
        if (e.code == 'credential-already-in-use' ||
            e.code == 'email-already-in-use') {
          emit(
            state.copyWith(authStatus: AuthStatus.accountConflict, error: e),
          );
        } else {
          emit(state.copyWith(authStatus: AuthStatus.linkingFailed, error: e));
        }
      } catch (e) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.linkingFailed,
            error: CustomError(
              message: 'An unexpected error occurred: ${e.toString()}',
              code: 'unknown',
              plugin: 'auth_bloc',
            ),
          ),
        );
      }
    });

    on<AuthUnlinkProviderEvent>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      try {
        // Check if user is authenticated
        if (state.user == null) {
          throw CustomError(
            message: 'You must be logged in to unlink accounts',
            code: 'not-authenticated',
            plugin: 'auth_bloc',
          );
        }

        // Check available providers
        final providers = authRepository.getLinkedProviders();
        if (providers.length <= 1) {
          emit(
            state.copyWith(
              authStatus: AuthStatus.unlinkingFailed,
              error: CustomError(
                message: 'Cannot remove the only authentication method',
                code: 'single-provider',
                plugin: 'auth_bloc',
              ),
            ),
          );
          return;
        }

        // Unlink provider
        final user = await authRepository.unlinkProvider(event.providerId);

        // Update user model if needed
        if (user != null) {
          final remainingProviders = authRepository.getLinkedProviders();
          String signupMethod = 'multiple';

          // If only one provider remains, update the signup method accordingly
          if (remainingProviders.length == 1) {
            if (remainingProviders.contains('google.com')) {
              signupMethod = 'google';
            } else if (remainingProviders.contains('password')) {
              signupMethod = 'email and password';
            }
          }

          final userModel = await userRepository.getSelfUser();
          final updatedUserModel = userModel!.copyWith(
            signupMethod: signupMethod,
          );
          await userRepository.updateUser(
            updatedUserModel: updatedUserModel,
            userModel: userModel,
          );
        }

        emit(
          state.copyWith(authStatus: AuthStatus.unlinkingSuccess, user: user),
        );
      } on CustomError catch (e) {
        emit(state.copyWith(authStatus: AuthStatus.unlinkingFailed, error: e));
      } catch (e) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.unlinkingFailed,
            error: CustomError(
              message: 'An unexpected error occurred: ${e.toString()}',
              code: 'unknown',
              plugin: 'auth_bloc',
            ),
          ),
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
