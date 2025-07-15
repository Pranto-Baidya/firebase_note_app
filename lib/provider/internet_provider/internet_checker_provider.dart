
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetCheckerProvider extends ChangeNotifier{

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  InternetCheckerProvider(){
    checkInitialConnection();
    _subscription = Connectivity().onConnectivityChanged.listen(updateConnection);
  }

  bool _isConnected = true;

  bool get isConnected => _isConnected;

  Future<void> checkInitialConnection()async{
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    await updateConnection(result);
  }

  Future<void> updateConnection(List<ConnectivityResult> result)async{
    bool isNowConnected = result.isNotEmpty && result.first!=ConnectivityResult.none;

    if(isNowConnected!=_isConnected){
      _isConnected = isNowConnected;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

}