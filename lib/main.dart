import 'package:splithawk/src/core/config/encryption_setup.dart';
import 'package:splithawk/src/core/services/service_locator.dart';
import 'package:splithawk/src/core/services/emulator_verification.dart';

import 'src/core/config/config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'root_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await DependencyInjection.init();
  setupLocator();
  await EncryptionSetup.initialize();

  // During development/testing, verify emulator connections
  if (bool.fromEnvironment('dart.vm.product') == false) {
    try {
      final bool emulatorConnected =
          await EmulatorVerification.verifyEmulatorConnections();
      if (emulatorConnected) {
        debugPrint("✅ Successfully connected to all Firebase emulators");
      } else {
        debugPrint("⚠️ Failed to connect to all Firebase emulators");
        // You could show a dialog here or handle this case appropriately
      }
    } catch (e) {
      debugPrint("⚠️ Error verifying emulator connections: $e");
    }
  }

  // This is the main app
  runApp(RootApp());
}
