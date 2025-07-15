

import 'package:back_to_firebase/custom_widgets/gradient_background.dart';
import 'package:flutter/material.dart';


ThemeData lightTheme = ThemeData(
  colorSchemeSeed: Color(0xFFe68f50),
    scaffoldBackgroundColor: Color(0xFFfcf3ec),
    textTheme:  TextTheme(
      labelSmall: TextStyle(
          color: Color(0xFF111524),
          fontSize: 11
      ),
      labelMedium: TextStyle(
          color: Color(0xFF111524),
          fontSize: 12
      ),
      labelLarge: TextStyle(
          color: Color(0xFF111524),
          fontSize: 14
      ),
      titleSmall: TextStyle(
          color: Color(0xFF111524),
          fontSize: 14
      ),
      titleMedium: TextStyle(
          color: Color(0xFF111524),
          fontSize: 16
      ),
      titleLarge: TextStyle(
          color: Color(0xFF111524),
          fontSize: 22
      ),
      displaySmall: TextStyle(
          color: Color(0xFF111524),
          fontWeight: FontWeight.bold,
          fontSize: 36
      ),
      displayMedium: TextStyle(
          color: Color(0xFF111524),
          fontSize: 45
      ),
      displayLarge: TextStyle(
          color: Color(0xFF111524),
          fontSize: 57
      ),
      headlineSmall: TextStyle(
        color: Color(0xFF111524),
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF111524),
        fontWeight: FontWeight.bold,

      ),
      headlineLarge: TextStyle(
        color: Color(0xFF111524),
        fontWeight: FontWeight.bold,

      ),
      bodySmall: TextStyle(
          color: Color(0xFF111524),
          fontSize: 12
      ),
      bodyMedium: TextStyle(
          color: Color(0xFF111524),
          fontSize: 14
      ),
      bodyLarge: TextStyle(
          color: Color(0xFF111524),
          fontSize: 16
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      side: BorderSide(
        color: Color(0xFF111524),
        width: 2
      ),
    ),
    listTileTheme: ListTileThemeData(
        tileColor: Colors.white,
        iconColor: Color(0xFF111524),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
        color: Colors.blue.shade400
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white
    ),
    popupMenuTheme: const PopupMenuThemeData(
        color: Colors.white,
        iconColor: Colors.black,
        textStyle: TextStyle(
            color: Colors.black
        )
    ),
    iconTheme: const IconThemeData(
        color: Color(0xFF111524),
    ),
    cardColor: Colors.white,
    dialogTheme: const DialogThemeData(
        titleTextStyle: TextStyle(color: Color(0xFF111524),fontSize: 28),
        contentTextStyle: TextStyle(color: Color(0xFF111524)),
        backgroundColor: Color(0xFFfcf3ec)
    ),
    navigationBarTheme:  NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Colors.blue.shade400,
    ),
    searchBarTheme:  SearchBarThemeData(
      backgroundColor: WidgetStatePropertyAll(Colors.white),
    ),
    inputDecorationTheme:  InputDecorationTheme(
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Colors.grey.shade400
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              width: 2,
              color: Color(0xFFe68f50)
          )
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Colors.grey.shade400
          )
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2
        )
      )
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFFfcf3ec),
    ),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0
    )
);

ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF111524),
      scrolledUnderElevation: 0
  ),
  scaffoldBackgroundColor: Color(0xFF111524),
    colorSchemeSeed: Color(0xFFe68f50),
  textTheme: TextTheme(
    labelSmall: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontSize: 11
    ),
    labelMedium: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontSize: 12
    ),
    labelLarge: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontSize: 14
    ),
    titleSmall: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontSize: 14
    ),
    titleMedium: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontSize: 16
    ),
    titleLarge: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontSize: 22
    ),
    displaySmall: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontWeight: FontWeight.bold,
        fontSize: 36
    ),
    displayMedium: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontSize: 45
    ),
    displayLarge: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontSize: 57
    ),
    headlineSmall: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
        color:  Color(0xFFfcf3ec),
      fontWeight: FontWeight.bold,

    ),
    headlineLarge: TextStyle(
        color:  Color(0xFFfcf3ec),
      fontWeight: FontWeight.bold,

    ),
    bodySmall: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontSize: 12
    ),
    bodyMedium: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontSize: 14
    ),
    bodyLarge: TextStyle(
        color:  Color(0xFFfcf3ec),
        fontSize: 16
    ),
  ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF111524),
    ),
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(
        color:  Color(0xFFfcf3ec),
        width: 2
    ),
  ),
  listTileTheme: const ListTileThemeData(
      tileColor: Color(0xFF262E46),
      iconColor:  Color(0xFFfcf3ec),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Colors.white
  ),
  popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFF262E46),
      iconColor: Colors.white,
      textStyle: TextStyle(
          color: Colors.white
      )
  ),

  iconTheme: const IconThemeData(
      color:  Color(0xFFfcf3ec),
  ),
  cardColor: Color(0xFF262E46),
  dialogTheme: const DialogThemeData(
      titleTextStyle: TextStyle(color:  Color(0xFFfcf3ec),fontSize: 28),
      contentTextStyle: TextStyle(color:  Color(0xFFfcf3ec),),
      backgroundColor: Color(0xFF262E46)
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF333334)
  ),
  navigationBarTheme:  NavigationBarThemeData(
    backgroundColor: Color(0xFF1c1c1d),
    indicatorColor: Colors.black,

  ),
  searchBarTheme: const SearchBarThemeData(
    backgroundColor: WidgetStatePropertyAll(Color(0xFF333334)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color(0xFF333334),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color:  Color(0xFFfcf3ec),
        )
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color: Color(0xFFe68f50)
        )
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color:  Color(0xFFfcf3ec),
        )
    ),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(Color(0xFF262E46))
    ),
    inputDecorationTheme: InputDecorationTheme(

    )
  )
);