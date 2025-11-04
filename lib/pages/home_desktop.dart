import 'package:digitalinvitationaksala/shared/flower1.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digitalinvitationaksala/data/wedding_data.dart';

class HomeDesktop extends StatelessWidget {
  final String guestName;
  final String guestAddress;
  final Widget? mockupContent;
  final VoidCallback onOpenInvitation;

  const HomeDesktop({
    Key? key,
    required this.guestName,
    required this.guestAddress,
    this.mockupContent,
    required this.onOpenInvitation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background images (Split layout)
        _buildBackgroundImages(),

        // Center gradient overlay
        _buildCenterGradient(),

        // Dark overlay
        _buildDarkOverlay(),

        // Main content
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left section: Wedding info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: _buildWeddingInfo(),
                ),
              ),

              // Center: Phone mockup
              _buildPhoneMockup(context),

              // Right spacer
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundImages() {
    return Positioned.fill(
      child: Row(
        children: [
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
    );
  }

  Widget _buildCenterGradient() {
    return Positioned.fill(
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
    );
  }

  Widget _buildDarkOverlay() {
    return Positioned.fill(
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
    );
  }

  Widget _buildWeddingInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'THE WEDDING OF',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.w300,
            letterSpacing: 4,
          ),
        ),
        SizedBox(height: 24),
        Text(
          groomnickName,
          style: GoogleFonts.playfairDisplay(
            fontSize: 72,
            fontStyle: FontStyle.italic,
            color: Color(0xFFF5F5F5),
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            height: 1.1,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "& $bridenickName",
          style: GoogleFonts.playfairDisplay(
            fontSize: 72,
            fontStyle: FontStyle.italic,
            color: Color(0xFFF5F5F5),
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            height: 1.1,
          ),
        ),
        SizedBox(height: 32),
        Text(
          'Selasa, 09 Desember 2025',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Color(0xFFF5F5F5).withOpacity(0.9),
            fontWeight: FontWeight.w300,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneMockup(BuildContext context) {
    return Container(
      width: 340,
      height: 740,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Container(
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
          child: mockupContent ?? _buildMockupDefaultContent(context),
        ),
      ),
    );
  }

  Widget _buildMockupDefaultContent(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(size: Size(340, 680), devicePixelRatio: 3.0),
      child: _MockupLanding(
        guestName: guestName,
        guestAddress: guestAddress,
        onOpenInvitation: onOpenInvitation,
      ),
    );
  }
}

// Static mockup landing (no animation, used inside mockup)
class _MockupLanding extends StatelessWidget {
  final String guestName;
  final String guestAddress;
  final VoidCallback onOpenInvitation;

  const _MockupLanding({
    Key? key,
    required this.guestName,
    required this.guestAddress,
    required this.onOpenInvitation,
  }) : super(key: key);

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
          top: -40,
          right: -50,
          child: Transform.rotate(
            angle: 180,
            child: FlowerCornerDecoration(
              size: 180,
              delay: Duration(milliseconds: 500),
            ),
          ),
        ),

        Positioned(
          bottom: -40,
          left: -50,
          child: Transform.rotate(
            angle: 0,
            child: FlowerCornerDecoration(
              size: 180,
              delay: Duration(milliseconds: 500),
            ),
          ),
        ),

        // Content
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
                  // Names
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
                        "& $bridenickName",
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

                  // Guest card
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

                  // Date
                  Text(
                    'Selasa, 09 Desember 2025',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Button
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
                    onPressed: onOpenInvitation,
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
}
