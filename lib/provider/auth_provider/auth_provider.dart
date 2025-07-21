
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:google_sign_in/google_sign_in.dart';


class AuthProvider extends ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;


  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMsg = '';

  String? get errorMsg => _errorMsg;

  Future<bool> signIn(String email, String password)async{
    _isLoading = true;
    notifyListeners();

    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }
    on FirebaseAuthException catch(e){
      _errorMsg = e.message;
      return false;
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMsg = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> signOut()async{
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3)); // just to show loader in the ui
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      return true;
    }
    on FirebaseAuthException catch(e){
      _errorMsg = e.message;
      return false;
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email)async{
    _isLoading = true;
    notifyListeners();

    try{
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    }
    on FirebaseAuthException catch(e){
      _errorMsg = e.message;
      return false;
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<UserCredential?> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception("Sign in aborted by user");
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      _errorMsg = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInAsAGuest() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInAnonymously();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMsg = e.message;
      return false;
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}