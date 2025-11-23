import 'package:digitalinvitationaksala/shared/flowerside.dart';
import 'package:digitalinvitationaksala/shared/widget_playlist.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/wedding_data.dart';

class HomeMobile extends StatefulWidget {
  final String guestName;
  final String guestAddress;
  final AnimationController animationController;
  final VoidCallback onOpenInvitation;
  final MusicPlaylistController musicController;

  const HomeMobile({
    Key? key,
    required this.guestName,
    required this.guestAddress,
    required this.animationController,
    required this.onOpenInvitation,
    required this.musicController,
  }) : super(key: key);

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  bool _showPlaylist = false;

  void _togglePlaylist() {
    setState(() {
      _showPlaylist = !_showPlaylist;
    });
  }

  void _handleOpenInvitation() {
    // Play musik ketika tombol "Buka Undangan" diklik
    widget.musicController.play();

    // Panggil callback original
    widget.onOpenInvitation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
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

        // Gradient overlay
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

        Positioned(
          top: -50,
          right: -70,
          child: Transform.rotate(
            angle: 180,
            child: FlowerCornerDecoration(
              size: 250,
              delay: Duration(milliseconds: 500),
            ),
          ),
        ),

        Positioned(
          bottom: -50,
          left: -70,
          child: Transform.rotate(
            angle: 0,
            child: FlowerCornerDecoration(
              size: 250,
              delay: Duration(milliseconds: 500),
            ),
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 120,
            left: 40,
            right: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_buildAnimatedContent()],
          ),
        ),

        // Tap outside to close playlist
        if (_showPlaylist)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _showPlaylist = false),
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),

        // Playlist widget - animasi show/hide
        Positioned(
          bottom: 90,
          right: 20,
          left: 20,
          child: AnimatedSlide(
            offset: _showPlaylist ? Offset.zero : Offset(0, 0.5),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(
              opacity: _showPlaylist ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: !_showPlaylist,
                child: MusicPlaylist(
                  controller: widget.musicController,
                  primaryColor: Color(0xFFD4AF37),
                  backgroundColor: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
        ),

        // Music Button (Bottom Right)
        Positioned(
          bottom: 20,
          right: 20,
          child: MusicFloatingButton(
            controller: widget.musicController,
            showPlaylist: _showPlaylist,
            onTap: _togglePlaylist,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedContent() {
    int textIndex = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bride & Groom names
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedText(
                text: groomnickName,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 46,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFF5F5F5),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
                index: textIndex++,
              ),
              _buildAnimatedText(
                text: "& $bridenickName",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 46,
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

        // Guest card
        _buildStyledTamuCard(textIndex),

        SizedBox(height: 10),

        // Date
        _buildAnimatedText(
          text: 'Selasa, 09 Desember 2025',
          style: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w400,
          ),
          index: textIndex + 3,
        ),
        SizedBox(height: 24),
        _buildOpenInvitationButton(textIndex + 4),
      ],
    );
  }

  Widget _buildStyledTamuCard(int baseIndex) {
    int textIndex = baseIndex;

    final animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: widget.animationController,
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
                  text: widget.guestName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                    letterSpacing: 0.5,
                  ),
                  index: textIndex++,
                ),
                if (widget.guestAddress.isNotEmpty) ...[
                  SizedBox(height: 6),
                  _buildAnimatedText(
                    text: widget.guestAddress,
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
          parent: widget.animationController,
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
            parent: widget.animationController,
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
              onPressed: _handleOpenInvitation,
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
        parent: widget.animationController,
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
