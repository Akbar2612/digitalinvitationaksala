import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFB6C1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 4,
          ),
        ),
      ),
      home: LandingPage(),
    );
  }
}

// ========== DATA PERNIKAHAN ==========
final String guestName = 'Bapak/Ibu Tamu Hormat';
final brideName = 'S Linda Rohmana Wulansari';
final groomName = 'Moh Akbar Aulia Firdaus';
final parentsBride = 'Bapak Budi Santoso & Ibu Putri Wulandari';
final parentsGroom = 'Bapak Slamet Riyadi & Ibu Ani Susanti';
final venueAddress = 'Gedung Serbaguna Merdeka, Jl. Mawar No.10, Jakarta Selatan';
final metStory = 'Kami pertama bertemu di sebuah acara kampus pada tahun 2018. Dari perkenalan sederhana, tumbuh kebersamaan yang indah hingga akhirnya memutuskan untuk melangkah ke jenjang pernikahan.';
final akadDate = DateTime(2026, 4, 10, 9, 0);
final resepsiDate = DateTime(2026, 4, 10, 19, 0);
final List<String> photoUrls = [
  'https://images.unsplash.com/photo-1519741497674-611481863552?w=1200',
  'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=1200',
  'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=1200',
  'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=1200',
];
final bankName = 'Bank BCA';
final accountNumber = '1234567890';
final accountName = 'Siti Aisyah';

// ========== LANDING PAGE ==========
class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openInvitation() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => InvitationPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFE4E1), Color(0xFFFFB6C1), Color(0xFFFFDAB9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          // Falling hearts animation (optional - custom painter)
          Positioned.fill(
            child: CustomPaint(
              painter: HeartsPainter(),
            ),
          ),

          // Main content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 600),
                      child: Card(
                        elevation: 16,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [Colors.white, Color(0xFFFFFAF0)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          padding: EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Decorative icon
                              Icon(
                                Icons.favorite,
                                size: 60,
                                color: Color(0xFFD4AF37),
                              ),
                              SizedBox(height: 20),
                              
                              // Header text
                              Text(
                                'The Wedding of',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(height: 12),
                              
                              // Couple names with Great Vibes font
                              Text(
                                brideName,
                                style: GoogleFonts.greatVibes(
                                  fontSize: 48,
                                  color: Color(0xFFFFB6C1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '&',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  color: Color(0xFFD4AF37),
                                ),
                              ),
                              Text(
                                groomName,
                                style: GoogleFonts.greatVibes(
                                  fontSize: 48,
                                  color: Color(0xFFFFB6C1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 24),
                              
                              Divider(color: Color(0xFFD4AF37), thickness: 2),
                              SizedBox(height: 24),
                              
                              // Guest name
                              Text(
                                'Kepada Yth.',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                guestName,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF8B4513),
                                ),
                              ),
                              SizedBox(height: 24),
                              
                              // Invitation message
                              Text(
                                'Dengan penuh kebahagiaan, kami mengundang Anda untuk hadir dan berbagi kebahagiaan di hari istimewa kami.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.6,
                                ),
                              ),
                              SizedBox(height: 32),
                              
                              // Open invitation button
                              ElevatedButton.icon(
                                onPressed: _openInvitation,
                                icon: Icon(Icons.mail_outline, size: 24),
                                label: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                  child: Text(
                                    'Buka Undangan',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFD4AF37),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 8,
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
            ),
          ),
        ],
      ),
    );
  }
}

