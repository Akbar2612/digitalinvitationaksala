import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/wedding_data.dart';

class LokasiSection extends StatelessWidget {
  const LokasiSection({super.key});

  Future<void> _openMaps() async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$venueAddress');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Tidak dapat membuka peta.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Lokasi Acara', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(venueAddress, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _openMaps,
              child: const Text('Buka di Google Maps'),
            ),
          ],
        ),
      ),
    );
  }
}
