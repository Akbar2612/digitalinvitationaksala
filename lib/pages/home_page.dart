import 'package:digitalinvitationaksala/pages/home_desktop.dart';
import 'package:digitalinvitationaksala/pages/pengantin_mobile.dart';
import 'package:digitalinvitationaksala/pages/pengantin_desktop.dart';
import 'package:digitalinvitationaksala/shared/widget_playlist.dart';
import 'package:digitalinvitationaksala/shared/widget_playlist_data.dart'
    show weddingPlaylist;
import 'package:flutter/material.dart';
import 'package:digitalinvitationaksala/services/firestore_service.dart';
import 'package:digitalinvitationaksala/pages/home_mobile.dart';

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
  final String? guestSlug;

  const HomePage({Key? key, this.guestSlug}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _firestoreService = FirestoreService();

  final MusicPlaylistController _musicController = MusicPlaylistController();

  String guestName = 'Tamu Undangan';
  String guestAddress = '';
  bool isLoading = true;
  bool isImagesLoaded = false;

  Widget? _mockupContent;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Initialize music controller dengan playlist
    _musicController.initialize(weddingPlaylist);

    _loadGuestData();

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
    _musicController.dispose();
    super.dispose();
  }

  void _onOpenInvitation(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    // Play musik saat buka undangan
    _musicController.play();

    if (isMobile) {
      // Mobile: Navigate dengan membawa music controller
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              PengantinMobilePage(musicController: _musicController),
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
            child: PengantinDesktopPage(musicController: _musicController),
          ),
        );
      });
    }
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
                  final isMobile = constraints.maxWidth < 768;

                  return isMobile
                      ? HomeMobile(
                          guestName: guestName,
                          guestAddress: guestAddress,
                          animationController: _animationController,
                          musicController: _musicController,
                          onOpenInvitation: () => _onOpenInvitation(context),
                        )
                      : HomeDesktop(
                          guestName: guestName,
                          guestAddress: guestAddress,
                          mockupContent: _mockupContent,
                          musicController: _musicController,
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

// Wrapper page untuk PengantinMobile
class PengantinMobilePage extends StatefulWidget {
  final MusicPlaylistController musicController;

  const PengantinMobilePage({Key? key, required this.musicController})
    : super(key: key);

  @override
  State<PengantinMobilePage> createState() => _PengantinMobilePageState();
}

class _PengantinMobilePageState extends State<PengantinMobilePage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  final GlobalKey _pengantinKey = GlobalKey();
  final GlobalKey _acaraKey = GlobalKey();
  final GlobalKey _loveStoryKey = GlobalKey();
  final GlobalKey _fotoKey = GlobalKey();
  final GlobalKey _ucapanKey = GlobalKey();
  final GlobalKey _giftKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    GlobalKey? targetKey;
    switch (index) {
      case 0:
        targetKey = _pengantinKey;
        break;
      case 1:
        targetKey = _acaraKey;
        break;
      case 2:
        targetKey = _loveStoryKey;
        break;
      case 3:
        targetKey = _fotoKey;
        break;
      case 4:
        targetKey = _ucapanKey;
        break;
      case 5:
        targetKey = _giftKey;
        break;
    }

    if (targetKey?.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey!.currentContext!,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onMenuItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _scrollToSection(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PengantinMobile(
        scrollController: _scrollController,
        selectedIndex: _selectedIndex,
        musicController: widget.musicController, // ✅ TAMBAH INI
        pengantinKey: _pengantinKey,
        acaraKey: _acaraKey,
        loveStoryKey: _loveStoryKey,
        fotoKey: _fotoKey,
        ucapanKey: _ucapanKey,
        giftKey: _giftKey,
        onMenuItemTapped: _onMenuItemTapped,
      ),
    );
  }
}

class PengantinDesktopPage extends StatefulWidget {
  final MusicPlaylistController musicController;

  const PengantinDesktopPage({Key? key, required this.musicController})
    : super(key: key);

  @override
  State<PengantinDesktopPage> createState() => _PengantinDesktopPageState();
}

class _PengantinDesktopPageState extends State<PengantinDesktopPage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  final GlobalKey _pengantinKey = GlobalKey();
  final GlobalKey _acaraKey = GlobalKey();
  final GlobalKey _loveStoryKey = GlobalKey();
  final GlobalKey _fotoKey = GlobalKey();
  final GlobalKey _ucapanKey = GlobalKey();
  final GlobalKey _giftKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    GlobalKey? targetKey;
    switch (index) {
      case 0:
        targetKey = _pengantinKey;
        break;
      case 1:
        targetKey = _acaraKey;
        break;
      case 2:
        targetKey = _loveStoryKey;
        break;
      case 3:
        targetKey = _fotoKey;
        break;
      case 4:
        targetKey = _ucapanKey;
        break;
      case 5:
        targetKey = _giftKey;
        break;
    }

    if (targetKey?.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey!.currentContext!,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onMenuItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _scrollToSection(index);
  }

  void _toggleMute() {
    widget.musicController.toggle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: widget.musicController,
        builder: (context, _) {
          return PengantinDesktop(
            scrollController: _scrollController,
            selectedIndex: _selectedIndex,
            isMuted: !widget.musicController.isPlaying,
            pengantinKey: _pengantinKey,
            acaraKey: _acaraKey,
            loveStoryKey: _loveStoryKey,
            fotoKey: _fotoKey,
            ucapanKey: _ucapanKey,
            giftKey: _giftKey,
            onMenuItemTapped: _onMenuItemTapped,
            onToggleMute: _toggleMute,
          );
        },
      ),
    );
  }
}
