import 'package:flutter/material.dart';

class AppButtonTheme {
// Light button theme
  static ElevatedButtonThemeData elevatedButtonThemeLight = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
  );

  static OutlinedButtonThemeData outlinedButtonThemeLight = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
  );

// Dark button theme
  static ElevatedButtonThemeData elevatedButtonThemeDark = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
  );

  static OutlinedButtonThemeData outlinedButtonThemeDark = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
  );
}

