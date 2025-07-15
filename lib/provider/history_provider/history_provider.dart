
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier{

  List<String> _historyList = [];
  List<String> get historyList => _historyList;

  Future<void> saveSearchHistory(String query)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> searchHistory = preferences.getStringList('history') ?? [];
    searchHistory.add(query);
    await preferences.setStringList('history', searchHistory);
    notifyListeners();
  }

  Future<void> loadSearchHistory()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> allSearchQueries = preferences.getStringList('history') ?? [];
    _historyList = allSearchQueries;
    notifyListeners();
  }

  Future<void> clearAllHistory()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('history');
    _historyList = [];
    notifyListeners();
  }

  Future<void> removeSpecificHistory(int index)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> removeHistory = preferences.getStringList('history') ?? [];
    removeHistory.removeAt(index);
    await preferences.setStringList('history', removeHistory);
    _historyList = removeHistory;
    notifyListeners();

  }

}