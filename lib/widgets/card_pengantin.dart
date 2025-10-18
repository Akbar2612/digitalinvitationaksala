import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/wedding_data.dart';

class CardPengantin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2A2A2A).withOpacity(0.4),
            Color(0xFF1A1A1A).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFF5F5F5).withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
         
          
          // Content
          Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              children: [

               
                // Title
                Text(
                  'THE WEDDING OF',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 2.8,
                    color: Color(0xFFB0B0B0),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 32),
                
                // Bride name
                Text(
                  brideName,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF5F5F5),
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 24),
                
                // Ampersand with decoration
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 0.8,
                      color: Color(0xFFF5F5F5).withOpacity(0.3),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        '&',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 36,
                          color: Color(0xFFF5F5F5).withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 0.8,
                      color: Color(0xFFF5F5F5).withOpacity(0.3),
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
                
                // Groom name
                Text(
                  groomName,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF5F5F5),
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),           
              
              ],
            ),
          ),
        ],
      ),
    );
  }
}