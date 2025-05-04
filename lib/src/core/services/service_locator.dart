import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splithawk/src/repositories/auth_repository.dart';
import 'package:splithawk/src/repositories/user_repository.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  final isTesting = bool.fromEnvironment('dart.vm.product') == false;

  // Register FirebaseAuth with settings
  locator.registerLazySingleton<FirebaseAuth>(() {
    final firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.setSettings(
      appVerificationDisabledForTesting:
          isTesting, // Disable app verification for testing
    );
    return firebaseAuth;
  });

  // Register FirebaseFirestore
  locator.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Register repositories with injected dependencies
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(firebaseAuth: locator<FirebaseAuth>()),
  );

  locator.registerLazySingleton<UserRepository>(
    () => UserRepository(firebaseFirestore: locator<FirebaseFirestore>()),
  );
}

// Function to update FirebaseAuth language code dynamically
void updateFirebaseAuthLanguage(String languageCode) {
  final firebaseAuth = locator<FirebaseAuth>();
  firebaseAuth.setLanguageCode(languageCode);
}
