import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../widgets/card_pengantin.dart';
import '../widgets/acara_section.dart';
import '../widgets/lokasi_section.dart';
import '../data/wedding_data.dart';

class HomePage extends StatefulWidget {
  final AudioPlayer audioPlayer;

  HomePage({required this.audioPlayer});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _showInvitation = false;
  bool _isMusicPlaying = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    try {
      print('▶️ Playing audio...');
      await widget.audioPlayer.play();
      setState(() {
        _isMusicPlaying = true;
      });
      print('✅ Audio playing');
    } catch (e) {
      print('❌ Error playing audio: $e');
    }
  }

  Future<void> _toggleMusic() async {
    try {
      if (_isMusicPlaying) {
        await widget.audioPlayer.pause();
        print('⏸️ Audio paused');
      } else {
        await widget.audioPlayer.play();
        print('▶️ Audio playing');
      }
      setState(() {
        _isMusicPlaying = !_isMusicPlaying;
      });
    } catch (e) {
      print('❌ Error toggling audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a1a),
              Color(0xFF0a0a0a),
            ],
          ),
        ),
        child: isMobile ? _buildMobileView() : _buildDesktopNotAvailable(),
      ),
    );
  }

  // ============ MOBILE VIEW ============
  Widget _buildMobileView() {
    return Stack(
      children: [
        _showInvitation ? _buildMobileInvitation() : _buildMobileLanding(),
        // Floating music button - only show on invitation page
        if (_showInvitation) _buildFloatingMusicButton(),
      ],
    );
  }

  Widget _buildMobileLanding() {
    int textIndex = 0;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mainbg.jpg'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color.fromRGBO(0, 0, 0, 0.1),
                  Colors.black,
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 250,
            bottom: 60,
            left: 40,
            right: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.shrink(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAnimatedText(
                          text: groomnickName,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 36,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFF5F5F5),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                          index: textIndex++,
                        ),
                        SizedBox(height: 8),
                        _buildAnimatedText(
                          text: "& " + bridenickName,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 36,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFF5F5F5),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                          index: textIndex++,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildAnimatedText(
                    text: 'Kami Mengundang',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.5,
                      color: Color(0xFFB0B0B0),
                      fontWeight: FontWeight.w400,
                    ),
                    index: textIndex++,
                  ),
                  SizedBox(height: 18),
                  _buildAnimatedText(
                    text: 'Yth. Tamu Undangan',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB0B0B0),
                      fontWeight: FontWeight.w400,
                    ),
                    index: textIndex++,
                  ),
                  SizedBox(height: 6),
                  _buildAnimatedText(
                    text: '[Nama Tamu]',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 22,
                          letterSpacing: 1,
                          color: Color(0xFFF5F5F5),
                        ) ??
                        TextStyle(
                          fontSize: 22,
                          letterSpacing: 1,
                          color: Color(0xFFF5F5F5),
                        ),
                    index: textIndex++,
                  ),
                  SizedBox(height: 16),
                  _buildDecorativeLine(textIndex),
                  SizedBox(height: 10),
                  _buildAnimatedText(
                    text: eventDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFD0D0D0),
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w400,
                    ),
                    index: textIndex++,
                  ),
                  SizedBox(height: 5),
                  _buildAnimatedText(
                    text: eventTime,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB0B0B0),
                      fontWeight: FontWeight.w400,
                    ),
                    index: textIndex++,
                  ),
                  SizedBox(height: 5),
                  _buildAnimatedText(
                    text: eventLocation,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB0B0B0),
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                    index: textIndex++,
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildOpenInvitationButton(textIndex),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDecorativeLine(int textIndex) {
    return AnimatedBuilder(
      animation: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            (textIndex * 100) / 2000,
            ((textIndex * 100) + 400) / 2000,
            curve: Curves.easeOut,
          ),
        ),
      ),
      builder: (context, child) {
        final animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              (textIndex * 100) / 2000,
              ((textIndex * 100) + 400) / 2000,
              curve: Curves.easeOut,
            ),
          ),
        );
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: Container(
              width: 40 * animation.value,
              height: 1.5,
              color: Color(0xFFF5F5F5),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOpenInvitationButton(int textIndex) {
    return AnimatedBuilder(
      animation: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            (textIndex * 100) / 2000,
            ((textIndex * 100) + 400) / 2000,
            curve: Curves.easeOut,
          ),
        ),
      ),
      builder: (context, child) {
        final animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              (textIndex * 100) / 2000,
              ((textIndex * 100) + 400) / 2000,
              curve: Curves.easeOut,
            ),
          ),
        );
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: ElevatedButton(
              onPressed: () {
                _playAudio();
                setState(() {
                  _showInvitation = true;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Buka Undangan'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileInvitation() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          CardPengantin(),
          AcaraSection(),
          LokasiSection(),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFloatingMusicButton() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: GestureDetector(
        onTap: _toggleMusic,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5).withOpacity(0.15),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Color(0xFFF5F5F5).withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              _isMusicPlaying ? Icons.music_note : Icons.music_off,
              color: Color(0xFFF5F5F5),
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

  // ============ DESKTOP VIEW ============
  Widget _buildDesktopNotAvailable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 80,
            color: Color(0xFFF5F5F5).withOpacity(0.5),
          ),
          SizedBox(height: 24),
          Text(
            'Versi Desktop Belum Tersedia',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              color: Color(0xFFF5F5F5),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Silahkan gunakan perangkat mobile untuk mengakses undangan ini',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFB0B0B0),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Container(
            width: 200,
            height: 1,
            color: Color(0xFFF5F5F5).withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  // ============ HELPER WIDGETS ============
  Widget _buildAnimatedText({
    required String text,
    required TextStyle style,
    required int index,
    int totalDuration = 2000,
  }) {
    final delay = index * 100;
    final animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          delay / totalDuration,
          (delay + 400) / totalDuration,
          curve: Curves.easeOut,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: Text(text, style: style),
    );
  }
}