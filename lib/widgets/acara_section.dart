import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/wedding_data.dart';

class AcaraSection extends StatelessWidget {
  const AcaraSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH:mm', 'id_ID');

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Rangkaian Acara', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Akad Nikah'),
            Text('${dateFormat.format(akadDate)} • ${timeFormat.format(akadDate)} WIB'),
            const SizedBox(height: 12),
            Text('Resepsi'),
            Text('${dateFormat.format(resepsiDate)} • ${timeFormat.format(resepsiDate)} WIB'),
          ],
        ),
      ),
    );
  }
}
