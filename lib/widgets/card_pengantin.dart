import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/wedding_data.dart';

class CardPengantin extends StatefulWidget {
  @override
  State<CardPengantin> createState() => _CardPenanginState();
}

class _CardPenanginState extends State<CardPengantin>
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

    // Title Animation
    _titleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );

    // Groom Animation (start at 400ms)
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

    // Groom Parent Animation (start at 800ms)
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

    // Love Icon Animation (start at 1200ms)
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

    // Bride Animation (start at 1600ms)
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

    // Bride Parent Animation (start at 2000ms)
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

    // Sequential animation start
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
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Hero Section - Pengantin
          Container(
            height: screenHeight * 0.95,
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
            child: Stack(
              children: [
                // Dark overlay gradient
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(flex: 7),

                      // Title
                      FadeTransition(
                        opacity: _titleOpacity,
                        child: Text(
                          'THE WEDDING OF',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 2.8,
                            color: Color(0xFFB0B0B0),
                            fontWeight: FontWeight.w400,
                          ),
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
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
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
                          child: Text(
                            parentsGroom,
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFD0D0D0),
                              letterSpacing: 0.5,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
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
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
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
                          child: Text(
                            parentsBride,
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFD0D0D0),
                              letterSpacing: 0.5,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      Spacer(flex: 2),

                      // Scroll indicator
                      FadeTransition(
                        opacity: _brideParentOpacity,
                        child: Column(
                          children: [
                            Icon(
                              Icons.expand_more,
                              color: Color(0xFFF5F5F5).withOpacity(0.6),
                              size: 28,
                            ),
                            Text(
                              'Scroll untuk melanjutkan',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFFF5F5F5)
                                    .withOpacity(0.6),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Orang Tua Section
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            padding: EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Color(0xFF2d2d2d),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xFFD4AF37).withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Text(
                  'KELUARGA KEDUA MEMPELAI',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 2,
                    color: Color(0xFFB8B8B8),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xFFD4AF37),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Bride's parents
                _buildParentSection(
                  'Orang Tua Mempelai Wanita',
                  parentsBride,
                  Icons.favorite_border,
                ),

                SizedBox(height: 28),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color(0xFF4a4a4a),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        Icons.circle,
                        size: 6,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF4a4a4a),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 28),

                // Groom's parents
                _buildParentSection(
                  'Orang Tua Mempelai Pria',
                  parentsGroom,
                  Icons.favorite_border,
                ),
              ],
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildParentSection(String title, String names, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: Color(0xFFD4AF37),
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD4AF37),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              icon,
              size: 16,
              color: Color(0xFFD4AF37),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFF1a1a1a),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFF4a4a4a),
              width: 0.5,
            ),
          ),
          child: Text(
            names,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}