import 'package:flutter/material.dart';
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFF2d2d2d),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFD4AF37).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          children: [
            // Header
            Icon(
              Icons.location_on_outlined,
              color: Color(0xFFD4AF37),
              size: 32,
            ),
            SizedBox(height: 16),
            Text(
              'LOKASI ACARA',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                color: Color(0xFFB8B8B8),
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 40,
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Color(0xFFD4AF37),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Location details
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFF4a4a4a),
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    eventLocation,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Button
            ElevatedButton.icon(
              onPressed: _openMaps,
              icon: Icon(Icons.directions),
              label: Text(
                'BUKA GOOGLE MAPS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
