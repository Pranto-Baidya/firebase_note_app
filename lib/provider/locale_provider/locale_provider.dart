import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocaleProvider extends ChangeNotifier {

  Locale? _locale;
  Locale? get locale => _locale;

  /*late final StreamSubscription<User?> _authSubscription;

  LocaleProvider() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(_authStateChanged);
  }

  void _authStateChanged(User? user) {
    if (user != null) {
      _loadLocaleForUser(user);
    } else {
      _locale = Locale('en');
      notifyListeners();
    }
  }*/

  Future<void> setLocale(Locale locale) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale_${user.uid}', locale.languageCode);

    _locale = locale;
    notifyListeners();
  }

  Future<void> loadLocaleForUser(User? user) async {
    if (user == null) {
      _locale = const Locale('en');
      notifyListeners();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('locale_${user.uid}');

    _locale = langCode != null ? Locale(langCode) : const Locale('en');
    notifyListeners();
  }

}
