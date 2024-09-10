import 'package:flutter/material.dart';
import 'package:healpath/src/utils/theme/widget_themes/button_themes.dart';
import 'package:healpath/src/utils/theme/widget_themes/text_themes.dart';

class AppTheme {
//light theme
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    textTheme: AppTextTheme.lightTextTheme,
    elevatedButtonTheme: AppButtonTheme.elevatedButtonThemeLight,
    outlinedButtonTheme: AppButtonTheme.outlinedButtonThemeLight,
  );

//dark theme
  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    textTheme: AppTextTheme.darktTextTheme,
    elevatedButtonTheme: AppButtonTheme.elevatedButtonThemeDark,
    outlinedButtonTheme: AppButtonTheme.outlinedButtonThemeDark,
  );
}
