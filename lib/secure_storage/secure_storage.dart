import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _secureStorage = FlutterSecureStorage();

  static const String _userEmailKey = 'email';
  static const String _userPassKey = 'password';
  static const String _rememberMeKey = 'rememberMe';

  static Future saveEmail(String email) async {
    await _secureStorage.write(key: _userEmailKey, value: email);
  }

  static Future<String?> getEmail() async {
    return await _secureStorage.read(key: _userEmailKey);
  }

  static Future savePassword(String password) async {
    await _secureStorage.write(key: _userPassKey, value: password);
  }

  static Future<String?> getPassword() async {
    return await _secureStorage.read(key: _userPassKey);
  }

  static Future saveRememberMe(bool rememberMe) async {
    await _secureStorage.write(key: _rememberMeKey, value: rememberMe.toString());
  }

  static Future<bool> getRememberMe() async {
    String? remember = await _secureStorage.read(key: _rememberMeKey);
    return remember == 'true';
  }

  static Future clearAll() async {
    await _secureStorage.deleteAll();
  }
}
