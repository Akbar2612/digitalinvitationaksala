import 'package:digitalinvitationaksala/pages/pengantin_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../data/wedding_data.dart';
import '../services/firestore_service.dart';

// Context provider untuk mendeteksi apakah di dalam mockup
class MockupContext extends InheritedWidget {
  final bool isInsideMockup;

  const MockupContext({
    Key? key,
    required this.isInsideMockup,
    required Widget child,
  }) : super(key: key, child: child);

  static MockupContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MockupContext>();
  }

  @override
  bool updateShouldNotify(MockupContext oldWidget) {
    return isInsideMockup != oldWidget.isInsideMockup;
  }
}

class HomePage extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String? guestSlug;

  HomePage({required this.audioPlayer, this.guestSlug});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _firestoreService = FirestoreService();

  String guestName = 'Tamu Undangan';
  String guestAddress = '';
  bool isLoading = true;
  bool isImagesLoaded = false;

  // State untuk mockup content
  Widget? _mockupContent;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _loadGuestData();

    // Preload images after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImages();
    });
  }

  Future<void> _preloadImages() async {
    try {
      final isMobile = MediaQuery.of(context).size.width < 768;

      if (isMobile) {
        await precacheImage(AssetImage('assets/images/mainbg.jpg'), context);
      } else {
        await precacheImage(
          AssetImage('assets/images/mainbgdekstop.jpg'),
          context,
        );
        await precacheImage(
          AssetImage('assets/images/mainbgdekstop2.jpg'),
          context,
        );
        await precacheImage(AssetImage('assets/images/mainbg.jpg'), context);
      }

      // Wait a bit to ensure smooth transition
      await Future.delayed(Duration(milliseconds: 300));

      if (mounted) {
        setState(() {
          isImagesLoaded = true;
        });

        // Start animation after images loaded
        Future.delayed(Duration(milliseconds: 200), () {
          if (mounted) {
            _animationController.forward();
          }
        });
      }
    } catch (e) {
      print('Error preloading images: $e');
      // If preload fails, show content anyway
      if (mounted) {
        setState(() {
          isImagesLoaded = true;
        });
      }
    }
  }

  Future<void> _loadGuestData() async {
    if (widget.guestSlug != null && widget.guestSlug!.isNotEmpty) {
      try {
        print('Loading guest data for slug: ${widget.guestSlug}');
        final guestData = await _firestoreService.getGuestBySlug(
          widget.guestSlug!,
        );

        if (guestData != null && mounted) {
          setState(() {
            guestName = guestData['name'] ?? 'Tamu Undangan';
            guestAddress = guestData['address'] ?? '';
            isLoading = false;
          });
          print('Guest data loaded: $guestName, $guestAddress');
        } else {
          print('Guest not found');
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error loading guest data: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
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
      print('✅ Audio playing');
    } catch (e) {
      print('❌ Error playing audio: $e');
    }
  }

  void _navigateToPengantinPage() {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      // Di mobile, navigate seperti biasa
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              CardPengantinPage(audioPlayer: widget.audioPlayer),
        ),
      );
    } else {
      // Di desktop, update mockup content dengan MockupContext wrapper
      setState(() {
        _mockupContent = MockupContext(
          isInsideMockup: true,
          child: CardPengantinPage(audioPlayer: widget.audioPlayer),
        );
      });
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
            colors: [Color(0xFF1a1a1a), Color(0xFF0a0a0a)],
          ),
        ),
        child: (isLoading || !isImagesLoaded)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFFD4AF37),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Memuat Undangan...',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.w300,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              )
            : (isMobile ? _buildMobileView() : _buildDesktopView()),
      ),
    );
  }

  Widget _buildMobileView() {
    return _buildMobileLanding();
  }

  Widget _buildDesktopView() {
    int textIndex = 0;

    return Stack(
      children: [
        // Background Image Desktop - Split dengan Dissolve
        Positioned.fill(
          child: Row(
            children: [
              // Background Kiri
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/mainbgdekstop.jpg'),
                      fit: BoxFit.cover,
                      alignment: Alignment.centerRight,
                      opacity: 0.4,
                    ),
                  ),
                ),
              ),
              // Background Kanan
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/mainbgdekstop2.jpg'),
                      fit: BoxFit.cover,
                      alignment: Alignment.centerLeft,
                      opacity: 0.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Dissolve Effect di Tengah
        Positioned.fill(
          child: Center(
            child: Container(
              width: 600,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.15, 0.25, 0.35, 0.5, 0.65, 0.75, 0.85, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),

        // Content
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Side - Wedding Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildAnimatedText(
                        text: 'THE WEDDING OF',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 4,
                        ),
                        index: textIndex++,
                      ),
                      SizedBox(height: 24),
                      _buildAnimatedText(
                        text: groomnickName,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 72,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFF5F5F5),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          height: 1.1,
                        ),
                        index: textIndex++,
                      ),
                      SizedBox(height: 8),
                      _buildAnimatedText(
                        text: "& " + bridenickName,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 72,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFF5F5F5),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          height: 1.1,
                        ),
                        index: textIndex++,
                      ),
                      SizedBox(height: 32),
                      _buildAnimatedText(
                        text: 'Selasa, 09 Desember 2025',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Color(0xFFF5F5F5).withOpacity(0.9),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1,
                        ),
                        index: textIndex++,
                      ),
                    ],
                  ),
                ),
              ),

              // Center - Phone Mockup
              _buildPhoneMockup(),

              // Right Side - Spacer
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ],
    );
  }

  // MOCKUP TANPA ANIMASI - dengan dynamic content
  Widget _buildPhoneMockup() {
    return Container(
      width: 340,
      height: 680,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Color(0xFF2a2a2a), width: 8),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1a1a1a).withOpacity(0.8),
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: _mockupContent ?? _buildMobileLandingStatic(),
      ),
    );
  }

  // VERSI STATIC TANPA ANIMASI UNTUK MOCKUP
  Widget _buildMobileLandingStatic() {
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groomnickName,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 36,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFF5F5F5),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "& " + bridenickName,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 36,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFF5F5F5),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Kepada Yth. Bapak/Ibu/Saudara/i',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFB0B0B0),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFD4AF37),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFD4AF37).withOpacity(0.08),
                              Color(0xFFD4AF37).withOpacity(0.03),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              guestName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD4AF37),
                                letterSpacing: 0.5,
                              ),
                            ),
                            if (guestAddress.isNotEmpty) ...[
                              SizedBox(height: 6),
                              Text(
                                guestAddress,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Selasa, 09 Desember 2025',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD4AF37),
                      foregroundColor: Color(0xFF1a1a1a),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _playAudio();
                      _navigateToPengantinPage();
                    },
                    child: Text(
                      'Buka Undangan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox.shrink(),
            ],
          ),
        ),
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
                  SizedBox(height: 20),
                  _buildStyledTamuCard(textIndex++),
                  SizedBox(height: 10),
                  _buildAnimatedText(
                    text: 'Selasa, 09 Desember 2025',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w400,
                    ),
                    index: textIndex++,
                  ),
                  SizedBox(height: 24),
                  _buildOpenInvitationButton(textIndex),
                ],
              ),
              SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStyledTamuCard(int textIndex) {
    final animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          (textIndex * 150) / 3000,
          ((textIndex * 150) + 400) / 3000,
          curve: Curves.easeOut,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAnimatedText(
            text: 'Kepada Yth. Bapak/Ibu/Saudara/i',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFFB0B0B0),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
            index: textIndex++,
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFD4AF37), width: 1.5),
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFD4AF37).withOpacity(0.08),
                  Color(0xFFD4AF37).withOpacity(0.03),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedText(
                  text: guestName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                    letterSpacing: 0.5,
                  ),
                  index: textIndex++,
                ),
                if (guestAddress.isNotEmpty) ...[
                  SizedBox(height: 6),
                  _buildAnimatedText(
                    text: guestAddress,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    index: textIndex++,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenInvitationButton(int textIndex) {
    return AnimatedBuilder(
      animation: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            (textIndex * 150) / 3000,
            ((textIndex * 150) + 500) / 3000,
            curve: Curves.easeOut,
          ),
        ),
      ),
      builder: (context, child) {
        final animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              (textIndex * 150) / 3000,
              ((textIndex * 150) + 500) / 3000,
              curve: Curves.easeOut,
            ),
          ),
        );
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4AF37),
                foregroundColor: Color(0xFF1a1a1a),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _playAudio();
                _navigateToPengantinPage();
              },
              child: Text(
                'Buka Undangan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedText({
    required String text,
    required TextStyle style,
    required int index,
    int totalDuration = 2500,
  }) {
    final delay = index * 120;
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
          offset: Offset(0, 15 * (1 - animation.value)),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
      child: Text(text, style: style),
    );
  }
}
