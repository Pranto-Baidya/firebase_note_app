import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData lightTheme = ThemeData(
  colorSchemeSeed: const Color(0xFFe68f50),
  scaffoldBackgroundColor: const Color(0xFFfcf3ec),
  textTheme: TextTheme(
    labelSmall: TextStyle(color: const Color(0xFF111524), fontSize: 11.sp),
    labelMedium: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
    labelLarge: TextStyle(color: const Color(0xFF111524), fontSize: 14.sp),
    titleSmall: TextStyle(color: const Color(0xFF111524), fontSize: 14.sp),
    titleMedium: TextStyle(color: const Color(0xFF111524), fontSize: 16.sp),
    titleLarge: TextStyle(color: const Color(0xFF111524), fontSize: 22.sp),
    displaySmall: TextStyle(
        color: const Color(0xFF111524),
        fontWeight: FontWeight.bold,
        fontSize: 36.sp),
    displayMedium: TextStyle(color: const Color(0xFF111524), fontSize: 45.sp),
    displayLarge: TextStyle(color: const Color(0xFF111524), fontSize: 57.sp),
    headlineSmall:
    const TextStyle(color: Color(0xFF111524), fontWeight: FontWeight.bold),
    headlineMedium:
    const TextStyle(color: Color(0xFF111524), fontWeight: FontWeight.bold),
    headlineLarge:
    const TextStyle(color: Color(0xFF111524), fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: const Color(0xFF111524), fontSize: 12.sp),
    bodyMedium: TextStyle(color: const Color(0xFF111524), fontSize: 14.sp),
    bodyLarge: TextStyle(color: const Color(0xFF111524), fontSize: 16.sp),
  ),
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(color: const Color(0xFF111524), width: 2.w),
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Colors.white,
    iconColor: Color(0xFF111524),
  ),
  progressIndicatorTheme:
  ProgressIndicatorThemeData(color: Colors.blue.shade400),
  bottomNavigationBarTheme:
  const BottomNavigationBarThemeData(backgroundColor: Colors.white),
  popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      iconColor: Colors.black,
      textStyle: TextStyle(color: Colors.black, fontSize: 14.sp)),
  iconTheme: const IconThemeData(color: Color(0xFF111524)),
  cardColor: Colors.white,
  dialogTheme: DialogThemeData(
    titleTextStyle:
    TextStyle(color: Color(0xFF111524), fontSize: 28.sp),
    contentTextStyle: const TextStyle(color: Color(0xFF111524)),
    backgroundColor: const Color(0xFFfcf3ec),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: Colors.blue.shade400,
  ),
  searchBarTheme:
  const SearchBarThemeData(backgroundColor: WidgetStatePropertyAll(Colors.white)),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(width: 2.w, color: const Color(0xFFe68f50)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(width: 2.w, color: Colors.red.shade800),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFFfcf3ec),
  ),
  appBarTheme:
  const AppBarTheme(backgroundColor: Colors.white, scrolledUnderElevation: 0),
);

ThemeData darkTheme = ThemeData(
  colorSchemeSeed: const Color(0xFFe68f50),
  scaffoldBackgroundColor: const Color(0xFF111524),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF111524), scrolledUnderElevation: 0),
  textTheme: TextTheme(
    labelSmall: TextStyle(color: const Color(0xFFfcf3ec), fontSize: 11.sp),
    labelMedium: TextStyle(color: Colors.grey.shade400, fontSize: 12.sp),
    labelLarge: TextStyle(color: const Color(0xFFfcf3ec), fontSize: 14.sp),
    titleSmall: TextStyle(color: const Color(0xFFfcf3ec), fontSize: 14.sp),
    titleMedium: TextStyle(color: const Color(0xFFfcf3ec), fontSize: 16.sp),
    titleLarge: TextStyle(color: const Color(0xFFfcf3ec), fontSize: 22.sp),
    displaySmall: TextStyle(
        color: const Color(0xFFfcf3ec),
        fontWeight: FontWeight.bold,
        fontSize: 36.sp),
    displayMedium: TextStyle(color: const Color(0xFFfcf3ec), fontSize: 45.sp),
    displayLarge: TextStyle(color: const Color(0xFFfcf3ec), fontSize: 57.sp),
    headlineSmall:
    const TextStyle(color: Color(0xFFfcf3ec), fontWeight: FontWeight.bold),
    headlineMedium:
    const TextStyle(color: Color(0xFFfcf3ec), fontWeight: FontWeight.bold),
    headlineLarge:
    const TextStyle(color: Color(0xFFfcf3ec), fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: const Color(0xFFfcf3ec), fontSize: 12.sp),
    bodyMedium: TextStyle(color: const Color(0xFFfcf3ec), fontSize: 14.sp),
    bodyLarge: TextStyle(color: const Color(0xFFfcf3ec), fontSize: 16.sp),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF111524),
  ),
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(color: const Color(0xFFfcf3ec), width: 2.w),
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Color(0xFF262E46),
    iconColor: Color(0xFFfcf3ec),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
  popupMenuTheme: PopupMenuThemeData(
    color: const Color(0xFF262E46),
    iconColor: Colors.white,
    textStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
  ),
  iconTheme: const IconThemeData(color: Color(0xFFfcf3ec)),
  cardColor: const Color(0xFF262E46),
  dialogTheme: DialogThemeData(
    titleTextStyle:
    TextStyle(color: const Color(0xFFfcf3ec), fontSize: 28.sp),
    contentTextStyle: const TextStyle(color: Color(0xFFfcf3ec)),
    backgroundColor: const Color(0xFF262E46),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF333334),
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Color(0xFF1c1c1d),
    indicatorColor: Colors.black,
  ),
  searchBarTheme: const SearchBarThemeData(
    backgroundColor: WidgetStatePropertyAll(Color(0xFF333334)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color(0xFF333334),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: Color(0xFFfcf3ec)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: Color(0xFFe68f50)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: Color(0xFFfcf3ec)),
    ),
  ),
  dropdownMenuTheme: const DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(Color(0xFF262E46)),
    ),
  ),
);
