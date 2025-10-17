import 'package:flutter/material.dart';
import '../data/wedding_data.dart';

class CardOrangTua extends StatelessWidget {
  const CardOrangTua({super.key});

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
            Text(
              'KELUARGA KEDUA MEMPELAI',
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
            
            // Bride's parents
            _buildParentSection(
              'Orang Tua Mempelai Wanita',
              parentsBride,
              Icons.favorite_border,
            ),
            
            SizedBox(height: 28),
            
            // Divider
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFF4a4a4a),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: Color(0xFFD4AF37),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4a4a4a),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 28),
            
            // Groom's parents
            _buildParentSection(
              'Orang Tua Mempelai Pria',
              parentsGroom,
              Icons.favorite_border,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParentSection(String title, String names, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: Color(0xFFD4AF37),
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD4AF37),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              icon,
              size: 16,
              color: Color(0xFFD4AF37),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFF1a1a1a),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFF4a4a4a),
              width: 0.5,
            ),
          ),
          child: Text(
            names,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}