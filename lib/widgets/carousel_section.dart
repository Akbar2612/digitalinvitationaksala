import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselSection extends StatefulWidget {
  @override
  State<CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;
  bool _showGallery = false;

  final List<String> imageUrls = [
    'assets/images/mainbg.jpg',
    'assets/images/secondbg.jpg',
  ];

  final List<String> galleryImages = [
    'assets/images/mainbg.jpg',
    'assets/images/secondbg.jpg',
    'assets/images/mainbg.jpg',
    'assets/images/secondbg.jpg',
    'assets/images/mainbg.jpg',
    'assets/images/secondbg.jpg',
        'assets/images/mainbg.jpg',
    'assets/images/secondbg.jpg',
    'assets/images/mainbg.jpg',
    'assets/images/secondbg.jpg',
        'assets/images/mainbg.jpg',
    'assets/images/secondbg.jpg',
    'assets/images/mainbg.jpg',
    'assets/images/secondbg.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _autoPlay();
    _animationController.forward();
  }

  void _autoPlay() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted && _pageController.hasClients) {
        int nextPage = _currentIndex + 1;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
        _autoPlay();
      }
    });
  }

  void _showFullImage(String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      color: Color(0xFF2d2d2d),
                      child: Icon(Icons.image, color: Colors.white54),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 500,
          child: Stack(
            children: [
              // Carousel with scale effect
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index % imageUrls.length;
                  });
                },
                itemBuilder: (context, index) {
                  final imageUrl = imageUrls[index % imageUrls.length];
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0);
                      }
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 25,
                            spreadRadius: 2,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF2d2d2d),
                                        Color(0xFF1a1a1a),
                                      ],
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.photo_library_rounded,
                                    size: 80,
                                    color: Color(0xFF4a4a4a),
                                  ),
                                );
                              },
                            ),
                            // Enhanced gradient overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.3),
                                    Colors.black.withOpacity(0.85),
                                  ],
                                  stops: [0.4, 0.7, 1.0],
                                ),
                              ),
                            ),
                            // Navigation buttons inside photo
                            Positioned(
                              left: 12,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.4),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.chevron_left_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 12,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    _pageController.nextPage(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.4),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.chevron_right_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              // Enhanced overlay text with animation
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _animationController,
                  child: Column(
                    children: [
                      Text(
                        'Our Special Moments',
                        style: GoogleFonts.greatVibes(
                          fontSize: 28,
                          letterSpacing: 1.2,
                          color: Color(0xFFFFFBF5),
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.6),
                              offset: Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      
                      // Gallery Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showGallery = !_showGallery;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.photo_library_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Foto Galeri',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 12),
                      
                      // Enhanced indicator dots
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            imageUrls.length,
                            (index) => AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: _currentIndex == index ? 32 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentIndex == index
                                    ? Color(0xFFFFFBF5)
                                    : Color(0xFFFFFBF5).withOpacity(0.35),
                                boxShadow: _currentIndex == index
                                    ? [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Floating Gallery Card
        if (_showGallery)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showGallery = false;
                });
              },
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: GestureDetector(
                    onTap: () {}, // Prevent closing when tapping card
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      constraints: BoxConstraints(maxWidth: 400, maxHeight: 500),
                      decoration: BoxDecoration(
                        color: Color(0xFF1a1a1a),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Galeri Foto',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showGallery = false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Gallery Grid
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: GridView.builder(
                                padding: EdgeInsets.only(bottom: 20),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 1,
                                ),
                                itemCount: galleryImages.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => _showFullImage(galleryImages[index]),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          galleryImages[index],
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Color(0xFF2d2d2d),
                                              child: Icon(
                                                Icons.image,
                                                color: Color(0xFF4a4a4a),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}