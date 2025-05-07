// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splithawk/src/core/error/custom_error.dart';

class AuthRepository {
  final fbAuth.FirebaseAuth firebaseAuth;
  AuthRepository({required this.firebaseAuth});

  Stream<fbAuth.User?> get user {
    final isVerified = firebaseAuth.currentUser?.emailVerified ?? false;

    if (isVerified) {}
    return firebaseAuth.userChanges();
  }

  Future<fbAuth.UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    firebaseAuth.setSettings(appVerificationDisabledForTesting: true);
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //send email verification
      await firebaseAuth.currentUser!.sendEmailVerification();
      print("Verification email sent");

      return userCredential;
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred during sign-up',
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'unknown',
        plugin: 'firebase_auth',
      );
    }
  }

  Future<void> reloadVerification() async {
    try {
      await firebaseAuth.currentUser?.reload();
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred during user reload',
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'unknown',
        plugin: 'firebase_auth',
      );
    }
  }

  Future<fbAuth.UserCredential?> signInWithGoogle() async {
    try {
      print('Google sign-in started');

      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw CustomError(
          message:
              'Google authentication failed: Missing access token or ID token',
          code: 'google_auth_failed',
          plugin: 'google_sign_in',
        );
      }

      final oAuthCredential = fbAuth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        oAuthCredential,
      );
      print('Google sign-in successful: ${userCredential.user?.email}');
      return userCredential;
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred during Google sign-in',
        code: e.code,
        plugin: e.plugin,
      );
    } on PlatformException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred with Google Sign-In',
        code: e.code ?? 'platform_error',
        plugin: 'google_sign_in',
      );
    } catch (e) {
      throw CustomError(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'unknown',
        plugin: 'google_sign_in',
      );
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred during sign-in',
        code: e.code,
        plugin: e.plugin,
      );
    }
  }

  Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required fbAuth.RecaptchaVerifier recaptchaVerifier,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw error;
        },
        codeSent: (verificationId, resendToken) {
          // Handle the code sent event
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on fbAuth.FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> verifyPhoneNumberWithCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final phoneAuthCredential = fbAuth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await firebaseAuth.signInWithCredential(phoneAuthCredential);
    } on fbAuth.FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> resendVerificationCode({
    required String phoneNumber,
    required fbAuth.RecaptchaVerifier recaptchaVerifier,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw error;
        },
        codeSent: (verificationId, resendToken) {
          // Handle the code sent event
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on fbAuth.FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> verifyPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final phoneAuthCredential = fbAuth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await firebaseAuth.signInWithCredential(phoneAuthCredential);
    } on fbAuth.FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred while resetting password',
        code: e.code,
        plugin: e.plugin,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred during sign-out',
        code: e.code,
        plugin: e.plugin,
      );
    }
  }

  Future<fbAuth.UserCredential> linkWithGoogle() async {
    try {
      // Check if user is signed in
      final currentUser = firebaseAuth.currentUser;

      // Start Google sign-in flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw CustomError(
          message: 'Google sign-in was canceled',
          code: 'sign-in-canceled',
          plugin: 'google_sign_in',
        );
      }

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw CustomError(
          message:
              'Google authentication failed: Missing access token or ID token',
          code: 'google_auth_failed',
          plugin: 'google_sign_in',
        );
      }

      // Create Google credential
      final googleCredential = fbAuth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Link the Google credential to the current user
      return await currentUser!.linkWithCredential(googleCredential);
    } on fbAuth.FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use' ||
          e.code == 'email-already-in-use') {
        throw CustomError(
          message: 'This Google account is already linked to another account',
          code: e.code,
          plugin: e.plugin,
        );
      }
      throw CustomError(
        message: e.message ?? 'Failed to link Google account',
        code: e.code,
        plugin: e.plugin,
      );
    } on PlatformException catch (e) {
      throw CustomError(
        message: e.message ?? 'An error occurred with Google Sign-In',
        code: e.code ?? 'platform_error',
        plugin: 'google_sign_in',
      );
    } catch (e) {
      throw CustomError(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'unknown',
        plugin: 'google_sign_in',
      );
    }
  }

  Future<fbAuth.UserCredential> linkWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final currentUser = firebaseAuth.currentUser;

      // Create email credential
      final emailCredential = fbAuth.EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      // Link the email credential to the current user
      return await currentUser!.linkWithCredential(emailCredential);
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        message: e.message ?? 'Failed to link email/password account',
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'unknown',
        plugin: 'firebase_auth',
      );
    }
  }

  Future<fbAuth.User?> unlinkProvider(String providerId) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw CustomError(
          message: 'You need to be signed in to unlink accounts',
          code: 'no-user-signed-in',
          plugin: 'firebase_auth',
        );
      }

      // Check if user has multiple providers
      final providers = currentUser.providerData;
      if (providers.length <= 1) {
        throw CustomError(
          message: 'Cannot unlink the only authentication method',
          code: 'single-provider',
          plugin: 'firebase_auth',
        );
      }

      return await currentUser.unlink(providerId);
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        message: e.message ?? 'Failed to unlink provider',
        code: e.code,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'unknown',
        plugin: 'firebase_auth',
      );
    }
  }

  List<String> getLinkedProviders() {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      return [];
    }

    return currentUser.providerData
        .map((userInfo) => userInfo.providerId)
        .toList();
  }
}
