
import 'package:back_to_firebase/firebase_options.dart';
import 'package:back_to_firebase/provider/auth_provider/auth_provider.dart';
import 'package:back_to_firebase/provider/credentials_provider/credentials_provider.dart';
import 'package:back_to_firebase/provider/history_provider/history_provider.dart';
import 'package:back_to_firebase/provider/internet_provider/internet_checker_provider.dart';
import 'package:back_to_firebase/provider/note_provider/note_provider.dart';
import 'package:back_to_firebase/provider/theme_provider/theme_provider.dart';
import 'package:back_to_firebase/screens/auth_screens/auth_check/check_user.dart';
import 'package:back_to_firebase/themeData/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=>AuthProvider()),
          ChangeNotifierProvider(create: (_)=>NoteProvider()),
          ChangeNotifierProvider(create: (_)=>ThemeProvider()),
          ChangeNotifierProvider(create: (_)=>HistoryProvider()),
          ChangeNotifierProvider(create: (_)=>InternetCheckerProvider()),
          ChangeNotifierProvider(create: (_)=>CredentialsProvider())
        ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      home: CheckUser(),
    );
  }
}



