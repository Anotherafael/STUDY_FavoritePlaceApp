import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  final ColorScheme _colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 102, 6, 247),
    background: const Color.fromARGB(255, 56, 49, 66),
  );

  ThemeData get defaultTheme => ThemeData().copyWith(
        scaffoldBackgroundColor: _colorScheme.background,
        colorScheme: _colorScheme,
        textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
          titleSmall: GoogleFonts.ubuntuCondensed(
            fontWeight: FontWeight.bold,
          ),
          titleMedium: GoogleFonts.ubuntuCondensed(
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.ubuntuCondensed(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
