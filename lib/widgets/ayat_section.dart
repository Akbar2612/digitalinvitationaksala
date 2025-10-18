import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AyatSuciSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Combined Container
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFF5F5F5).withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Arabic Text
                Text(
                  'وَمِنْ آيَاتِهِ أَنْ خَلَقَ لَكُم مِّنْ أَنفُسِكُمْ أَزْوَاجًا لِّتَسْكُنُوا إِلَيْهَا وَجَعَلَ بَيْنَكُم مَّوَدَّةً وَرَحْمَةً ۚ إِنَّ فِي ذَٰلِكَ لَآيَاتٍ لِّقَوْمٍ يَتَفَكَّرُونَ',
                  style: GoogleFonts.lateef(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFF5F5F5),
                    height: 2.0,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),

                SizedBox(height: 24),

                // Divider
                Container(
                  height: 1,
                  color: Color(0xFFF5F5F5).withOpacity(0.1),
                ),

                SizedBox(height: 24),
                Text(
                  '"Dan di antara tanda-tanda kekuasaan-Nya ialah Dia menciptakan untuk kamu istri-istri dari jenismu sendiri, supaya kamu cenderung dan merasa tenteram kepadanya, dan dijadikan-Nya di antara kamu rasa kasih sayang. Sesungguhnya pada yang demikian itu benar-benar terdapat tanda-tanda bagi kaum yang berfikir."',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFE0E0E0),
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24),

                // Surah Reference
                Text(
                  'QS. Ar-Rum: 21',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF5F5F5),
                    letterSpacing: 0.5,
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