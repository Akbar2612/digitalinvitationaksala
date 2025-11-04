// File: lib/widgets/flower1.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlowerCornerDecoration extends StatefulWidget {
  final double size;
  final Duration duration;
  final Duration delay;

  const FlowerCornerDecoration({
    Key? key,
    this.size = 180,
    this.duration = const Duration(milliseconds: 2500),
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  State<FlowerCornerDecoration> createState() => _FlowerCornerDecorationState();
}

class _FlowerCornerDecorationState extends State<FlowerCornerDecoration>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _swayController;

  // Animation fade in untuk setiap asset
  late Animation<double> _leaf1Fade;
  late Animation<double> _leaf2Fade;
  late Animation<double> _leaf3Fade;
  late Animation<double> _leaf4Fade;
  late Animation<double> _leaf5Fade;
  late Animation<double> _flower1Fade;
  late Animation<double> _flower2Fade;
  late Animation<double> _mainRoseFade;
  late Animation<double> _secondRoseFade;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _swayController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    // Fade in sederhana untuk setiap asset
    _leaf1Fade = _createFadeAnimation(0.0, 0.25);
    _leaf2Fade = _createFadeAnimation(0.10, 0.35);
    _leaf3Fade = _createFadeAnimation(0.20, 0.45);
    _leaf4Fade = _createFadeAnimation(0.30, 0.55);
    _leaf5Fade = _createFadeAnimation(0.40, 0.65);
    _flower1Fade = _createFadeAnimation(0.50, 0.70);
    _flower2Fade = _createFadeAnimation(0.60, 0.80);
    _mainRoseFade = _createFadeAnimation(0.70, 0.90);
    _secondRoseFade = _createFadeAnimation(0.80, 1.0);

    Future.delayed(widget.delay, () {
      if (mounted) {
        _fadeController.forward().then((_) {
          // Setelah semua fade in selesai, mulai goyang
          if (mounted) {
            _swayController.repeat(reverse: true);
          }
        });
      }
    });
  }

  Animation<double> _createFadeAnimation(double start, double end) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Interval(start, end, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _swayController.dispose();
    super.dispose();
  }

  Widget _fadingAsset({
    required Animation<double> fadeAnim,
    required double baseRotation,
    required Widget child,
    double swayAmount = 0.03,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([fadeAnim, _swayController]),
      builder: (context, child) {
        // Hanya goyang setelah fade selesai
        final sway = _fadeController.isCompleted
            ? math.sin(_swayController.value * 2 * math.pi) * swayAmount
            : 0.0;

        return Opacity(
          opacity: fadeAnim.value,
          child: Transform.rotate(angle: baseRotation + sway, child: child),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          // Daun 1 (Asset 8)
          Positioned(
            top: widget.size * 0.1,
            right: widget.size * 0.15,
            child: _fadingAsset(
              fadeAnim: _leaf1Fade,
              baseRotation: 0.2,
              swayAmount: 0.04,
              child: Image.asset(
                'assets/images/Asset 8.png',
                width: widget.size * 0.4,
                height: widget.size * 0.4,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Daun 2 (Asset 10)
          Positioned(
            top: widget.size * 0.05,
            left: widget.size * 0.2,
            child: _fadingAsset(
              fadeAnim: _leaf2Fade,
              baseRotation: -0.3,
              swayAmount: 0.035,
              child: Image.asset(
                'assets/images/Asset 10.png',
                width: widget.size * 0.35,
                height: widget.size * 0.35,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Daun 3 (Asset 11)
          Positioned(
            bottom: widget.size * 0.15,
            right: widget.size * 0.05,
            child: _fadingAsset(
              fadeAnim: _leaf3Fade,
              baseRotation: 0.4,
              swayAmount: 0.045,
              child: Image.asset(
                'assets/images/Asset 11.png',
                width: widget.size * 0.45,
                height: widget.size * 0.45,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Daun 4 (Asset 13)
          Positioned(
            top: widget.size * 0.3,
            left: widget.size * 0.05,
            child: _fadingAsset(
              fadeAnim: _leaf4Fade,
              baseRotation: -0.2,
              swayAmount: 0.038,
              child: Image.asset(
                'assets/images/Asset 13.png',
                width: widget.size * 0.38,
                height: widget.size * 0.38,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Daun 5 (Asset 15)
          Positioned(
            bottom: widget.size * 0.25,
            left: widget.size * 0.15,
            child: _fadingAsset(
              fadeAnim: _leaf5Fade,
              baseRotation: -0.15,
              swayAmount: 0.042,
              child: Image.asset(
                'assets/images/Asset 15.png',
                width: widget.size * 0.42,
                height: widget.size * 0.42,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Bunga putih kecil 1 (Asset 7)
          Positioned(
            top: widget.size * 0.2,
            right: widget.size * 0.25,
            child: _fadingAsset(
              fadeAnim: _flower1Fade,
              baseRotation: 0.0,
              swayAmount: 0.05,
              child: Image.asset(
                'assets/images/Asset 7.png',
                width: widget.size * 0.25,
                height: widget.size * 0.25,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Bunga putih kecil 2 (Asset 9)
          Positioned(
            bottom: widget.size * 0.35,
            left: widget.size * 0.25,
            child: _fadingAsset(
              fadeAnim: _flower2Fade,
              baseRotation: 0.0,
              swayAmount: 0.048,
              child: Image.asset(
                'assets/images/Asset 9.png',
                width: widget.size * 0.28,
                height: widget.size * 0.28,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Bunga mawar utama (Asset 5 & 6)
          Positioned(
            top: widget.size * 0.35,
            right: widget.size * 0.35,
            child: _fadingAsset(
              fadeAnim: _mainRoseFade,
              baseRotation: 0.0,
              swayAmount: 0.06,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/Asset 5.png',
                    width: widget.size * 0.45,
                    height: widget.size * 0.45,
                    fit: BoxFit.contain,
                  ),
                  Transform.rotate(
                    angle: 0.3,
                    child: Image.asset(
                      'assets/images/Asset 6.png',
                      width: widget.size * 0.42,
                      height: widget.size * 0.42,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bunga mawar kedua (Asset 6)
          Positioned(
            bottom: widget.size * 0.15,
            right: widget.size * 0.25,
            child: _fadingAsset(
              fadeAnim: _secondRoseFade,
              baseRotation: 0.0,
              swayAmount: 0.055,
              child: Image.asset(
                'assets/images/Asset 6.png',
                width: widget.size * 0.35,
                height: widget.size * 0.35,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
