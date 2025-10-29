import 'package:splithawk/src/core/services/service_locator.dart';

import 'src/core/config/config.dart';
import 'package:flutter/material.dart';
import 'root_app.dart';

Future<void> main() async {
  await DependencyInjection.init();
  setupLocator();
  // await EncryptionSetup.initialize();

  // if (bool.fromEnvironment('dart.vm.product') == false) {
  //   try {
  //     final bool emulatorConnected =
  //         await EmulatorVerification.verifyEmulatorConnections();
  //     if (emulatorConnected) {
  //       debugPrint("✅ Successfully connected to all Firebase emulators");
  //     } else {
  //       debugPrint("⚠️ Failed to connect to all Firebase emulators");
  //       // You could show a dialog here or handle this case appropriately
  //     }
  //   } catch (e) {
  //     debugPrint("⚠️ Error verifying emulator connections: $e");
  //   }
  // }

  runApp(RootApp());
}
