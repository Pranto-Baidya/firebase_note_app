import 'package:flutter/material.dart';
import 'package:back_to_firebase/secure_storage/secure_storage.dart';

class CredentialsProvider with ChangeNotifier {
  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  Future<void> loadCredentials() async {
    _rememberMe = await SecureStorage.getRememberMe();
    if (_rememberMe) {
      final email = await SecureStorage.getEmail();
      final password = await SecureStorage.getPassword();
      emailController.text = email ?? '';
      passwordController.text = password ?? '';
      notifyListeners();
    }
  }

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> persistCredentials() async {
    if (_rememberMe) {
      await SecureStorage.saveEmail(emailController.text.trim());
      await SecureStorage.savePassword(passwordController.text);
      await SecureStorage.saveRememberMe(true);
    } else {
      await SecureStorage.clearAll();
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    _rememberMe = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}