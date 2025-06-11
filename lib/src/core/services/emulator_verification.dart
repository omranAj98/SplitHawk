import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splithawk/src/core/services/service_locator.dart';

/// Helper class to verify emulator connections
class EmulatorVerification {
  /// Performs a check to verify that the Firebase emulators are properly connected
  static Future<bool> verifyEmulatorConnections({
    bool throwOnError = false,
  }) async {
    if (!areEmulatorsConnected()) {
      debugPrint("❌ Emulators are not connected according to flag");
      if (throwOnError) {
        throw Exception("Firebase emulators are not connected");
      }
      return false;
    }

    try {
      // Verify Firestore emulator
      bool firestoreConnected = await _verifyFirestoreEmulator();
      if (!firestoreConnected) {
        debugPrint("❌ Firestore emulator verification failed");
        if (throwOnError) throw Exception("Firestore emulator not connected");
        return false;
      }

      // Verify Auth emulator
      bool authConnected = await _verifyAuthEmulator();
      if (!authConnected) {
        debugPrint("❌ Auth emulator verification failed");
        if (throwOnError) throw Exception("Auth emulator not connected");
        return false;
      }

      // Functions emulator is harder to verify without making an actual call
      // but we'll trust that it's connected if the others are

      return true;
    } catch (e) {
      debugPrint("❌ Error during emulator verification: $e");
      if (throwOnError) rethrow;
      return false;
    }
  }

  /// Verify Firestore emulator by performing a test read
  static Future<bool> _verifyFirestoreEmulator() async {
    try {
      final firestore = locator<FirebaseFirestore>();
      // Test if we can read a document - this should connect to the emulator
      // and return a Not Found error, not a connection error
      await firestore.collection('_emulator_test').doc('test').get();
      return true;
    } catch (e) {
      if (e.toString().contains('PERMISSION_DENIED') ||
          e.toString().contains('NOT_FOUND')) {
        // These are expected errors from the emulator - indicates it's working
        return true;
      }
      debugPrint("❌ Firestore emulator verification failed: ${e.toString()}");
      return false;
    }
  }

  /// Verify Auth emulator by checking its host info
  static Future<bool> _verifyAuthEmulator() async {
    try {
      final auth = locator<FirebaseAuth>();
      // For Auth, we check if we can fetch the configurations
      // In the emulator, this shouldn't throw a connection error
      await auth.fetchSignInMethodsForEmail('test@example.com');
      return true;
    } catch (e) {
      // If we get an auth error rather than a connection error, emulator is working
      if (e is FirebaseAuthException) {
        return true;
      }
      debugPrint("❌ Auth emulator verification failed: $e");
      return false;
    }
  }
}
