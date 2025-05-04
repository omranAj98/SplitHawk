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

  Future<void> reloadVerification() async{
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
}
