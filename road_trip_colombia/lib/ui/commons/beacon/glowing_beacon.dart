import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Visual state of a [GlowingBeacon] map marker.
enum BeaconState { locked, active }

/// A glowing map beacon: concentric rings on the ground with a beam of
/// light shining upward out of them, like the departamento markers on the
/// road trip map. Supports two color states ([BeaconState.locked] in gold,
/// [BeaconState.active] in green) and animates a lively shine: a breathing
/// pulse, a fast flicker, a swaying flame, energy traveling around the
/// rings, rising sparks and a rotating star flare at the core.
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
  late final AnimationController _flickerController;
  late final AnimationController _particleController;
  late final AnimationController _flareController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _flickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
    _flareController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ringController.dispose();
    _flickerController.dispose();
    _particleController.dispose();
    _flareController.dispose();
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
        animation: Listenable.merge([
          _pulseController,
          _ringController,
          _flickerController,
          _particleController,
          _flareController,
        ]),
        builder: (context, _) {
          final flickerPhase = _flickerController.value * 2 * math.pi;
          final flicker = 0.82 + 0.18 * math.sin(flickerPhase * 3.2);
          final breathe = 0.6 + 0.4 * _pulseController.value;
          final shine = (breathe * flicker).clamp(0.0, 1.3);
          final sway = math.sin(flickerPhase * 1.3) * 0.045;

          return CustomPaint(
            painter: _BeaconPainter(
              color: _color,
              shine: shine,
              ringProgress: _ringController.value,
              sway: sway,
              particleProgress: _particleController.value,
              flareProgress: _flareController.value,
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
  final double sway;
  final double particleProgress;
  final double flareProgress;

  static const int _particleCount = 7;

  _BeaconPainter({
    required this.color,
    required this.shine,
    required this.ringProgress,
    required this.sway,
    required this.particleProgress,
    required this.flareProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final base = Offset(size.width / 2, size.height * 0.86);
    final maxRingRadius = size.width * 0.6;
    final tipOffset = sway * size.width;

    _paintGroundGlow(canvas, base, maxRingRadius);
    _paintRings(canvas, base, maxRingRadius);
    _paintBeam(canvas, size, base, tipOffset);
    _paintParticles(canvas, size, base, tipOffset);
    _paintCore(canvas, base);
    _paintFlare(canvas, base);
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

      final ringColor =
          Color.lerp(Colors.white, color, (0.3 + t).clamp(0.0, 1.0))!;
      final ringRect = Rect.fromCenter(
        center: center,
        width: radius * 2,
        height: radius * 0.6,
      );

      final paint = Paint()
        ..color = ringColor.withOpacity(opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawOval(ringRect, paint);

      // A brighter arc of "energy" traveling around each ring.
      final travelAngle =
          (ringProgress * 2 * math.pi * (i.isEven ? 1 : -1)) + i;
      final energyPaint = Paint()
        ..color = Colors.white.withOpacity((opacity * 0.9).clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawArc(
        ringRect,
        travelAngle,
        0.7,
        false,
        energyPaint,
      );
    }
  }

  void _paintBeam(Canvas canvas, Size size, Offset base, double tipOffset) {
    final beamTop = Offset(base.dx + tipOffset * 1.6, base.dy - size.height * 0.9);
    final flameTip = Offset(base.dx + tipOffset, base.dy - size.height * 0.5);

    // Wide, soft bloom pass behind the beam.
    final bloomPath = Path()
      ..moveTo(base.dx - size.width * 0.3, base.dy)
      ..quadraticBezierTo(
        base.dx - size.width * 0.05 + tipOffset * 0.5,
        base.dy - size.height * 0.28,
        flameTip.dx,
        flameTip.dy,
      )
      ..quadraticBezierTo(
        base.dx + size.width * 0.05 + tipOffset * 0.5,
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

    // Crisper inner flame/cone shape, swaying side to side.
    final flamePath = Path()
      ..moveTo(base.dx - size.width * 0.14, base.dy)
      ..quadraticBezierTo(
        base.dx - size.width * 0.02 + tipOffset * 0.5,
        base.dy - size.height * 0.3,
        flameTip.dx,
        flameTip.dy,
      )
      ..quadraticBezierTo(
        base.dx + size.width * 0.02 + tipOffset * 0.5,
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
      ..lineTo(beamTop.dx - 0.6, beamTop.dy)
      ..lineTo(beamTop.dx + 0.6, beamTop.dy)
      ..lineTo(base.dx + 3, flameTip.dy)
      ..close();
    canvas.drawPath(thinBeamPath, thinBeamPaint);
  }

  void _paintParticles(
      Canvas canvas, Size size, Offset base, double tipOffset) {
    final beamHeight = size.height * 0.95;
    for (var i = 0; i < _particleCount; i++) {
      final seed = i * 2.399963;
      final t = (particleProgress + i / _particleCount) % 1.0;
      final y = base.dy - beamHeight * t;
      final drift = math.sin(t * 2 * math.pi * 2 + seed) *
          size.width *
          0.09 *
          (1 - t * 0.4);
      final x = base.dx + tipOffset * t + drift;
      final fade = math.sin(t * math.pi);
      final opacity = (fade * 0.85 * shine).clamp(0.0, 1.0);
      if (opacity <= 0.02) continue;
      final radius = 1.2 + 1.6 * (1 - t);

      final paint = Paint()
        ..color = Color.lerp(Colors.white, color, 0.55)!.withOpacity(opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _paintCore(Canvas canvas, Offset center) {
    final rect = Rect.fromCircle(center: center, radius: 20);
    final paint = Paint()
      ..shader = RadialGradient(colors: [
        Colors.white.withOpacity((0.95 * shine).clamp(0.0, 1.0)),
        color.withOpacity((0.9 * shine).clamp(0.0, 1.0)),
        color.withOpacity(0.0),
      ], stops: const [
        0.0,
        0.45,
        1.0
      ]).createShader(rect);
    canvas.drawCircle(center, 20, paint);
  }

  void _paintFlare(Canvas canvas, Offset center) {
    canvas.save();
    canvas.translate(center.dx, center.dy);

    final longLen = 34 + 10 * shine;
    final shortLen = longLen * 0.45;
    final opacity = (0.55 * shine).clamp(0.0, 1.0);

    _drawFlareCross(
      canvas,
      rotation: flareProgress * 2 * math.pi,
      length: longLen,
      thickness: 2.2,
      opacity: opacity,
    );
    _drawFlareCross(
      canvas,
      rotation: -flareProgress * 2 * math.pi * 0.6 + math.pi / 4,
      length: shortLen,
      thickness: 1.4,
      opacity: opacity * 0.7,
    );

    canvas.restore();
  }

  void _drawFlareCross(
    Canvas canvas, {
    required double rotation,
    required double length,
    required double thickness,
    required double opacity,
  }) {
    canvas.save();
    canvas.rotate(rotation);
    final paint = Paint()
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    for (var i = 0; i < 4; i++) {
      canvas.rotate(math.pi / 2);
      final shader = LinearGradient(
        colors: [Colors.white.withOpacity(opacity), Colors.white.withOpacity(0.0)],
      ).createShader(Rect.fromPoints(Offset.zero, Offset(0, -length)));
      paint.shader = shader;
      canvas.drawLine(Offset.zero, Offset(0, -length), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BeaconPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.shine != shine ||
        oldDelegate.ringProgress != ringProgress ||
        oldDelegate.sway != sway ||
        oldDelegate.particleProgress != particleProgress ||
        oldDelegate.flareProgress != flareProgress;
  }
}
