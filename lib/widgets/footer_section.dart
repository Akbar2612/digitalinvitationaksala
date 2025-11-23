import 'package:digitalinvitationaksala/shared/contact_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FooterSection extends StatelessWidget {
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
            onTap: () => ContactDialog.show(context), // Gunakan ContactDialog
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
