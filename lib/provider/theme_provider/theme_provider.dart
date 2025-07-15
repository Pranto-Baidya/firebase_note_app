
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> toggleTheme(bool isDark) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String key = 'isDarkMode';
    await preferences.setBool(key, isDark);

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    navBarColor();
    notifyListeners();
  }

  Future<void> loadTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String key = 'isDarkMode';
    bool isDark = preferences.getBool(key) ?? false;

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    navBarColor();
    notifyListeners();
  }

  Future<void> navBarColor()async{
    bool isDark = _themeMode==ThemeMode.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: isDark? Color(0xFF111524) : Color(0xFFfcf3ec)
      )
    );
  }
}
