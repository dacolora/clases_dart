import 'package:flutter/material.dart';

/// Visual state of a [GlowingBeacon] map marker.
enum BeaconState { locked, active }

/// A glowing map beacon: concentric rings on the ground with a beam of
/// light shining upward out of them, like the departamento markers on the
/// road trip map. Supports two color states ([BeaconState.locked] in gold,
/// [BeaconState.active] in green) and animates a soft pulsing shine.
class GlowingBeacon extends StatefulWidget {
  final BeaconState state;
  final double size;

  const GlowingBeacon({
    super.key,
    required this.state,
    this.size = 140,
  });

  @override
  State<GlowingBeacon> createState() => _GlowingBeaconState();
}

class _GlowingBeaconState extends State<GlowingBeacon>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  Color get _color => widget.state == BeaconState.active
      ? const Color(0xFF3DFF7A)
      : const Color(0xFFFFC93C);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 1.9,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _ringController]),
        builder: (context, _) {
          final shine = 0.65 + 0.35 * _pulseController.value;
          return CustomPaint(
            painter: _BeaconPainter(
              color: _color,
              shine: shine,
              ringProgress: _ringController.value,
            ),
          );
        },
      ),
    );
  }
}

class _BeaconPainter extends CustomPainter {
  final Color color;
  final double shine;
  final double ringProgress;

  _BeaconPainter({
    required this.color,
    required this.shine,
    required this.ringProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final base = Offset(size.width / 2, size.height * 0.86);
    final maxRingRadius = size.width * 0.6;

    _paintGroundGlow(canvas, base, maxRingRadius);
    _paintRings(canvas, base, maxRingRadius);
    _paintBeam(canvas, size, base);
    _paintCore(canvas, base);
  }

  void _paintGroundGlow(Canvas canvas, Offset center, double maxRadius) {
    final rect = Rect.fromCenter(
      center: center,
      width: maxRadius * 1.7,
      height: maxRadius * 1.05,
    );
    final paint = Paint()
      ..shader = RadialGradient(colors: [
        color.withOpacity(0.5 * shine),
        color.withOpacity(0.0),
      ]).createShader(rect);
    canvas.drawOval(rect, paint);
  }

  void _paintRings(Canvas canvas, Offset center, double maxRadius) {
    const ringCount = 3;
    for (var i = 0; i < ringCount; i++) {
      final t = (ringProgress + i / ringCount) % 1.0;
      final radius = maxRadius * (0.22 + 0.78 * t);
      final opacity = (1 - t) * 0.85 * shine;
      if (opacity <= 0.01) continue;
      final ringColor = Color.lerp(Colors.white, color, (0.3 + t).clamp(0.0, 1.0))!;
      final paint = Paint()
        ..color = ringColor.withOpacity(opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: radius * 2,
          height: radius * 0.6,
        ),
        paint,
      );
    }
  }

  void _paintBeam(Canvas canvas, Size size, Offset base) {
    final beamTop = Offset(base.dx, base.dy - size.height * 0.9);
    final flameTip = Offset(base.dx, base.dy - size.height * 0.5);

    // Wide, soft bloom pass behind the beam.
    final bloomPath = Path()
      ..moveTo(base.dx - size.width * 0.3, base.dy)
      ..quadraticBezierTo(
        base.dx - size.width * 0.05,
        base.dy - size.height * 0.28,
        flameTip.dx,
        flameTip.dy,
      )
      ..quadraticBezierTo(
        base.dx + size.width * 0.05,
        base.dy - size.height * 0.28,
        base.dx + size.width * 0.3,
        base.dy,
      )
      ..close();
    final bloomPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [color.withOpacity(0.55 * shine), color.withOpacity(0.0)],
      ).createShader(Rect.fromPoints(base, flameTip))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    canvas.drawPath(bloomPath, bloomPaint);

    // Crisper inner flame/cone shape.
    final flamePath = Path()
      ..moveTo(base.dx - size.width * 0.14, base.dy)
      ..quadraticBezierTo(
        base.dx - size.width * 0.02,
        base.dy - size.height * 0.3,
        flameTip.dx,
        flameTip.dy,
      )
      ..quadraticBezierTo(
        base.dx + size.width * 0.02,
        base.dy - size.height * 0.3,
        base.dx + size.width * 0.14,
        base.dy,
      )
      ..close();
    final flamePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Colors.white.withOpacity(0.9 * shine),
          color.withOpacity(0.85 * shine),
          color.withOpacity(0.0),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromPoints(base, flameTip));
    canvas.drawPath(flamePath, flamePaint);

    // Thin beam continuing further up into the sky.
    final thinBeamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [color.withOpacity(0.8 * shine), color.withOpacity(0.0)],
      ).createShader(Rect.fromPoints(flameTip, beamTop))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    final thinBeamPath = Path()
      ..moveTo(base.dx - 3, flameTip.dy)
      ..lineTo(base.dx - 0.6, beamTop.dy)
      ..lineTo(base.dx + 0.6, beamTop.dy)
      ..lineTo(base.dx + 3, flameTip.dy)
      ..close();
    canvas.drawPath(thinBeamPath, thinBeamPaint);
  }

  void _paintCore(Canvas canvas, Offset center) {
    final rect = Rect.fromCircle(center: center, radius: 20);
    final paint = Paint()
      ..shader = RadialGradient(colors: [
        Colors.white.withOpacity(0.95 * shine),
        color.withOpacity(0.9 * shine),
        color.withOpacity(0.0),
      ], stops: const [
        0.0,
        0.45,
        1.0
      ]).createShader(rect);
    canvas.drawCircle(center, 20, paint);
  }

  @override
  bool shouldRepaint(covariant _BeaconPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.shine != shine ||
        oldDelegate.ringProgress != ringProgress;
  }
}
