import 'package:flutter/material.dart';
import '../data/wedding_data.dart';

class CardPengantin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(brideName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('&', style: TextStyle(fontSize: 24, color: Colors.pinkAccent)),
            Text(groomName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
