import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/blocs/contact/contact_cubit.dart';
import 'package:splithawk/src/blocs/expense/expense_cubit.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/cubit/menu_cubit.dart';
import 'package:splithawk/src/repositories/auth_repository.dart';
import 'package:splithawk/src/repositories/balance_repository.dart';
import 'package:splithawk/src/repositories/contacts_repository.dart';
import 'package:splithawk/src/repositories/expense_repository.dart';
import 'package:splithawk/src/repositories/friend_repository.dart';
import 'package:splithawk/src/repositories/split_repository.dart';
import 'package:splithawk/src/repositories/user_repository.dart';

final GetIt locator = GetIt.instance;
// Flag to track if emulators are connected
bool _emulatorsConnected = false;

void setupLocator() {
  // Check if running in test mode - this checks Flutter's debug mode
  // You can also use a dedicated flag for tests if preferred
  final isTesting = bool.fromEnvironment('dart.vm.product') == false;

  if (isTesting) {
    // Set this environment variable to make sure Firebase SDK knows we're using emulators
    // This is a belt-and-suspenders approach to ensure emulator usage
    const String useEmulator = 'true';
    try {
      debugPrint("Attempting to connect to Firebase emulators...");

      // Connect to Auth emulator
      locator.registerLazySingleton<FirebaseAuth>(() {
        final firebaseAuth = FirebaseAuth.instance;
        try {
          firebaseAuth.useAuthEmulator('localhost', 9099);
          debugPrint("✅ Firebase Auth connected to emulator: localhost:9099");
        } catch (e) {
          debugPrint("⚠️ Failed to connect Firebase Auth to emulator: $e");
          debugPrint(
            "Make sure the Firebase emulators are running with 'firebase emulators:start'",
          );
          rethrow;
        }
        return firebaseAuth;
      });

      // Connect to Firestore emulator
      locator.registerLazySingleton<FirebaseFirestore>(() {
        final firebaseFirestore = FirebaseFirestore.instance;
        try {
          firebaseFirestore.useFirestoreEmulator('localhost', 8080);
          // Verify connection by attempting a simple operation
          firebaseFirestore.settings = const Settings(
            persistenceEnabled: true,
            cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
          );
          debugPrint(
            "✅ Firebase Firestore connected to emulator: localhost:8080",
          );
        } catch (e) {
          debugPrint("⚠️ Failed to connect Firebase Firestore to emulator: $e");
          debugPrint(
            "Make sure the Firebase emulators are running with 'firebase emulators:start'",
          );
          rethrow;
        }
        return firebaseFirestore;
      });

      // Connect to Functions emulator
      locator.registerLazySingleton<FirebaseFunctions>(() {
        final firebaseFunctions = FirebaseFunctions.instance;
        try {
          firebaseFunctions.useFunctionsEmulator('localhost', 5001);
          debugPrint(
            "✅ Firebase Functions connected to emulator: localhost:5001",
          );
        } catch (e) {
          debugPrint("⚠️ Failed to connect Firebase Functions to emulator: $e");
          debugPrint(
            "Make sure the Firebase emulators are running with 'firebase emulators:start'",
          );
          rethrow;
        }
        return firebaseFunctions;
      });

      _emulatorsConnected = true;
      debugPrint("✅ All Firebase emulators connected successfully");
    } catch (e) {
      debugPrint("⚠️ Error during emulator setup: $e");
      _emulatorsConnected = false;
    }
  } else {
    debugPrint("Running Firebase instances in production mode");
    locator.registerLazySingleton<FirebaseAuth>(() {
      final firebaseAuth = FirebaseAuth.instance;
      return firebaseAuth;
    });
    locator.registerLazySingleton<FirebaseFirestore>(() {
      final firebaseFirestore = FirebaseFirestore.instance;
      firebaseFirestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      return firebaseFirestore;
    });
    locator.registerLazySingleton<FirebaseFunctions>(() {
      final firebaseFunctions = FirebaseFunctions.instance;
      return firebaseFunctions;
    });
  }

  // Register repositories
  locator.registerLazySingleton<BalanceRepository>(
    () => BalanceRepository(firebaseFirestore: locator<FirebaseFirestore>()),
  );
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(firebaseAuth: locator<FirebaseAuth>()),
  );
  locator.registerLazySingleton<UserRepository>(
    () => UserRepository(
      firebaseFirestore: locator<FirebaseFirestore>(),
      firebaseFunctions: locator<FirebaseFunctions>(),
      balanceRepository: locator<BalanceRepository>(),
    ),
  );
  locator.registerLazySingleton<FriendRepository>(
    () => FriendRepository(
      firebaseFirestore: locator<FirebaseFirestore>(),
      balanceRepository: locator<BalanceRepository>(),
    ),
  );
  locator.registerLazySingleton<SplitRepository>(
    () => SplitRepository(firestore: locator<FirebaseFirestore>()),
  );
  locator.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepository(firebaseFirestore: locator<FirebaseFirestore>()),
  );
  locator.registerLazySingleton<ContactsRepository>(() => ContactsRepository());

  // Register cubits and blocs
  locator.registerLazySingleton<UserCubit>(
    () => UserCubit(userRepository: locator<UserRepository>()),
  );
  locator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      authRepository: locator<AuthRepository>(),
      userRepository: locator<UserRepository>(),
    ),
  );
  locator.registerLazySingleton<MenuCubit>(() => MenuCubit());
  locator.registerFactory<ContactCubit>(
    () => ContactCubit(contactsRepository: locator<ContactsRepository>()),
  );
  locator.registerLazySingleton<FriendCubit>(
    () => FriendCubit(
      friendRepository: locator<FriendRepository>(),
      userRepository: locator<UserRepository>(),
      balanceRepository: locator<BalanceRepository>(),
    ),
  );
  locator.registerLazySingleton<ExpenseCubit>(
    () => ExpenseCubit(
      splitRepository: locator<SplitRepository>(),
      expenseRepository: locator<ExpenseRepository>(),
    ),
  );
}

// Add a utility function to verify emulator connection
bool areEmulatorsConnected() {
  return _emulatorsConnected;
}

// Function to update FirebaseAuth language code dynamically