// ========== CUSTOM HEARTS PAINTER ==========
class HeartsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFFFB6C1).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw some random hearts
    for (int i = 0; i < 10; i++) {
      final x = (i * size.width / 10) + 20;
      final y = (i * 50.0) % size.height;
      _drawHeart(canvas, paint, Offset(x, y), 20);
    }
  }

  void _drawHeart(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    path.moveTo(center.dx, center.dy + size / 4);
    
    // Left curve
    path.cubicTo(
      center.dx - size / 2, center.dy - size / 4,
      center.dx - size, center.dy + size / 4,
      center.dx, center.dy + size,
    );
    
    // Right curve
    path.cubicTo(
      center.dx + size, center.dy + size / 4,
      center.dx + size / 2, center.dy - size / 4,
      center.dx, center.dy + size / 4,
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ========== MAIN INVITATION PAGE ==========
class InvitationPage extends StatefulWidget {
  @override
  _InvitationPageState createState() => _InvitationPageState();
}

class _InvitationPageState extends State<InvitationPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
  }


  void _toggleMusic() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFFAF0), Color(0xFFFFE4E1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                _HeaderSection(),
                _ParentsSection(),
                _EventDetailsSection(),
                _StorySection(),
                _PhotoCarouselSection(),
                _WishesSection(),
                _GiftSection(),
                SizedBox(height: 100),
              ],
            ),
          ),

          // Music control button (bottom right)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _toggleMusic,
              backgroundColor: Color(0xFFD4AF37),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),

          // Share button (bottom left)
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                Share.share(
                  'Anda diundang ke pernikahan $brideName & $groomName pada ${DateFormat.yMMMMd().format(resepsiDate)}',
                );
              },
              backgroundColor: Color(0xFFFFB6C1),
              child: Icon(Icons.share, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ========== HEADER SECTION ==========
class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        children: [
          Icon(Icons.favorite, size: 50, color: Color(0xFFD4AF37)),
          SizedBox(height: 16),
          Text(
            'We Are Getting Married',
            style: GoogleFonts.poppins(
              fontSize: 16,
              letterSpacing: 3,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          Text(
            brideName,
            style: GoogleFonts.greatVibes(
              fontSize: 56,
              color: Color(0xFFFFB6C1),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '&',
            style: GoogleFonts.poppins(
              fontSize: 28,
              color: Color(0xFFD4AF37),
            ),
          ),
          Text(
            groomName,
            style: GoogleFonts.greatVibes(
              fontSize: 56,
              color: Color(0xFFFFB6C1),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            DateFormat('EEEE, dd MMMM yyyy').format(resepsiDate),
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ========== PARENTS SECTION ==========
class _ParentsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Putra & Putri dari',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B4513),
            ),
          ),
          SizedBox(height: 20),
          _ParentCard(title: 'Mempelai Wanita', parents: parentsBride),
          SizedBox(height: 16),
          _ParentCard(title: 'Mempelai Pria', parents: parentsGroom),
        ],
      ),
    );
  }
}

class _ParentCard extends StatelessWidget {
  final String title;
  final String parents;

  _ParentCard({required this.title, required this.parents});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFFAF0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFFFB6C1), width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xFFFFB6C1),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            parents,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

