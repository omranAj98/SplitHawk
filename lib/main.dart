import 'package:splithawk/src/core/config/encryption_setup.dart';
import 'package:splithawk/src/core/services/service_locator.dart';

import 'src/core/config/config.dart';
import 'package:flutter/material.dart';
import 'root_app.dart';

Future<void> main() async {
  
  await DependencyInjection.init();
  setupLocator();
  await EncryptionSetup.initialize();

  
  //  This is the main app
  runApp(
     RootApp(),
  );
}
