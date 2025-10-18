import 'package:digitalinvitationaksala/widgets/acara_section.dart';
import 'package:digitalinvitationaksala/widgets/ayat_section.dart';
import 'package:digitalinvitationaksala/widgets/carousel_section.dart';
import 'package:digitalinvitationaksala/widgets/fotobiru_section.dart';
import 'package:digitalinvitationaksala/widgets/lokasi_section.dart';
import 'package:digitalinvitationaksala/widgets/love_story_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../data/wedding_data.dart';
import '../pages/home_page.dart';

class CardPengantinPage extends StatefulWidget {
  final AudioPlayer? audioPlayer;
  
  CardPengantinPage({this.audioPlayer});

  @override
  State<CardPengantinPage> createState() => _CardPengantinPageState();
}

class _CardPengantinPageState extends State<CardPengantinPage>
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

  int _selectedIndex = 1; // Default ke PENGANTIN
  late ScrollController _scrollController;
  bool _isMuted = false;
  late AudioPlayer _audioPlayer;
  
  final GlobalKey<State> _acaraKey = GlobalKey();
  final GlobalKey<State> _lokasiKey = GlobalKey();
  final GlobalKey<State> _fotoKey = GlobalKey();
  final GlobalKey<State> _loveStoryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Gunakan audio player dari widget atau buat baru
    _audioPlayer = widget.audioPlayer ?? AudioPlayer();
    
    _titleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );

    // Groom Animation
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

    // Groom Parent Animation
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
          parent: _groomParentController, curve: Curves.easeOutCubic),
    );

    // Love Icon Animation
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

    // Bride Animation
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

    // Bride Parent Animation
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
          parent: _brideParentController, curve: Curves.easeOutCubic),
    );

    _startAnimationSequence();
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

  void _toggleMute() async {
    setState(() {
      _isMuted = !_isMuted;
    });
    
    try {
      if (_isMuted) {
        print('Muting audio...');
        await _audioPlayer.pause();
        print('Audio paused - Muted');
      } else {
        print('Unmuting audio...');
        await _audioPlayer.play();
        print('Audio resumed - Unmuted');
      }
    } catch (e) {
      print('Error toggling mute: $e');
    }
  }

  void _onMenuItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0: // HOME
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(audioPlayer: AudioPlayer())),
        );
        break;
      case 1: // PENGANTIN
        // Scroll ke atas halaman
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        break;
      case 2: // ACARA
        _scrollToWidget(_acaraKey);
        break;
      case 3: // LOKASI
        _scrollToWidget(_lokasiKey);
        break;
      case 4: // FOTO
        _scrollToWidget(_fotoKey);
        break;
    }
  }

  void _scrollToWidget(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _groomController.dispose();
    _groomParentController.dispose();
    _loveController.dispose();
    _brideController.dispose();
    _brideParentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF2a2a2a),
                        Color(0xFF1a1a1a),
                        Color(0xFF0a0a0a),
                      ],
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
                // Content
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 160),
                          FadeTransition(
                            opacity: _titleOpacity,
                            child: Text(
                              'The Highest Happiness On Earth\nIs The Happiness Of Marriage',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 2.8,
                                color: Color(0xFFB0B0B0),
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 16),

                          // Groom name
                          SlideTransition(
                            position: _groomSlide,
                            child: FadeTransition(
                              opacity: _groomOpacity,
                              child: Text(
                                groomName,
                                style: GoogleFonts.lobster(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFFF5F5F5),
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          SizedBox(height: 6),

                          // Groom Parents
                          SlideTransition(
                            position: _groomParentSlide,
                            child: FadeTransition(
                              opacity: _groomParentOpacity,
                              child: Column(
                                children: [
                                  Text(
                                    "Putra dari " + parentsGroom,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFFD0D0D0),
                                      letterSpacing: 0.5,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Desa Mlati, Kecamatan Kedungpring, Kabupaten Lamongan",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFFD0D0D0),
                                      letterSpacing: 0.5,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          // Love Icon
                          SlideTransition(
                            position: _loveSlide,
                            child: FadeTransition(
                              opacity: _loveOpacity,
                              child: Icon(
                                Icons.favorite,
                                color: Color(0xFFD4AF37),
                                size: 32,
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          // Bride name
                          SlideTransition(
                            position: _brideSlide,
                            child: FadeTransition(
                              opacity: _brideOpacity,
                              child: Text(
                                brideName,
                                style: GoogleFonts.lobster(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFFF5F5F5),
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          SizedBox(height: 6),

                          // Bride Parents
                          SlideTransition(
                            position: _brideParentSlide,
                            child: FadeTransition(
                              opacity: _brideParentOpacity,
                              child: Column(
                                children: [
                                  Text(
                                    "Putri dari " + parentsBride,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFD0D0D0),
                                      letterSpacing: 0.5,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Desa Gambuhan, Kecamatan Kalitengah, Kabupaten Lamongan",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFFD0D0D0),
                                      letterSpacing: 0.5,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      color: Color(0xFF1a1a1a),
                      child: Column(
                        children: [
                          FotoSection(),
                          AyatSuciSection(),
                          Container(
                            key: _acaraKey,
                            child: AcaraSection(),
                          ),
                          Container(
                            key: _lokasiKey,
                            child: LokasiSection(),
                          ),
                          Container(
                            key: _fotoKey,
                            child: CarouselSection(),
                          ),
                          Container(
                            key: _loveStoryKey,
                            child: LoveStorySection(),
                          ),
                          SizedBox(height: 100), 
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Floating Menu
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1a1a1a),
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFD4AF37).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMenuButton(
                        icon: Icons.home,
                        label: 'HOME',
                        index: 0,
                      ),
                      _buildMenuButton(
                        icon: Icons.favorite,
                        label: 'PENGANTIN',
                        index: 1,
                      ),
                      _buildMenuButton(
                        icon: Icons.calendar_month,
                        label: 'ACARA',
                        index: 2,
                      ),
                      _buildMenuButton(
                        icon: Icons.location_on,
                        label: 'LOKASI',
                        index: 3,
                      ),
                      _buildMenuButton(
                        icon: Icons.photo_library,
                        label: 'FOTO',
                        index: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Floating Mute Button
          Positioned(
            bottom: 120,
            right: 20,
            child: FloatingActionButton(
              onPressed: _toggleMute,
              backgroundColor: _isMuted
                  ? Color(0xFFD4AF37)
                  : Color(0xFF1a1a1a),
              elevation: 8,
              child: Icon(
                _isMuted ? Icons.volume_off : Icons.volume_up,
                color: _isMuted
                    ? Color(0xFF1a1a1a)
                    : Color(0xFFD4AF37),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => _onMenuItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(0xFFD4AF37).withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? Color(0xFFD4AF37)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? Color(0xFFD4AF37)
                  : Color(0xFFB0B0B0),
              size: 24,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isSelected
                  ? Color(0xFFD4AF37)
                  : Color(0xFFB0B0B0),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}