// ========== EVENT DETAILS SECTION ==========
class _EventDetailsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          _EventCard(
            icon: Icons.mosque,
            title: 'Akad Nikah',
            date: DateFormat('EEEE, dd MMMM yyyy').format(akadDate),
            time: DateFormat('HH:mm').format(akadDate) + ' WIB',
            venue: venueAddress,
          ),
          SizedBox(height: 16),
          _EventCard(
            icon: Icons.celebration,
            title: 'Resepsi',
            date: DateFormat('EEEE, dd MMMM yyyy').format(resepsiDate),
            time: DateFormat('HH:mm').format(resepsiDate) + ' WIB',
            venue: venueAddress,
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final uri = Uri.parse(
                'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(venueAddress)}',
              );
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
            icon: Icon(Icons.map),
            label: Text('Buka Lokasi di Maps'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD4AF37),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String time;
  final String venue;

  _EventCard({
    required this.icon,
    required this.title,
    required this.date,
    required this.time,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Color(0xFFFFB6C1)),
          SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B4513),
            ),
          ),
          SizedBox(height: 8),
          Text(
            date,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
          ),
          Text(
            time,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD4AF37),
            ),
          ),
          SizedBox(height: 12),
          Text(
            venue,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

// ========== STORY SECTION ==========
class _StorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.favorite_border, size: 40, color: Color(0xFFFFB6C1)),
          SizedBox(height: 16),
          Text(
            'Our Love Story',
            style: GoogleFonts.greatVibes(
              fontSize: 36,
              color: Color(0xFFFFB6C1),
            ),
          ),
          SizedBox(height: 16),
          Text(
            metStory,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ========== PHOTO CAROUSEL SECTION ==========
class _PhotoCarouselSection extends StatefulWidget {
  @override
  _PhotoCarouselSectionState createState() => _PhotoCarouselSectionState();
}

class _PhotoCarouselSectionState extends State<_PhotoCarouselSection> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Auto-play carousel
    Future.delayed(Duration(seconds: 1), () {
      _autoPlay();
    });
  }

  void _autoPlay() {
    if (!mounted) return;
    Future.delayed(Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % photoUrls.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
      _autoPlay();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Our Moments',
              style: GoogleFonts.greatVibes(
                fontSize: 36,
                color: Color(0xFFFFB6C1),
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 400,
            child: PageView.builder(
              controller: _pageController,
              itemCount: photoUrls.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                    }
                    return Center(
                      child: SizedBox(
                        height: Curves.easeInOut.transform(value) * 400,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        photoUrls[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              photoUrls.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Color(0xFFFFB6C1)
                      : Color(0xFFFFB6C1).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ========== WISHES SECTION ==========
class _WishesSection extends StatefulWidget {
  @override
  _WishesSectionState createState() => _WishesSectionState();
}

class _WishesSectionState extends State<_WishesSection> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _wishes = [
    {'name': 'Rina Kartika', 'message': 'Selamat menempuh hidup baru! Semoga langgeng selalu.'},
    {'name': 'Budi Santoso', 'message': 'Barakallah! Semoga menjadi keluarga sakinah mawaddah warahmah.'},
  ];

  void _addWish() {
    final name = _nameController.text.trim();
    final message = _messageController.text.trim();
    
    if (name.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mohon isi nama dan ucapan')),
      );
      return;
    }

    setState(() {
      _wishes.insert(0, {'name': name, 'message': message});
      _nameController.clear();
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Ucapan & Doa',
              style: GoogleFonts.greatVibes(
                fontSize: 36,
                color: Color(0xFFFFB6C1),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nama Anda',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Color(0xFFFFFAF0),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _messageController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Ucapan & Doa',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Color(0xFFFFFAF0),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: _addWish,
              icon: Icon(Icons.send),
              label: Text('Kirim Ucapan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4AF37),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ),
          SizedBox(height: 24),
          Divider(),
          SizedBox(height: 16),
          ..._wishes.map((wish) => _WishCard(
            name: wish['name']!,
            message: wish['message']!,
          )).toList(),
        ],
      ),
    );
  }
}

class _WishCard extends StatelessWidget {
  final String name;
  final String message;

  _WishCard({required this.name, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFFAF0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFFFB6C1).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFFFB6C1),
                child: Text(
                  name[0].toUpperCase(),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 12),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

// ========== GIFT SECTION ==========
class _GiftSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.card_giftcard, size: 50, color: Color(0xFFD4AF37)),
          SizedBox(height: 16),
          Text(
            'Wedding Gift',
            style: GoogleFonts.greatVibes(
              fontSize: 36,
              color: Color(0xFFFFB6C1),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Doa Restu Anda merupakan karunia yang sangat berarti bagi kami. Namun jika memberi adalah ungkapan tanda kasih Anda, Anda dapat memberi kado secara cashless.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          SizedBox(height: 24),
          
          // QR Code
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFFFAF0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFFFB6C1), width: 2),
            ),
            child: Column(
              children: [
                QrImageView(
                  data: '$bankName\n$accountNumber\n$accountName',
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  bankName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B4513),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      accountNumber,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.copy, color: Color(0xFFFFB6C1)),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: accountNumber));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Nomor rekening berhasil disalin'),
                            backgroundColor: Color(0xFFD4AF37),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  'a.n. $accountName',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          
          // Thank you message
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFFE4E1).withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(Icons.favorite, color: Color(0xFFFFB6C1), size: 30),
                SizedBox(height: 12),
                Text(
                  'Terima Kasih',
                  style: GoogleFonts.greatVibes(
                    fontSize: 28,
                    color: Color(0xFFFFB6C1),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Merupakan suatu kehormatan dan kebahagiaan bagi kami apabila Bapak/Ibu/Saudara/i berkenan hadir untuk memberikan doa restu kepada kami.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Kami yang berbahagia,',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '$brideName & $groomName',
                  style: GoogleFonts.greatVibes(
                    fontSize: 24,
                    color: Color(0xFFFFB6C1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}