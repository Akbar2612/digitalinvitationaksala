import 'package:flutter/material.dart';
import '../data/wedding_data.dart';

class AcaraSection extends StatelessWidget {
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
              Icons.calendar_today_outlined,
              color: Color(0xFFD4AF37),
              size: 32,
            ),
            SizedBox(height: 16),
            Text(
              'ACARA PERNIKAHAN',
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
            SizedBox(height: 32),
            
            // Akad
            _buildEventCard(
              'AKAD NIKAH',
              '09:00 - 10:00 WIB',
              Icons.favorite,
            ),
            
            SizedBox(height: 16),
            
            // Resepsi
            _buildEventCard(
              'RESEPSI',
              '11:00 - 12:00 WIB',
              Icons.celebration,
            ),
            
            SizedBox(height: 24),
            
            // Date info
            Container(
              padding: EdgeInsets.all(16),
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
                    eventDate,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    eventLocation,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB8B8B8),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(String title, String time, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFD4AF37).withOpacity(0.1),
            Color(0xFFD4AF37).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFD4AF37).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFD4AF37).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Color(0xFFD4AF37),
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFB8B8B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}