import 'package:flutter/material.dart';
import '../widgets/card_pengantin.dart';
import '../widgets/card_orang_tua.dart';
import '../widgets/carousel_section.dart';
import '../widgets/acara_section.dart';
import '../widgets/lokasi_section.dart';
import '../widgets/qr_share_section.dart';
import '../widgets/music_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSection(),
            CardPengantin(),
            CardOrangTua(),
            AcaraSection(),
            LokasiSection(),
            QRShareSection(),
            MusicButton(),
          ],
        ),
      ),
    );
  }
}
