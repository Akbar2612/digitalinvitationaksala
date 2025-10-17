import 'package:flutter/material.dart';

// Import semua widget modular
import '../widgets/card_pengantin.dart';
import '../widgets/card_orang_tua.dart';
import '../widgets/carousel_section.dart';
import '../widgets/acara_section.dart';
import '../widgets/lokasi_section.dart';
import '../widgets/qr_share_section.dart';
import '../widgets/music_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan warna tema dari Theme.of(context) agar dinamis
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bagian carousel foto utama
              const CarouselSection(),

              // Kartu pengantin (nama, foto, tanggal)
              const SizedBox(height: 16),
              CardPengantin(),

              // Kartu orang tua kedua mempelai
              const SizedBox(height: 16),
              const CardOrangTua(),

              // Jadwal acara (akad, resepsi, dll)
              const SizedBox(height: 16),
              const AcaraSection(),

              // Lokasi acara (map & alamat)
              const SizedBox(height: 16),
              const LokasiSection(),

              // QR code dan tombol berbagi undangan
              const SizedBox(height: 16),
              const QRShareSection(),

              // Tombol musik di bagian bawah
              const SizedBox(height: 24),
              const MusicButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
