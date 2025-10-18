import 'package:flutter/material.dart';
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
                  Color.fromRGBO(0, 0, 0, 0.05),
                  Color.fromRGBO(0, 0, 0, 0.7),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
        // Content
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Section
              Column(
                children: [
                  // Decorative line top
                  Container(
                    width: 60,
                    height: 2,
                    color: Color(0xFFF5F5F5),
                    margin: EdgeInsets.only(bottom: 20),
                  ),
                  
                  // Invitation text
                  Text(
                    'Kami Mengundang Anda',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      letterSpacing: 2,
                      color: Color(0xFFB0B0B0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  
                  // Bride name
                  Text(
                    brideName,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 42,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  
                  // Ampersand
                  Text(
                    '&',
                    style: TextStyle(
                      fontSize: 36,
                      color: Color(0xFFF5F5F5),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Groom name
                  Text(
                    groomName,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 42,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  
                  // Decorative line
                  Container(
                    width: 60,
                    height: 2,
                    color: Color(0xFFF5F5F5),
                  ),
                  SizedBox(height: 30),
                  
                  // Event date
                  Text(
                    eventDate,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      color: Color(0xFFD0D0D0),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  
                  // Event time
                  Text(
                    eventTime,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                      color: Color(0xFFB0B0B0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  
                  // Guest name placeholder
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFF5F5F5),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Yth. Tamu Undangan',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: Color(0xFFB0B0B0),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '[Nama Tamu]',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: 24,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Bottom Section
              Column(
                children: [
                  // Couple nicknames with calligraphy style
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bridenickName,
                            style: TextStyle(
                              fontSize: 28,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFF5F5F5),
                              fontFamily: 'Playfair Display',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '&',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFB0B0B0),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            groomnickName,
                            style: TextStyle(
                              fontSize: 28,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFF5F5F5),
                              fontFamily: 'Playfair Display',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      // Open invitation button
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
                            SizedBox(width: 12),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
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