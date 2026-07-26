import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Visual state of a [GlowingBeacon] map marker.
enum BeaconState { locked, active }

/// A glowing map beacon: concentric rings on the ground with a soft shaft
/// of light shining upward out of them, like the departamento markers on
/// the road trip map. Supports two color states ([BeaconState.locked] in
/// gold, [BeaconState.active] in green) and animates a lively shine: a
/// breathing pulse, a fast flicker, energy traveling around the rings,
/// rising sparks and a rotating star flare at the core.
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
      height: widget.size * 2.0,
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
          final flicker = 0.85 + 0.15 * math.sin(flickerPhase * 3.2);
          final breathe = 0.65 + 0.35 * _pulseController.value;
          final shine = (breathe * flicker).clamp(0.0, 1.3);

          return CustomPaint(
            painter: _BeaconPainter(
              color: _color,
              shine: shine,
              ringProgress: _ringController.value,
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
  final double particleProgress;
  final double flareProgress;

  static const int _particleCount = 7;
  static const double _ringSquash = 0.62;

  _BeaconPainter({
    required this.color,
    required this.shine,
    required this.ringProgress,
    required this.particleProgress,
    required this.flareProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final base = Offset(size.width / 2, size.height * 0.86);
    final maxRingRadius = size.width * 0.42;

    _paintGroundGlow(canvas, base, maxRingRadius);
    _paintRings(canvas, base, maxRingRadius);
    _paintBeam(canvas, size, base, maxRingRadius);
    _paintParticles(canvas, size, base);
    _paintCore(canvas, base);
    _paintFlare(canvas, base);
  }

  void _paintGroundGlow(Canvas canvas, Offset center, double maxRadius) {
    final rect = Rect.fromCenter(
      center: center,
      width: maxRadius * 2.2,
      height: maxRadius * 2.2 * _ringSquash,
    );
    final paint = Paint()
      ..shader = RadialGradient(colors: [
        color.withOpacity(0.45 * shine),
        color.withOpacity(0.0),
      ]).createShader(rect);
    canvas.drawOval(rect, paint);
  }

  void _paintRings(Canvas canvas, Offset center, double maxRadius) {
    const ringCount = 2;
    for (var i = 0; i < ringCount; i++) {
      final t = (ringProgress + i / ringCount) % 1.0;
      final radius = maxRadius * (0.35 + 0.65 * t);
      final opacity = (1 - t) * 0.95 * shine;
      if (opacity <= 0.01) continue;

      final ringColor =
          Color.lerp(Colors.white, color, (0.35 + t).clamp(0.0, 1.0))!;
      final ringRect = Rect.fromCenter(
        center: center,
        width: radius * 2,
        height: radius * 2 * _ringSquash,
      );

      final paint = Paint()
        ..color = ringColor.withOpacity(opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2);
      canvas.drawOval(ringRect, paint);

      // A brighter arc of "energy" traveling around each ring.
      final travelAngle =
          (ringProgress * 2 * math.pi * (i.isEven ? 1 : -1)) + i;
      final energyPaint = Paint()
        ..color = Colors.white.withOpacity((opacity * 0.9).clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
      canvas.drawArc(ringRect, travelAngle, 0.6, false, energyPaint);
    }
  }

  /// A single soft, continuous shaft of light: a slender "hourglass" that
  /// touches the ring at a point, bells out a little just above it, then
  /// tapers gently into a thin thread reaching far up. Every layer is
  /// blurred so the silhouette stays a soft glow, never a crisp vector edge.
  void _paintBeam(
      Canvas canvas, Size size, Offset base, double maxRingRadius) {
    final beamHeight = size.height * 0.92;
    final bellyY = base.dy - maxRingRadius * 0.95;
    final bellyHalfWidth = maxRingRadius * 0.62;
    final topY = base.dy - beamHeight;

    Path shaftPath() => Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(
          base.dx - bellyHalfWidth, base.dy - maxRingRadius * 0.3, base.dx - bellyHalfWidth, bellyY)
      ..quadraticBezierTo(
          base.dx - bellyHalfWidth * 0.1, bellyY - (topY - bellyY) * 0.5, base.dx - 0.5, topY)
      ..lineTo(base.dx + 0.5, topY)
      ..quadraticBezierTo(
          base.dx + bellyHalfWidth * 0.1, bellyY - (topY - bellyY) * 0.5, base.dx + bellyHalfWidth, bellyY)
      ..quadraticBezierTo(
          base.dx + bellyHalfWidth, base.dy - maxRingRadius * 0.3, base.dx, base.dy)
      ..close();

    final gradientRect = Rect.fromPoints(base, Offset(base.dx, topY));

    // Wide, very soft halo behind the shaft.
    final haloPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [color.withOpacity(0.75 * shine), color.withOpacity(0.0)],
        stops: const [0.0, 0.7],
      ).createShader(gradientRect)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, maxRingRadius * 0.45);
    canvas.drawPath(shaftPath(), haloPaint);

    // Mid glow, matches the beam's silhouette but softened at the edges.
    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Colors.white.withOpacity(1.0 * shine),
          color.withOpacity(0.95 * shine),
          color.withOpacity(0.0),
        ],
        stops: const [0.0, 0.35, 1.0],
      ).createShader(gradientRect)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, maxRingRadius * 0.1);
    canvas.drawPath(shaftPath(), glowPaint);

    // Thin, brighter core thread down the middle for extra intensity.
    final corePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Colors.white.withOpacity(1.0 * shine), color.withOpacity(0.0)],
        stops: const [0.0, 0.8],
      ).createShader(gradientRect)
      ..strokeWidth = maxRingRadius * 0.16
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, maxRingRadius * 0.06);
    canvas.drawLine(base, Offset(base.dx, topY), corePaint);
  }

  void _paintParticles(Canvas canvas, Size size, Offset base) {
    final beamHeight = size.height * 0.85;
    for (var i = 0; i < _particleCount; i++) {
      final seed = i * 2.399963;
      final t = (particleProgress + i / _particleCount) % 1.0;
      final y = base.dy - beamHeight * t;
      final drift =
          math.sin(t * 2 * math.pi * 2 + seed) * size.width * 0.05 * (1 - t * 0.5);
      final x = base.dx + drift;
      final fade = math.sin(t * math.pi);
      final opacity = (fade * 0.85 * shine).clamp(0.0, 1.0);
      if (opacity <= 0.02) continue;
      final radius = 1.1 + 1.3 * (1 - t);

      final paint = Paint()
        ..color = Color.lerp(Colors.white, color, 0.55)!.withOpacity(opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _paintCore(Canvas canvas, Offset center) {
    const radius = 26.0;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = RadialGradient(colors: [
        Colors.white.withOpacity((1.0 * shine).clamp(0.0, 1.0)),
        color.withOpacity((0.95 * shine).clamp(0.0, 1.0)),
        color.withOpacity(0.0),
      ], stops: const [
        0.0,
        0.4,
        1.0
      ]).createShader(rect);
    canvas.drawCircle(center, radius, paint);
  }

  void _paintFlare(Canvas canvas, Offset center) {
    canvas.save();
    canvas.translate(center.dx, center.dy);

    final longLen = 26 + 8 * shine;
    final shortLen = longLen * 0.45;
    final opacity = (0.5 * shine).clamp(0.0, 1.0);

    _drawFlareCross(
      canvas,
      rotation: flareProgress * 2 * math.pi,
      length: longLen,
      thickness: 2.0,
      opacity: opacity,
    );
    _drawFlareCross(
      canvas,
      rotation: -flareProgress * 2 * math.pi * 0.6 + math.pi / 4,
      length: shortLen,
      thickness: 1.3,
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
        oldDelegate.particleProgress != particleProgress ||
        oldDelegate.flareProgress != flareProgress;
  }
}
