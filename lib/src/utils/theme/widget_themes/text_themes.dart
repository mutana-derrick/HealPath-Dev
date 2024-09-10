import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
//light text theme
  static TextTheme lightTextTheme = TextTheme(
    displayMedium: GoogleFonts.anekKannada(
      color: Colors.black,
    ),
    titleMedium: GoogleFonts.mulish(
      color: Colors.black,
    ),
    bodyLarge: GoogleFonts.mulish(
      color: Colors.black87,
    ),
  );

//Dark text theme
  static TextTheme darktTextTheme = TextTheme(
    displayMedium: GoogleFonts.anekKannada(
      color: Colors.white,
    ),
    titleMedium: GoogleFonts.mulish(
      color: Colors.white,
    ),
    bodyLarge: GoogleFonts.mulish(
      color: Colors.white70,
    ),
  );
}
