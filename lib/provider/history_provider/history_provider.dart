import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier {
  List<String> _historyList = [];
  List<String> get historyList => _historyList;

  HistoryProvider() {
    // Listen for future auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        loadSearchHistory(user);
      } else {
        _historyList = [];
        notifyListeners();
      }
    });
  }

  Future<void> saveSearchHistory(String query) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<String> searchHistory =
            preferences.getStringList(user.uid) ?? [];
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
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (user != null) {
        dynamic storedValue = preferences.get(user.uid);
        if (storedValue is List<String>) {
          _historyList = storedValue;
        } else {
          // যদি আগের কোনো ভুল টাইপের ডেটা থাকে, সরিয়ে ফেলি
          await preferences.remove(user.uid);
          _historyList = [];
        }
      } else {
        _historyList = [];
      }
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
        if (index >= 0 && index < removeHistory.length) {
          removeHistory.removeAt(index);
          await preferences.setStringList(user.uid, removeHistory);
          _historyList = removeHistory;
        }
      }
    } catch (e) {
      print('Error removing specific history: $e');
    }
    notifyListeners();
  }
}
