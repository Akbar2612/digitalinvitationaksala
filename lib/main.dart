import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home_page.dart';

void main() {
  runApp(WeddingInviteApp());
}

class WeddingInviteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Undangan Pernikahan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.playfairDisplayTextTheme().copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            color: Color(0xFFF5F5F5),
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.playfairDisplay(
            color: Color(0xFFF5F5F5),
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: GoogleFonts.playfairDisplay(
            color: Color(0xFFF5F5F5),
          ),
          bodyMedium: GoogleFonts.lato(
            color: Color(0xFFD0D0D0),
          ),
          bodySmall: GoogleFonts.lato(
            color: Color(0xFFB0B0B0),
          ),
        ),
        brightness: Brightness.dark,
        primaryColor: Color(0xFFF5F5F5),
        scaffoldBackgroundColor: Color(0xFF0F0F0F),
        cardColor: Color(0xFF1A1A1A),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFF5F5F5),
          secondary: Color(0xFF808080),
          surface: Color(0xFF1A1A1A),
          background: Color(0xFF0F0F0F),
          onPrimary: Colors.black,
          onSecondary: Color(0xFFF5F5F5),
          onSurface: Color(0xFFF5F5F5),
          onBackground: Color(0xFFF5F5F5),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF5F5F5),
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Color(0xFFF5F5F5),
            side: BorderSide(color: Color(0xFFF5F5F5), width: 1.5),
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}