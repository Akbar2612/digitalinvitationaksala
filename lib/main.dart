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
          bodyMedium: GoogleFonts.lato(),
          bodySmall: GoogleFonts.lato(),
        ),
        brightness: Brightness.dark,
        primaryColor: Color(0xFFD4AF37),
        scaffoldBackgroundColor: Color(0xFF1a1a1a),
        cardColor: Color(0xFF2d2d2d),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          secondary: Color(0xFFB8B8B8),
          surface: Color(0xFF2d2d2d),
          background: Color(0xFF1a1a1a),
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onBackground: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFD4AF37),
            foregroundColor: Colors.black,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}