import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/card_pengantin.dart';
import '../widgets/card_orang_tua.dart';
import '../widgets/acara_section.dart';
import '../widgets/lokasi_section.dart';
import '../data/wedding_data.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _showInvitation = false;
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

  @override
  Widget build(BuildContext context) {
    // Deteksi ukuran layar
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
        child: _showInvitation
            ? _buildInvitationContent(isMobile)
            : _buildLandingPage(context, isMobile),
      ),
    );
  }

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

  Widget _buildLandingPage(BuildContext context, bool isMobile) {
    int textIndex = 0;

    return Stack(
      children: [
        // === Background utama ===
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
                  AnimatedBuilder(
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
                      final animation =
                          Tween<double>(begin: 0, end: 1).animate(
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
                  ),
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
                  SizedBox(height: 8),
                  _buildAnimatedText(
                    text: eventTime,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB0B0B0),
                      fontWeight: FontWeight.w400,
                    ),
                    index: textIndex++,
                  ),
                  SizedBox(height: 8),
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
              AnimatedBuilder(
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationContent(bool isMobile) {
    if (isMobile) {
      return _buildMobileInvitation();
    } else {
      return _buildDesktopInvitation();
    }
  }

  Widget _buildMobileInvitation() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          CardPengantin(),
          CardOrangTua(),
          AcaraSection(),
          LokasiSection(),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDesktopInvitation() {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: CardPengantin()),
                    SizedBox(width: 32),
                    Expanded(child: CardOrangTua()),
                  ],
                ),
                SizedBox(height: 32),
                AcaraSection(),
                SizedBox(height: 32),
                LokasiSection(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}