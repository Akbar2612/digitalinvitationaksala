import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoveStorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Title
          Text(
            'Our Love Story',
            style: GoogleFonts.lobster(
              fontSize: 32,
              fontWeight: FontWeight.w300,
              color: Color(0xFFF5F5F5),
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8),

          // Divider Line
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

          // Subtitle
          Text(
            'The journey of our beautiful love',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFB0B0B0),
              letterSpacing: 0.5,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 32),

          // Story Cards
          _buildStoryCard(
            title: 'Kencan Pertama',
            date: '17 Agustus 2021',
            description:
                'Kami belum tahu pasti kapan rasa itu tumbuh mungkin dari senyuman yang singkat, sapaan ringan yang canggung, atau obrolan sederhana lewat pesan teks. Namun yang kami ingat, kencan pertama itu membawa arti. Bersepeda motor ke Pacet, Mojokerto, di tengah semarak HUT RI ke-76, kami menikmati alam dan suasana penuh warna. Sejak saat itu, hati kami perlahan saling terikat.',
          ),

          SizedBox(height: 16),

          _buildStoryCard(
            title: 'Perjalanan Menjalin Asmara',
            date: '2021 • 2022 • 2023 • 2024',
            description:
                'Waktu berjalan, kisah kami tumbuh bersama. Kami belajar mencintai bukan hanya dalam bahagia, tapi juga dalam perjuangan. Menemani satu sama lain melewati masa perkuliahan, organisasi, dan hiruk pikuk dunia muda. Di antara tumpukan tugas, segelas kopi, dan semangat yang tak pernah padam, kami menemukan arti saling mendukung. Kami belajar bahwa cinta bukan hanya rasa, melainkan kesediaan untuk tumbuh bersama.',
          ),

          SizedBox(height: 24),

          _buildStoryCard(
            title: 'Perjumpaan dengan Orang Tua',
            date: '2024',
            description:
                'Tahun itu, cinta kami mulai melangkah lebih pasti. Kami mempertemukan dua keluarga, dua dunia yang berbeda namun disatukan oleh niat yang sama. Pertemuan itu sederhana, namun hangat. Di sana kami melihat restu, dan dalam restu itu kami menemukan ketenangan untuk melangkah lebih jauh.',
          ),

          SizedBox(height: 24),

          _buildStoryCard(
            title: 'Lamaran',
            date: '24 Februari 2025',
            description:
                'Hari di mana niat berubah menjadi janji. Kami memutuskan untuk mengikat cinta dalam langkah yang lebih sakral. Dengan doa yang mengalun dan tatapan penuh harap, kami menyematkan komitmen bukan hanya untuk hari ini, tetapi untuk hari-hari yang akan datang.',
          ),

          SizedBox(height: 24),

          _buildStoryCard(
            title: 'Akad Nikah',
            date: '09 Desember 2025',
            description:
                'Hari yang dinanti pun tiba. Di hadapan keluarga dan dengan ridha Allah SWT, kami mengikat janji suci untuk saling menjaga dan mencintai. Dari pertemuan yang sederhana hingga ikrar di pelaminan, kami percaya inilah takdir indah yang telah Allah tuliskan untuk kami.',
          ),

          SizedBox(height: 24),

          _buildClosingCard(),
        ],
      ),
    );
  }

  Widget _buildStoryCard({
    required String title,
    required String date,
    required String description,
  }) {
    return Container(
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
          // Title
          Text(
            title,
            style: GoogleFonts.lobster(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Color(0xFFF5F5F5),
              letterSpacing: 0.8,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8),

          // Date
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFD4AF37),
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16),

          // Divider
          Container(
            height: 1,
            color: Color(0xFFF5F5F5).withOpacity(0.1),
          ),

          SizedBox(height: 16),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFFE0E0E0),
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildClosingCard() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFD4AF37).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Title
          Text(
            'Selamanya...',
            style: GoogleFonts.lobster(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Color(0xFFD4AF37),
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16),

          // Divider
          Container(
            height: 1,
            color: Color(0xFFD4AF37).withOpacity(0.3),
          ),

          SizedBox(height: 16),

          // Closing Text
          Text(
            'Cinta bagi kami bukan sekadar rasa yang hadir, melainkan perjalanan jiwa untuk saling memahami dan bertumbuh. Ia tak diukur dari panjangnya waktu, tetapi dari ketulusan yang terus diperbarui setiap hari.\n\nKami percaya, cinta sejati bukan tentang memiliki, melainkan tentang merawat dengan sabar, dengan doa, dan dengan kesetiaan. Sebab pada akhirnya, cinta bukan sekadar takdir yang ditemukan, melainkan amanah yang dijaga hingga akhir waktu.\n\nDan dalam setiap langkah ke depan, kami ingin terus memilih satu sama lain dengan hati yang sama, dalam ridha Allah SWT, untuk selamanya.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFFE0E0E0),
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}