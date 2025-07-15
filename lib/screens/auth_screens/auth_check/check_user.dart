

import 'package:back_to_firebase/provider/theme_provider/theme_provider.dart';
import 'package:back_to_firebase/screens/auth_screens/sign_in/sign_in_page.dart';
import 'package:back_to_firebase/screens/note_screens/all_notes/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CheckUser extends StatelessWidget {
  const CheckUser({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      return Home(onToggle: Provider.of<ThemeProvider>(context,listen: false).toggleTheme);
    }
    else{
      return SignInPage();
    }
  }
}

