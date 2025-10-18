import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/wedding_data.dart';
import 'dart:async';

class AcaraSection extends StatefulWidget {
  @override
  State<AcaraSection> createState() => _AcaraSectionState();
}

class _AcaraSectionState extends State<AcaraSection> {
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

  @override
  Widget build(BuildContext context) {
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours.remainder(24);
    final minutes = _timeLeft.inMinutes.remainder(60);
    final seconds = _timeLeft.inSeconds.remainder(60);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Text(
            'Detail Acara',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF5F5F5),
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 32),

          // Date
          Text(
            eventDate,
            style: GoogleFonts.robotoSlab(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF5F5F5),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
           "18 Jumadil Akhir 1447 H",
            style: GoogleFonts.robotoSlab(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Color(0xFFF5F5F5),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),

          // Countdown Section
          Column(
            children: [
              Text(
                'Menuju Hari Bahagia',
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 1.8,
                  color: Color(0xFFB0B0B0),
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCountdownBox(
                      days > 99 ? days.toString() : _padZero(days), 'Hari'),
                  _buildCountdownBox(_padZero(hours), 'Jam'),
                  _buildCountdownBox(_padZero(minutes), 'Menit'),
                  _buildCountdownBox(_padZero(seconds), 'Detik'),
                ],
              ),
            ],
          ),

          SizedBox(height: 48),

          // Akad Nikah & Resepsi Side by Side
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Akad Nikah',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF5F5F5),
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '09:00 - 10:00 WIB',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 0.5,
                        color: Color(0xFFB8B8B8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: Color(0xFFF5F5F5).withOpacity(0.1),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Resepsi',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF5F5F5),
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '11:00 - 12:00 WIB',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 0.5,
                        color: Color(0xFFB8B8B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildCountdownBox(String value, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFF5F5F5).withOpacity(0.1),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1a1a),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 0.8,
            color: Color(0xFFB8B8B8),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetail(String title, String time) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF5F5F5),
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8),
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 0.5,
            color: Color(0xFFB8B8B8),
          ),
        ),
      ],
    );
  }
}