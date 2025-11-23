import 'package:digitalinvitationaksala/shared/bottom_nav.dart';
import 'package:digitalinvitationaksala/shared/flowerside.dart';
import 'package:digitalinvitationaksala/shared/mute_button.dart';
import 'package:digitalinvitationaksala/widgets/acaralokasi_section.dart';
import 'package:digitalinvitationaksala/widgets/ayat_section.dart';
import 'package:digitalinvitationaksala/widgets/carousel_section.dart';
import 'package:digitalinvitationaksala/widgets/footer_section.dart';
import 'package:digitalinvitationaksala/widgets/fotobiru_section.dart';
import 'package:digitalinvitationaksala/widgets/gift_section.dart';
import 'package:digitalinvitationaksala/widgets/love_story_section.dart';
import 'package:digitalinvitationaksala/widgets/ucapan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/wedding_data.dart';

class PengantinDesktop extends StatefulWidget {
  final ScrollController scrollController;
  final int selectedIndex;
  final bool isMuted;
  final GlobalKey<State> pengantinKey;
  final GlobalKey<State> acaraKey;
  final GlobalKey<State> loveStoryKey;
  final GlobalKey<State> fotoKey;
  final GlobalKey<State> ucapanKey;
  final GlobalKey<State> giftKey;
  final Function(int) onMenuItemTapped;
  final VoidCallback onToggleMute;

  const PengantinDesktop({
    Key? key,
    required this.scrollController,
    required this.selectedIndex,
    required this.isMuted,
    required this.pengantinKey,
    required this.acaraKey,
    required this.loveStoryKey,
    required this.fotoKey,
    required this.ucapanKey,
    required this.giftKey,
    required this.onMenuItemTapped,
    required this.onToggleMute,
  }) : super(key: key);

  @override
  State<PengantinDesktop> createState() => _PengantinDesktopState();
}

