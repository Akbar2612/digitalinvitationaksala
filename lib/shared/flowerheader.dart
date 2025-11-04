// File: lib/widgets/flower_header_decoration.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlowerHeaderDecoration extends StatefulWidget {
  final double width;
  final double height;
  final Duration duration;
  final Duration delay;

  const FlowerHeaderDecoration({
    Key? key,
    this.width = 400,
    this.height = 180,
    this.duration = const Duration(milliseconds: 2500),
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  State<FlowerHeaderDecoration> createState() => _FlowerHeaderDecorationState();
}

class _FlowerHeaderDecorationState extends State<FlowerHeaderDecoration>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _swayController;

  late Animation<double> _backLeavesFade;
  late Animation<double> _midLeavesFade;
  late Animation<double> _flowersFade;
  late Animation<double> _rosesFade;
  late Animation<double> _frontLeavesFade;

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

    _backLeavesFade = _createFadeAnimation(0.0, 0.25);
    _midLeavesFade = _createFadeAnimation(0.20, 0.45);
    _flowersFade = _createFadeAnimation(0.40, 0.65);
    _rosesFade = _createFadeAnimation(0.60, 0.85);
    _frontLeavesFade = _createFadeAnimation(0.75, 1.0);

    Future.delayed(widget.delay, () {
      if (mounted) {
        _fadeController.forward().then((_) {
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
      width: widget.width,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // === BACK LAYER: Daun latar kiri ===
          Positioned(
            left: widget.width * 0.05,
            top: widget.height * 0.40,
            child: _fadingAsset(
              fadeAnim: _backLeavesFade,
              baseRotation: 0.35,
              swayAmount: 0.038,
              child: Image.asset(
                'assets/images/Asset 15.png',
                width: widget.width * 0.22,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            left: widget.width * 0.12,
            top: widget.height * 0.30,
            child: _fadingAsset(
              fadeAnim: _backLeavesFade,
              baseRotation: 0.25,
              swayAmount: 0.04,
              child: Image.asset(
                'assets/images/Asset 9.png',
                width: widget.width * 0.24,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // === BACK LAYER: Daun latar kanan ===
          Positioned(
            right: widget.width * 0.05,
            top: widget.height * 0.42,
            child: _fadingAsset(
              fadeAnim: _backLeavesFade,
              baseRotation: -0.35,
              swayAmount: 0.038,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  'assets/images/Asset 15.png',
                  width: widget.width * 0.22,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Positioned(
            right: widget.width * 0.12,
            top: widget.height * 0.32,
            child: _fadingAsset(
              fadeAnim: _backLeavesFade,
              baseRotation: -0.28,
              swayAmount: 0.04,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  'assets/images/Asset 9.png',
                  width: widget.width * 0.24,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // === MID LAYER: Daun tengah lebih rapat ===
          Positioned(
            left: widget.width * 0.15,
            top: widget.height * 0.20,
            child: _fadingAsset(
              fadeAnim: _midLeavesFade,
              baseRotation: 0.30,
              swayAmount: 0.042,
              child: Image.asset(
                'assets/images/Asset 13.png',
                width: widget.width * 0.20,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            left: widget.width * 0.22,
            top: widget.height * 0.12,
            child: _fadingAsset(
              fadeAnim: _midLeavesFade,
              baseRotation: 0.38,
              swayAmount: 0.044,
              child: Image.asset(
                'assets/images/Asset 8.png',
                width: widget.width * 0.18,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            left: widget.width * 0.28,
            top: widget.height * 0.08,
            child: _fadingAsset(
              fadeAnim: _midLeavesFade,
              baseRotation: 0.42,
              swayAmount: 0.046,
              child: Image.asset(
                'assets/images/Asset 10.png',
                width: widget.width * 0.16,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            right: widget.width * 0.15,
            top: widget.height * 0.22,
            child: _fadingAsset(
              fadeAnim: _midLeavesFade,
              baseRotation: -0.30,
              swayAmount: 0.042,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  'assets/images/Asset 13.png',
                  width: widget.width * 0.20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Positioned(
            right: widget.width * 0.22,
            top: widget.height * 0.14,
            child: _fadingAsset(
              fadeAnim: _midLeavesFade,
              baseRotation: -0.35,
              swayAmount: 0.044,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  'assets/images/Asset 8.png',
                  width: widget.width * 0.18,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Positioned(
            right: widget.width * 0.28,
            top: widget.height * 0.10,
            child: _fadingAsset(
              fadeAnim: _midLeavesFade,
              baseRotation: -0.40,
              swayAmount: 0.046,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  'assets/images/Asset 10.png',
                  width: widget.width * 0.16,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // === TENGAH: Bunga putih mengisi gap ===
          Positioned(
            left: widget.width * 0.35,
            top: widget.height * 0.05,
            child: _fadingAsset(
              fadeAnim: _flowersFade,
              baseRotation: 0.08,
              swayAmount: 0.052,
              child: Image.asset(
                'assets/images/Asset 11.png',
                width: widget.width * 0.16,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            left: widget.width * 0.42,
            top: widget.height * 0.00,
            child: _fadingAsset(
              fadeAnim: _flowersFade,
              baseRotation: 0.0,
              swayAmount: 0.055,
              child: Image.asset(
                'assets/images/Asset 7.png',
                width: widget.width * 0.18,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            right: widget.width * 0.35,
            top: widget.height * 0.03,
            child: _fadingAsset(
              fadeAnim: _flowersFade,
              baseRotation: -0.05,
              swayAmount: 0.050,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  'assets/images/Asset 11.png',
                  width: widget.width * 0.17,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // === ROSES: Mawar sebagai focal point ===
          Positioned(
            left: widget.width * 0.02,
            top: -widget.height * 0.05,
            child: _fadingAsset(
              fadeAnim: _rosesFade,
              baseRotation: 0.12,
              swayAmount: 0.048,
              child: Image.asset(
                'assets/images/Asset 5.png',
                width: widget.width * 0.28,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            left: widget.width * 0.16,
            top: widget.height * 0.05,
            child: _fadingAsset(
              fadeAnim: _rosesFade,
              baseRotation: 0.18,
              swayAmount: 0.045,
              child: Image.asset(
                'assets/images/Asset 6.png',
                width: widget.width * 0.22,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            right: widget.width * 0.02,
            top: -widget.height * 0.08,
            child: _fadingAsset(
              fadeAnim: _rosesFade,
              baseRotation: -0.10,
              swayAmount: 0.050,
              child: Image.asset(
                'assets/images/Asset 6.png',
                width: widget.width * 0.30,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            right: widget.width * 0.16,
            top: widget.height * 0.08,
            child: _fadingAsset(
              fadeAnim: _rosesFade,
              baseRotation: 0.15,
              swayAmount: 0.046,
              child: Image.asset(
                'assets/images/Asset 5.png',
                width: widget.width * 0.20,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            right: widget.width * 0.24,
            top: widget.height * 0.15,
            child: _fadingAsset(
              fadeAnim: _rosesFade,
              baseRotation: 0.08,
              swayAmount: 0.043,
              child: Image.asset(
                'assets/images/Asset 6.png',
                width: widget.width * 0.17,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // === FRONT LAYER: Daun depan untuk depth ===
          Positioned(
            left: widget.width * 0.25,
            top: widget.height * 0.02,
            child: _fadingAsset(
              fadeAnim: _frontLeavesFade,
              baseRotation: 0.45,
              swayAmount: 0.048,
              child: Image.asset(
                'assets/images/Asset 10.png',
                width: widget.width * 0.14,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            left: widget.width * 0.32,
            top: widget.height * 0.15,
            child: _fadingAsset(
              fadeAnim: _frontLeavesFade,
              baseRotation: 0.35,
              swayAmount: 0.045,
              child: Image.asset(
                'assets/images/Asset 13.png',
                width: widget.width * 0.13,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            right: widget.width * 0.25,
            top: widget.height * 0.00,
            child: _fadingAsset(
              fadeAnim: _frontLeavesFade,
              baseRotation: -0.42,
              swayAmount: 0.050,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  'assets/images/Asset 10.png',
                  width: widget.width * 0.15,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Positioned(
            right: widget.width * 0.32,
            top: widget.height * 0.18,
            child: _fadingAsset(
              fadeAnim: _frontLeavesFade,
              baseRotation: -0.38,
              swayAmount: 0.046,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  'assets/images/Asset 8.png',
                  width: widget.width * 0.14,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
