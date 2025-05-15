import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/blocs/contact/contact_cubit.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/cubit/menu_cubit.dart';
import 'package:splithawk/src/repositories/auth_repository.dart';
import 'package:splithawk/src/repositories/contacts_repository.dart';
import 'package:splithawk/src/repositories/user_repository.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  final isTesting = bool.fromEnvironment('dart.vm.product') == false;

  // Register FirebaseAuth with settings
  locator.registerLazySingleton<FirebaseAuth>(() {
    final firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.setSettings(
      appVerificationDisabledForTesting:
          isTesting,
    );
    return firebaseAuth;
  });

  // Register FirebaseFirestore
  locator.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  locator.registerLazySingleton<UserRepository>(
    () => UserRepository(firebaseFirestore: locator<FirebaseFirestore>()),
  );
  locator.registerLazySingleton<UserCubit>(
    () => UserCubit(userRepository: locator<UserRepository>()),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(firebaseAuth: locator<FirebaseAuth>()),
  );
  locator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      authRepository: locator<AuthRepository>(),
      userRepository: locator<UserRepository>(),
    ),
  );

  locator.registerLazySingleton<MenuCubit>(() => MenuCubit());

  locator.registerLazySingleton<ContactsRepository>(() => ContactsRepository());
  locator.registerFactory<ContactCubit>(
    () => ContactCubit(contactsRepository: locator<ContactsRepository>()),
  );
}

// Function to update FirebaseAuth language code dynamically
void updateFirebaseAuthLanguage(String languageCode) async {
  final firebaseAuth = locator<FirebaseAuth>();
  await firebaseAuth.setLanguageCode(languageCode);
  debugPrint("Firebase Auth language code set to: $languageCode");
}
