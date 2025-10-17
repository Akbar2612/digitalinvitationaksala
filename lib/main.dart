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
        textTheme: GoogleFonts.poppinsTextTheme(),
        brightness: Brightness.light,
        primaryColor: Color(0xFFFFB6C1),
        scaffoldBackgroundColor: Color(0xFFFFFAF0),
      ),
      home: HomePage(),
    );
  }
}
