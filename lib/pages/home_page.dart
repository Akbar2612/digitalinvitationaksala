import 'package:flutter/material.dart';
import '../widgets/card_pengantin.dart';
import '../widgets/card_orang_tua.dart';
import '../widgets/carousel_section.dart';
import '../widgets/acara_section.dart';
import '../widgets/lokasi_section.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a1a),
              Color(0xFF0a0a0a),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSection(),
              SizedBox(height: 8),
              CardPengantin(),
              CardOrangTua(),
              AcaraSection(),
              LokasiSection(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}