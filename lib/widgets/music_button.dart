import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicButton extends StatefulWidget {
  const MusicButton({super.key});

  @override
  State<MusicButton> createState() => _MusicButtonState();
}

class _MusicButtonState extends State<MusicButton> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  void _toggleMusic() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      await _player.play(AssetSource('music.mp3')); // pastikan file di assets/music.mp3
    }
    setState(() => isPlaying = !isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle, size: 40, color: Colors.pinkAccent),
      onPressed: _toggleMusic,
    );
  }
}
