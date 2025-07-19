import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier {

  List<String> _historyList = [];
  List<String> get historyList => _historyList;

  late final StreamSubscription<User?> _authSubscription;

  HistoryProvider() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(_authStateChanged);
  }

  void _authStateChanged(User? user) {
    if (user != null) {
      loadSearchHistory(user);
    } else {
      _historyList = [];
      notifyListeners();
    }
  }

  Future<void> saveSearchHistory(String query) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<String> searchHistory = preferences.getStringList(user.uid) ?? [];
        searchHistory.add(query);
        await preferences.setStringList(user.uid, searchHistory);
        _historyList = searchHistory;
      }
    } catch (e) {
      print('Error saving search history: $e');
    }
    notifyListeners();
  }

  Future<void> loadSearchHistory(User? user) async {
    if (user == null) {
      _historyList = [];
      notifyListeners();
      return;
    }
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      List<String> list = preferences.getStringList(user.uid) ?? [];
      _historyList = list;
    } catch (e) {
      print('Error loading search history: $e');
      _historyList = [];
    }
    notifyListeners();
  }

  Future<void> clearAllHistory() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await preferences.remove(user.uid);
        _historyList = [];
      }
    } catch (e) {
      print('Error clearing search history: $e');
    }
    notifyListeners();
  }

  Future<void> removeSpecificHistory(int index) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<String> removeHistory =
            preferences.getStringList(user.uid) ?? [];
        removeHistory.removeAt(index);
        await preferences.setStringList(user.uid, removeHistory);
        _historyList = removeHistory;
      }
    } catch (e) {
      print('Error removing specific history: $e');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
