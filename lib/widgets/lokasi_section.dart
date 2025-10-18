import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/wedding_data.dart';

class LokasiSection extends StatelessWidget {
  Future<void> _openMaps() async {
    final Uri url = Uri.parse(locationUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Text(
            'Lokasi Acara',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF5F5F5),
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 32),

          // Location Icon
          Icon(
            Icons.location_on_outlined,
            color: Color(0xFFF5F5F5),
            size: 36,
          ),
          SizedBox(height: 20),

          // Location details
          Column(
            children: [
              Text(
                eventLocation,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Color(0xFFF5F5F5),
                  height: 1.8,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          SizedBox(height: 32),

          // Button
          ElevatedButton.icon(
            onPressed: _openMaps,
            icon: Icon(Icons.directions),
            label: Text(
              'BUKA GOOGLE MAPS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF5F5F5),
              foregroundColor: Color(0xFF1a1a1a),
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),

          SizedBox(height: 48),
        ],
      ),
    );
  }
}