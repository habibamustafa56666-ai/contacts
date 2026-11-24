import 'package:material_ui/material_ui.dart';

class AppTheme {
  static const Color primaryDarkBlue = Color(0xFF29384D);
  static const Color lightBlue = Color(0xFFE2F4F6);
  static const Color goldAccent = Color(0xFFFFF1D4);
  static const Color redDelete = Color(0xFFEE403D);
  static const Color white = Colors.white;


  static const String fontFamily = 'Inter';

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: goldAccent,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: primaryDarkBlue,
  );

  static const TextStyle hintStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: lightBlue,
  );


  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: primaryDarkBlue,
      fontFamily: fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDarkBlue,
        elevation: 0,
      ),
    );
  }
}