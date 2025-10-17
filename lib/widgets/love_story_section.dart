import 'package:flutter/material.dart';
import '../data/wedding_data.dart';

class LoveStorySection extends StatelessWidget {
  const LoveStorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Kisah Cinta Kami', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(metStory, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
