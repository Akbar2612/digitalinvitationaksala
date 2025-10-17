import 'package:flutter/material.dart';
import '../data/wedding_data.dart';

class CardOrangTua extends StatelessWidget {
  const CardOrangTua({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Orang Tua Mempelai Wanita', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(parentsBride),
            SizedBox(height: 12),
            Text('Orang Tua Mempelai Pria', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(parentsGroom),
          ],
        ),
      ),
    );
  }
}