class _PengantinDesktopState extends State<PengantinDesktop>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _groomController;
  late AnimationController _groomParentController;
  late AnimationController _loveController;
  late AnimationController _brideController;
  late AnimationController _brideParentController;

  late Animation<double> _titleOpacity;
  late Animation<double> _groomOpacity;
  late Animation<double> _groomParentOpacity;
  late Animation<double> _loveOpacity;
  late Animation<double> _brideOpacity;
  late Animation<double> _brideParentOpacity;

  late Animation<Offset> _groomSlide;
  late Animation<Offset> _groomParentSlide;
  late Animation<Offset> _loveSlide;
  late Animation<Offset> _brideSlide;
  late Animation<Offset> _brideParentSlide;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    _titleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );

    _groomController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _groomOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _groomController, curve: Curves.easeInOut),
    );
    _groomSlide = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _groomController, curve: Curves.easeOutCubic),
        );

    _groomParentController = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    _groomParentOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _groomParentController, curve: Curves.easeInOut),
    );
    _groomParentSlide = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _groomParentController,
            curve: Curves.easeOutCubic,
          ),
        );

    _loveController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _loveOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _loveController, curve: Curves.easeInOut),
    );
    _loveSlide = Tween<Offset>(begin: Offset(0, -0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _loveController, curve: Curves.easeOutCubic),
        );

    _brideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _brideOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _brideController, curve: Curves.easeInOut),
    );
    _brideSlide = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _brideController, curve: Curves.easeOutCubic),
        );

    _brideParentController = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    _brideParentOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _brideParentController, curve: Curves.easeInOut),
    );
    _brideParentSlide = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _brideParentController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  void _startAnimationSequence() {
    _titleController.forward();
    Future.delayed(Duration(milliseconds: 400), () {
      _groomController.forward();
    });
    Future.delayed(Duration(milliseconds: 800), () {
      _groomParentController.forward();
    });
    Future.delayed(Duration(milliseconds: 1200), () {
      _loveController.forward();
    });
    Future.delayed(Duration(milliseconds: 1600), () {
      _brideController.forward();
    });
    Future.delayed(Duration(milliseconds: 2000), () {
      _brideParentController.forward();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _groomController.dispose();
    _groomParentController.dispose();
    _loveController.dispose();
    _brideController.dispose();
    _brideParentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: widget.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [_buildHeroSection(), _buildContentSections()],
          ),
        ),
        // Bottom Navigation
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BottomNavMobile(
            selectedIndex: widget.selectedIndex,
            onMenuItemTapped: widget.onMenuItemTapped,
          ),
        ),
        // Mute Button
        Positioned(
          bottom: 100,
          right: 20,
          child: MuteButton(
            isMuted: widget.isMuted,
            onToggleMute: widget.onToggleMute,
            size: 40,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // Background
          _buildBackground(),
          Positioned(
            bottom: 100,
            left: -20,
            child: Transform.rotate(
              angle: 0,
              child: FlowerCornerDecoration(
                size: 180,
                delay: Duration(milliseconds: 20),
              ),
            ),
          ),

          // Kanan bawah (flip horizontal)
          Positioned(
            bottom: 100,
            right: -20,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(-1.0, 1.0),
              child: Transform.rotate(
                angle: 0,
                child: FlowerCornerDecoration(
                  size: 180,
                  delay: Duration(milliseconds: 20),
                ),
              ),
            ),
          ),

          // Content
          _buildHeroContent(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2a2a2a), Color(0xFF1a1a1a), Color(0xFF0a0a0a)],
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/secondbg.jpg'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
                Color(0xFF1a1a1a).withOpacity(1),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 36),
          _buildTitle(),
          SizedBox(height: 10),
          _buildGroomInfo(),
          SizedBox(height: 10),
          _buildLoveIcon(),
          SizedBox(height: 10),
          _buildBrideInfo(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return FadeTransition(
      opacity: _titleOpacity,
      child: Text(
        'The Highest Happiness On Earth\nIs The Happiness Of Marriage',
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 3.0,
          color: Color(0xFFB0B0B0),
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGroomInfo() {
    return Column(
      children: [
        SlideTransition(
          position: _groomSlide,
          child: FadeTransition(
            opacity: _groomOpacity,
            child: Text(
              groomName,
              style: GoogleFonts.lobster(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Color(0xFFF5F5F5),
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 6),
        SlideTransition(
          position: _groomParentSlide,
          child: FadeTransition(
            opacity: _groomParentOpacity,
            child: Column(
              children: [
                Text(
                  "Putra dari Bapak $FatherparentsGroom & $MotherparentsGroom",
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFFD0D0D0),
                    letterSpacing: 0.5,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "Desa Mlati, Kecamatan Kedungpring, Kabupaten Lamongan",
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFFD0D0D0),
                    letterSpacing: 0.5,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoveIcon() {
    return SlideTransition(
      position: _loveSlide,
      child: FadeTransition(
        opacity: _loveOpacity,
        child: Icon(Icons.favorite, color: Color(0xFFD4AF37), size: 18),
      ),
    );
  }

  Widget _buildBrideInfo() {
    return Column(
      children: [
        SlideTransition(
          position: _brideSlide,
          child: FadeTransition(
            opacity: _brideOpacity,
            child: Text(
              brideName,
              style: GoogleFonts.lobster(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Color(0xFFF5F5F5),
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 6),
        SlideTransition(
          position: _brideParentSlide,
          child: FadeTransition(
            opacity: _brideParentOpacity,
            child: Column(
              children: [
                Text(
                  "Putri dari Bapak $FatherparentsBride & $MotherparentsBride",
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFFD0D0D0),
                    letterSpacing: 0.5,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "Desa Gambuhan, Kecamatan Kalitengah, Kabupaten Lamongan",
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFFD0D0D0),
                    letterSpacing: 0.5,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSections() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      color: Color(0xFF1a1a1a),
      child: Column(
        children: [
          Container(key: widget.pengantinKey, child: FotoSection()),
          AyatSuciSection(),
          Container(key: widget.acaraKey, child: AcaraLokasiSection()),
          Container(key: widget.loveStoryKey, child: LoveStorySection()),
          Container(key: widget.fotoKey, child: CarouselSection()),
          Container(key: widget.ucapanKey, child: UcapanSection()),
          Container(key: widget.giftKey, child: WeddingGiftSection()),
          SizedBox(height: 16),
          FooterSection(),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
