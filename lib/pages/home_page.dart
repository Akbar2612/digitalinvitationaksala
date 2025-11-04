import 'package:digitalinvitationaksala/pages/home_desktop.dart';
import 'package:digitalinvitationaksala/pages/pengantin_page.dart'
    show CardPengantinPage;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// ignore: unused_import
import 'package:digitalinvitationaksala/data/wedding_data.dart';
import 'package:digitalinvitationaksala/services/firestore_service.dart';
import 'package:digitalinvitationaksala/pages/home_mobile.dart';

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

  const HomePage({Key? key, required this.audioPlayer, this.guestSlug})
    : super(key: key);

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

  // State untuk mockup content (desktop)
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

      await Future.delayed(Duration(milliseconds: 300));

      if (mounted) {
        setState(() {
          isImagesLoaded = true;
        });

        Future.delayed(Duration(milliseconds: 200), () {
          if (mounted) {
            _animationController.forward();
          }
        });
      }
    } catch (e) {
      print('Error preloading images: $e');
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

  void _onOpenInvitation(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      // Mobile: Navigate to new page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              CardPengantinPage(audioPlayer: widget.audioPlayer),
        ),
      );
    } else {
      // Desktop: Update mockup content
      setState(() {
        _mockupContent = MockupContext(
          isInsideMockup: true,
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(size: Size(340, 680), devicePixelRatio: 2.0),
            child: CardPengantinPage(audioPlayer: widget.audioPlayer),
          ),
        );
      });
    }

    _playAudio();
  }

  @override
  Widget build(BuildContext context) {
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
            ? _buildLoadingScreen()
            : LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive breakpoint
                  final isMobile = constraints.maxWidth < 768;

                  return isMobile
                      ? HomeMobile(
                          guestName: guestName,
                          guestAddress: guestAddress,
                          animationController: _animationController,
                          onOpenInvitation: () => _onOpenInvitation(context),
                        )
                      : HomeDesktop(
                          guestName: guestName,
                          guestAddress: guestAddress,
                          mockupContent: _mockupContent,
                          onOpenInvitation: () => _onOpenInvitation(context),
                        );
                },
              ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFD4AF37), strokeWidth: 3),
          SizedBox(height: 24),
          Text(
            'Memuat Undangan...',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
