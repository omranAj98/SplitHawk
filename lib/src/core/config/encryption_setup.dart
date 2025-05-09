import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/cupertino.dart';

class EncryptionSetup {
  static late encrypt.Key key;
  static final encrypt.IV iv = encrypt.IV.fromLength(16); // 16 bytes IV
  static late encrypt.Encrypter encrypter;

  static Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.fetchAndActivate();
      // debugPrint("Remote config fetched and activated.");
    } catch (e) {
      debugPrint("Error fetching remote config: $e");
    }

    final encryptionKey = remoteConfig.getString('encryption_key');
    debugPrint("Encryption key: $encryptionKey");
    if (encryptionKey.length != 32) {
      throw Exception('Encryption key must be 32 characters long.');
    }

    // Initialize the encryption setup
    key = encrypt.Key.fromUtf8(encryptionKey);
    encrypter = encrypt.Encrypter(encrypt.AES(key));
  }
}
