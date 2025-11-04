import 'package:flutter/material.dart';

class MuteButton extends StatelessWidget {
  final bool isMuted;
  final VoidCallback onToggleMute;
  final double size;
  final EdgeInsets? margin;

  const MuteButton({
    Key? key,
    required this.isMuted,
    required this.onToggleMute,
    this.size = 48,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggleMute,
      child: Container(
        margin: margin,
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isMuted
                ? [
                    const Color(0xFFD4AF37).withOpacity(0.9),
                    const Color(0xFFC9A227).withOpacity(0.9),
                  ]
                : const [Color(0xFF1a1a1a), Color(0xFF0f0f0f)],
          ),
          border: Border.all(
            color: Color(0xFFD4AF37).withOpacity(isMuted ? 0.3 : 0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFD4AF37).withOpacity(isMuted ? 0.4 : 0.2),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            isMuted ? Icons.volume_off : Icons.volume_up,
            color: isMuted ? const Color(0xFF1a1a1a) : const Color(0xFFD4AF37),
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
