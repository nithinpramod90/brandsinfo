import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Colors.orange,
      secondary: Colors.orangeAccent,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: GoogleFonts.ubuntuTextTheme(
      ThemeData.light().textTheme, // Apply Ubuntu font
    ).copyWith(
      bodyLarge: GoogleFonts.ubuntu(
        color: Colors.black,
      ),
      bodyMedium: GoogleFonts.ubuntu(color: Colors.black).copyWith(
        overflow: TextOverflow.ellipsis,
      ),
      titleLarge: GoogleFonts.ubuntu(color: Colors.black),
      titleMedium: GoogleFonts.ubuntu(color: Colors.black),
      labelLarge: GoogleFonts.ubuntu(color: Colors.white), // Button text color
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // Small curve
        ),
      ),
    ),
  );

  // Dark Theme with Greyish Black
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Colors.orange,
      secondary: Colors.orangeAccent, // Greyish Black
      surface: Color(0xFF1E1E1E), // Slightly lighter grey-black for contrast
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Color(0xFF1E1E1E), // Greyish Black
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E), // Darker Grey for AppBar
      titleTextStyle: TextStyle(color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: GoogleFonts.ubuntuTextTheme(
      ThemeData.dark().textTheme,
    ).copyWith(
      bodyLarge: GoogleFonts.ubuntu(color: Colors.white).copyWith(
        overflow: TextOverflow.ellipsis,
      ),
      bodyMedium: GoogleFonts.ubuntu(color: Colors.white),
      titleLarge: GoogleFonts.ubuntu(color: Colors.white),
      titleMedium: GoogleFonts.ubuntu(color: Colors.white),
      labelLarge: GoogleFonts.ubuntu(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // Small curve
        ),
      ),
    ),
  );
}
