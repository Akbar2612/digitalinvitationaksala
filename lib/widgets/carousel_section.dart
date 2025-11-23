import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselSection extends StatefulWidget {
  @override
  State<CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<Map<String, dynamic>> galleryImages = [
    {'image': 'assets/images/landscape3.jpeg', 'type': 'landscape'},
    {'image': 'assets/images/potrait1.jpeg', 'type': 'portrait'},
    {'image': 'assets/images/potrait2.jpeg', 'type': 'portrait'},
    {'image': 'assets/images/landscape1.jpeg', 'type': 'landscape'},
    {'image': 'assets/images/landscape2.jpeg', 'type': 'landscape'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Text(
                    'Our Gallery',
                    style: GoogleFonts.greatVibes(
                      fontSize: 36,
                      letterSpacing: 1.2,
                      color: Color(0xFFFFFBF5),
                      fontWeight: FontWeight.w400,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 60,
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
                  SizedBox(height: 12),
                  Text(
                    'Koleksi Momen Indah Kami',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFB0B0B0),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Masonry Gallery dengan ukuran acak
            _buildMasonryGallery(),
          ],
        ),
      ),
    );
  }

  Widget _buildMasonryGallery() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 12.0;
        List<Widget> galleryItems = [];

        for (int i = 0; i < galleryImages.length; i++) {
          final item = galleryImages[i];
          final type = item['type'];

          // Untuk landscape, buat full width
          if (type == 'landscape') {
            galleryItems.add(
              _buildGalleryItem(item['image'], type, constraints.maxWidth),
            );
            galleryItems.add(SizedBox(height: spacing));
          } else {
            // Untuk portrait, buat 2 kolom
            if (i + 1 < galleryImages.length &&
                galleryImages[i + 1]['type'] == 'portrait') {
              // Ada 2 portrait berurutan, buat row
              final nextItem = galleryImages[i + 1];
              final columnWidth = (constraints.maxWidth - spacing) / 2;

              galleryItems.add(
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildGalleryItem(
                        item['image'],
                        type,
                        columnWidth,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: _buildGalleryItem(
                        nextItem['image'],
                        nextItem['type'],
                        columnWidth,
                      ),
                    ),
                  ],
                ),
              );
              galleryItems.add(SizedBox(height: spacing));
              i++; // Skip next item karena sudah diproses
            } else {
              // Portrait tunggal, buat 1 kolom centered
              final columnWidth = (constraints.maxWidth - spacing) / 2;
              galleryItems.add(
                Row(
                  children: [
                    Expanded(
                      child: _buildGalleryItem(
                        item['image'],
                        type,
                        columnWidth,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(child: SizedBox()), // Spacer
                  ],
                ),
              );
              galleryItems.add(SizedBox(height: spacing));
            }
          }
        }

        return Column(children: galleryItems);
      },
    );
  }

  Widget _buildGalleryItem(String imagePath, String type, double width) {
    // Tentukan height berdasarkan type
    double height;
    switch (type) {
      case 'landscape':
        height = width / (16 / 9); // Aspect ratio 16:9
        break;
      case 'portrait':
        height = width / (3 / 4); // Aspect ratio 3:4
        break;
      case 'square':
        height = width; // Aspect ratio 1:1
        break;
      default:
        height = width;
    }

    return GestureDetector(
      onTap: () => _showFullImage(imagePath),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2d2d2d), Color(0xFF1a1a1a)],
                      ),
                    ),
                    child: Icon(
                      Icons.photo_library_rounded,
                      size: 40,
                      color: Color(0xFF4a4a4a),
                    ),
                  );
                },
              ),
              // Hover overlay effect
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                  ),
                ),
              ),
              // Zoom icon indicator
              Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.zoom_in_rounded,
                    color: Colors.white.withOpacity(0.8),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
