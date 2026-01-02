import 'dart:math';
import 'package:flutter/material.dart';

class GlowCard extends StatelessWidget {
  final Color glowColor;
  final bool selected;
  final Widget child;

  const GlowCard({
    super.key,
    required this.glowColor,
    required this.child,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final base = const Color(0xFF0B1224);
    final selectedGlow = selected ? 0.55 : 0.25;
    final blur = selected ? 28.0 : 18.0;
    final spread = selected ? 0.8 : 0.2;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            base.withOpacity(0.92),
            Color.lerp(base, glowColor, 0.18)!.withOpacity(0.88),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(selectedGlow),
            blurRadius: blur,
            spreadRadius: spread,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.55),
            blurRadius: 22,
            offset: const Offset(0, 18),
          ),
        ],
        border: Border.all(
          color: glowColor.withOpacity(selected ? 0.55 : 0.18),
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // subtle particles (fake)
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: CustomPaint(painter: _ParticlePainter()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final rnd = Random(7);
    for (int i = 0; i < 38; i++) {
      final dx = rnd.nextDouble() * size.width;
      final dy = rnd.nextDouble() * size.height;
      final r = rnd.nextDouble() * 1.6 + 0.4;
      canvas.drawCircle(Offset(dx, dy), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}