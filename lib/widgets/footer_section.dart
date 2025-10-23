import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatelessWidget {
  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(0xFFD4AF37).withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo atau Icon
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFD4AF37).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.favorite, color: Color(0xFFD4AF37), size: 32),
              ),

              SizedBox(height: 16),

              // Company Name
              Text(
                'Aksala Creative Media',
                style: GoogleFonts.lobster(
                  fontSize: 24,
                  color: Color(0xFFD4AF37),
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8),

              // Tagline
              Text(
                'GAMBUHAN - KALITENGAH',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xFFB0B0B0),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              // Divider
              Container(height: 1, color: Color(0xFFD4AF37).withOpacity(0.2)),

              SizedBox(height: 20),

              // Description
              Text(
                'Butuh undangan digital untuk acara spesial Anda?',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Color(0xFFE0E0E0),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16),

              // WhatsApp Button
              InkWell(
                onTap: () async {
                  final url = Uri.parse(
                    'https://wa.me/6285869628014?text=Halo%20Aksala%20Creative%20Media,%20saya%20tertarik%20dengan%20undangan%20digital%20Anda',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF25D366).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'WhatsApp: 085869628014',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Close Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Tutup',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Color(0xFFB0B0B0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFD4AF37).withOpacity(0.2), width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decorative line
          Container(
            width: 60,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFD4AF37).withOpacity(0),
                  Color(0xFFD4AF37),
                  Color(0xFFD4AF37).withOpacity(0),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Main text
          Text(
            'Undangan ini kami buat sendiri dengan sepenuh hati',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Color(0xFFB0B0B0),
              letterSpacing: 0.5,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4),

          // Personal touch
          Text(
            'sebagai bentuk kebahagiaan kami untuk berbagi momen spesial ini',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Color(0xFF909090),
              letterSpacing: 0.3,
              fontWeight: FontWeight.w300,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 12),

          // Divider dengan emoji
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 1,
                color: Color(0xFFD4AF37).withOpacity(0.3),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '♥',
                  style: TextStyle(color: Color(0xFFD4AF37), fontSize: 12),
                ),
              ),
              Container(
                width: 30,
                height: 1,
                color: Color(0xFFD4AF37).withOpacity(0.3),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Info text
          Text(
            'Ingin membuat undangan digital seperti ini?',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Color(0xFF909090),
              letterSpacing: 0.3,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8),

          // Company name - clickable
          InkWell(
            onTap: () => _showContactDialog(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFD4AF37).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(0xFFD4AF37).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app, size: 14, color: Color(0xFFD4AF37)),
                  SizedBox(width: 8),
                  Text(
                    'Aksala Creative Media',
                    style: GoogleFonts.lobster(
                      fontSize: 18,
                      color: Color(0xFFD4AF37),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Decorative line
          Container(
            width: 60,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFD4AF37).withOpacity(0),
                  Color(0xFFD4AF37),
                  Color(0xFFD4AF37).withOpacity(0),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Copyright
          Text(
            '© ${DateTime.now().year} All Rights Reserved',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Color(0xFF808080),
              letterSpacing: 0.5,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
