import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QRShareSection extends StatelessWidget {
  const QRShareSection({super.key});

  void _shareInvitation() {
    Share.share('Yuk datang ke acara pernikahan kami 💕');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            QrImageView(
              data: 'https://example.com/undangan',
              version: QrVersions.auto,
              size: 120,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _shareInvitation,
              icon: const Icon(Icons.share),
              label: const Text('Bagikan Undangan'),
            ),
          ],
        ),
      ),
    );
  }
}
