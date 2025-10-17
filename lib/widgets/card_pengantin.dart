import 'package:flutter/material.dart';
import '../data/wedding_data.dart';

class CardPengantin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border.all(
          color: Color(0xFFF5F5F5),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative corner lines
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFF5F5F5),
                    width: 1.5,
                  ),
                  left: BorderSide(
                    color: Color(0xFFF5F5F5),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFF5F5F5),
                    width: 1.5,
                  ),
                  right: BorderSide(
                    color: Color(0xFFF5F5F5),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                // Decorative line top
                Container(
                  width: 60,
                  height: 1.5,
                  color: Color(0xFFF5F5F5),
                ),
                SizedBox(height: 24),
                
                // Title
                Text(
                  'THE WEDDING OF',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2.5,
                    color: Color(0xFFB0B0B0),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 28),
                
                // Bride name
                Text(
                  brideName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF5F5F5),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 20),
                
                // Ampersand with decoration
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 1,
                      color: Color(0xFFF5F5F5),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '&',
                        style: TextStyle(
                          fontSize: 32,
                          color: Color(0xFFF5F5F5),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 1,
                      color: Color(0xFFF5F5F5),
                    ),
                  ],
                ),
                
                SizedBox(height: 20),
                
                // Groom name
                Text(
                  groomName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF5F5F5),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 28),
                
                // Decorative line bottom
                Container(
                  width: 60,
                  height: 1.5,
                  color: Color(0xFFF5F5F5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}