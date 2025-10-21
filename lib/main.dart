import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:html' as html;
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(WeddingInviteApp());
}

class WeddingInviteApp extends StatefulWidget {
  @override
  State<WeddingInviteApp> createState() => _WeddingInviteAppState();
}

class _WeddingInviteAppState extends State<WeddingInviteApp> {
  late AudioPlayer _audioPlayer;
  String? guestSlug;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _extractGuestFromUrl();
  }

  void _extractGuestFromUrl() {
    final path = html.window.location.pathname;
    print('Current URL path: $path');
    
    // Extract slug dari URL seperti /toAkbar
    if (path != null && path.startsWith('/to') && path.length > 3) {
      guestSlug = path.substring(3); // Hapus '/to'
      print('Guest slug: $guestSlug');
    }
  }

  Future<void> _initAudioPlayer() async {
    try {
      _audioPlayer = AudioPlayer();
      print('🔊 AudioPlayer initialized');

      print('📂 Loading asset: assets/music/musicbg.mp3');
      final duration = await _audioPlayer.setAsset('assets/music/musicbg.mp3');
      print('✅ Asset loaded, duration: $duration');

      await _audioPlayer.setLoopMode(LoopMode.all);
      print('✅ Loop mode set');

      await _audioPlayer.setVolume(0.5);
      print('✅ Volume set to 0.5');

      print('✅ Audio player ready!');
    } catch (e) {
      print('❌ Error initializing audio: $e');
      print('Error type: ${e.runtimeType}');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akbar & Wulan Wedding Invitation',
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
      home: _getHomePage(),
      routes: {
        '/admin': (context) => const AdminPage(),
      },
    );
  }

  Widget _getHomePage() {
    // Cek jika URL adalah /admin
    final path = html.window.location.pathname;
    if (path == '/admin') {
      return const AdminPage();
    }
    
    // Return HomePage dengan guest slug
    return HomePage(
      audioPlayer: _audioPlayer,
      guestSlug: guestSlug,
    );
  }
}