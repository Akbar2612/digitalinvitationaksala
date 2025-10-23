import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/wedding_data.dart';
import 'dart:async';

class AcaraLokasiSection extends StatefulWidget {
  @override
  State<AcaraLokasiSection> createState() => _AcaraLokasiSectionState();
}

class _AcaraLokasiSectionState extends State<AcaraLokasiSection> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _calculateTimeLeft();
        });
      }
    });
  }

  void _calculateTimeLeft() {
    final eventDateTime = DateTime(2025, 12, 9, 9, 0, 0);
    final now = DateTime.now();
    _timeLeft = eventDateTime.difference(now);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _padZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  Future<void> _openMaps() async {
    final Uri url = Uri.parse(locationUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours.remainder(24);
    final minutes = _timeLeft.inMinutes.remainder(60);
    final seconds = _timeLeft.inSeconds.remainder(60);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ===== ACARA SECTION =====
          Text(
            'Acara Pernikahan',
            style: GoogleFonts.lobster(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Color(0xFFF5F5F5),
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 10),

          // Date with intro text
          Text(
            'Dengan memohon rahmat dan ridho Allah SWT, kami mengharap kehadiran Bapak / Ibu / Saudara / i pada acara pernikahan kami',
            style: GoogleFonts.roboto(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Color(0xFFB8B8B8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),

          // Date
          Text(
            ResepsiDate,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFFF5F5F5),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "18 Jumadil Akhir 1447 H",
            style: GoogleFonts.roboto(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: Color(0xFFB8B8B8),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),

          // Countdown Section
          Column(
            children: [
              Text(
                'Menuju Hari Bahagia',
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  color: Color(0xFFB0B0B0),
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCountdownBox(
                    days > 99 ? days.toString() : _padZero(days),
                    'Hari',
                  ),
                  SizedBox(width: 10),
                  _buildCountdownBox(_padZero(hours), 'Jam'),
                  SizedBox(width: 10),
                  _buildCountdownBox(_padZero(minutes), 'Menit'),
                  SizedBox(width: 10),
                  _buildCountdownBox(_padZero(seconds), 'Detik'),
                ],
              ),
            ],
          ),

          SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Akad Nikah',
                      style: GoogleFonts.lobster(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFF5F5F5),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      AkadTime,
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        letterSpacing: 0.4,
                        color: Color(0xFFB8B8B8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Color(0xFFF5F5F5).withOpacity(0.1),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Resepsi',
                      style: GoogleFonts.lobster(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFF5F5F5),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      ResepsiTime,
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        letterSpacing: 0.4,
                        color: Color(0xFFB8B8B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),
          Container(height: 1, color: Color(0xFFF5F5F5).withOpacity(0.1)),

          SizedBox(height: 16),
          Text(
            'Lokasi Acara',
            style: GoogleFonts.lobster(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Color(0xFFF5F5F5),
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 10),

          // Location Icon
          Icon(Icons.location_on_outlined, color: Color(0xFFF5F5F5), size: 28),
          SizedBox(height: 8),

          // Location details
          Text(
            'Rumah Mempelai Wanita',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Color(0xFFD4AF37),
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2),
          Text(
            ResepsiLocation,
            style: GoogleFonts.roboto(
              fontSize: 11,
              color: Color(0xFFF5F5F5),
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 12),

          // Button
          ElevatedButton.icon(
            onPressed: _openMaps,
            icon: Icon(Icons.directions, size: 16),
            label: Text(
              'BUKA GOOGLE MAPS',
              style: GoogleFonts.roboto(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF5F5F5),
              foregroundColor: Color(0xFF1a1a1a),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
          ),

          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildCountdownBox(String value, String label) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFF5F5F5).withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1a1a),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 10,
            letterSpacing: 0.6,
            color: Color(0xFFB8B8B8),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
