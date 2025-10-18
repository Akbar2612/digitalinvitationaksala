import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/card_pengantin.dart';
import '../widgets/card_orang_tua.dart';
import '../widgets/acara_section.dart';
import '../widgets/lokasi_section.dart';
import '../data/wedding_data.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showInvitation = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a1a),
              Color(0xFF0a0a0a),
            ],
          ),
        ),
        child: _showInvitation
            ? _buildInvitationContent(isMobile)
            : _buildLandingPage(context),
      ),
    );
  }

  Widget _buildLandingPage(BuildContext context) {
    return Stack(
      children: [
        // Background Image
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
        // Dark Overlay
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
                  Align(
  alignment: Alignment.centerLeft,
  child: Column(
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
      Text(
        "& "+bridenickName,
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
),
                  SizedBox(height: 10),
                  // Kami Mengundang
                  Text(
                    'Kami Mengundang',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.5,
                      color: Color(0xFFB0B0B0),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 18),
                  
                  // Tamu
                  Text(
                    'Yth. Tamu Undangan',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB0B0B0),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '[Nama Tamu]',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 22,
                      letterSpacing: 1,
                      color: Color(0xFFF5F5F5),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Decorative line
                  Container(
                    width: 40,
                    height: 1.5,
                    color: Color(0xFFF5F5F5),
                  ),
                  SizedBox(height: 10),
                  
                  // Tanggal
                  Text(
                    eventDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFD0D0D0),
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Waktu
                  Text(
                    eventTime,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB0B0B0),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Lokasi
                  Text(
                    eventLocation,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB0B0B0),
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              
              // Button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showInvitation = true;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Buka Undangan'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationContent(bool isMobile) {
    if (isMobile) {
      return _buildMobileInvitation();
    } else {
      return _buildDesktopInvitation();
    }
  }

  Widget _buildMobileInvitation() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          CardPengantin(),
          CardOrangTua(),
          AcaraSection(),
          LokasiSection(),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDesktopInvitation() {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: CardPengantin()),
                    SizedBox(width: 32),
                    Expanded(child: CardOrangTua()),
                  ],
                ),
                SizedBox(height: 32),
                AcaraSection(),
                SizedBox(height: 32),
                LokasiSection(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}