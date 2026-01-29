import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ============================================================================
/// ANALYTICS DETAIL SCREENS (V2) - BEST OF THE WORLD 😈🔥
/// 1) AreasDetailScreenV2
///    - Radar arriba + Week carousel (1-4) con animación
///    - Stats por semana + hábitos por área + “misiones”
—
/// 2) DailyProgressDetailScreenV2
///    - Line chart interactivo (tap/drag) para seleccionar día
///    - Panel de detalle del día + heatmap + breakdown list
///
/// 3) StreaksDetailScreenV2
///    - Risk prediction (probabilidad romper racha) con gauge
///    - Calendario consistencia + rachas por hábito + reglas
///
/// Sin paquetes externos. Todo nativo.
/// ============================================================================

/// ===================
/// TOKENS / THEME CORE
/// ===================
class _T {
  static const bg = Color(0xFF070A14);
  static const card = Color(0xFF0C1023);
  static const card2 = Color(0xFF0A0E1D);

  static const glowA = Color(0xFF9B7BFF);
  static const glowB = Color(0xFF49D3FF);
  static const glowC = Color(0xFFFF4FD8);

  static const ok = Color(0xFF48FFB1);
  static const warn = Color(0xFFFFD166);
  static const bad = Color(0xFFFF5C77);

  static const LineGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glowB, glowA, glowC],
  );

  static const cosmic = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0C1023), Color(0xFF121B3A), Color(0xFF0A0E1D)],
  );
}

TextStyle _h() => TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900, fontSize: 14);
TextStyle _b() => TextStyle(color: Colors.white.withOpacity(.88), fontWeight: FontWeight.w800, fontSize: 13);
TextStyle _s() => TextStyle(color: Colors.white.withOpacity(.62), fontSize: 12, height: 1.25);

/// ===================
/// SHARED CONTAINERS
/// ===================
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _T.cosmic,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: child,
    );
  }
}

class _GlowCard extends StatelessWidget {
  final Widget child;
  const _GlowCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _T.cosmic,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(.10)),
        boxShadow: [
          BoxShadow(color: _T.glowA.withOpacity(.14), blurRadius: 28, spreadRadius: 2),
          BoxShadow(color: _T.glowB.withOpacity(.10), blurRadius: 36, spreadRadius: 1),
        ],
      ),
      child: child,
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatChip({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color.withOpacity(.95)),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(color: Colors.white.withOpacity(.65), fontWeight: FontWeight.w700)),
          Text(value, style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _Pill({required this.text, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _T.glowA.withOpacity(.22) : _T.card2,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? _T.glowA.withOpacity(.55) : Colors.white.withOpacity(.08)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white.withOpacity(.92) : Colors.white.withOpacity(.68),
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

/// ===================
/// SHARED PAINTERS
/// ===================
class _RingPainter extends CustomPainter {
  final double progress; // 0..1
  final Color color;
  final bool glow;
  _RingPainter({required this.progress, required this.color, this.glow = false});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = math.min(size.width, size.height) / 2;

    final bg = Paint()
      ..color = Colors.white.withOpacity(.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    if (glow) fg.maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(c, r - 6, bg);
    final sweep = 2 * math.pi * progress.clamp(0.0, 1.0);
    final rect = Rect.fromCircle(center: c, radius: r - 6);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, fg);

    final pct = (progress * 100).round();
    final tp = TextPainter(
      text: TextSpan(
        text: '$pct',
        style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900, fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color || oldDelegate.glow != glow;
}

class _RadarPainter extends CustomPainter {
  final List<double> values; // 5
  final int gridSteps;
  final Color glowColor;
  final Gradient fillGradient;

  _RadarPainter({
    required this.values,
    required this.gridSteps,
    required this.glowColor,
    required this.fillGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.42;

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int s = 1; s <= gridSteps; s++) {
      final rr = radius * (s / gridSteps);
      final path = Path();
      for (int i = 0; i < n; i++) {
        final ang = (-math.pi / 2) + (2 * math.pi * i / n);
        final p = center + Offset(math.cos(ang) * rr, math.sin(ang) * rr);
        if (i == 0) path.moveTo(p.dx, p.dy);
        else path.lineTo(p.dx, p.dy);
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    for (int i = 0; i < n; i++) {
      final ang = (-math.pi / 2) + (2 * math.pi * i / n);
      final p = center + Offset(math.cos(ang) * radius, math.sin(ang) * radius);
      canvas.drawLine(center, p, gridPaint);
    }

    final poly = Path();
    for (int i = 0; i < n; i++) {
      final v = values[i].clamp(0.0, 1.0);
      final ang = (-math.pi / 2) + (2 * math.pi * i / n);
      final p = center + Offset(math.cos(ang) * radius * v, math.sin(ang) * radius * v);
      if (i == 0) poly.moveTo(p.dx, p.dy);
      else poly.lineTo(p.dx, p.dy);
    }
    poly.close();

    final fillPaint = Paint()
      ..shader = fillGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(.18);

    final strokePaint = Paint()
      ..color = glowColor.withOpacity(.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(poly, fillPaint);
    canvas.drawPath(poly, strokePaint);

    final dotPaint = Paint()..color = Colors.white.withOpacity(.9);
    for (int i = 0; i < n; i++) {
      final v = values[i].clamp(0.0, 1.0);
      final ang = (-math.pi / 2) + (2 * math.pi * i / n);
      final p = center + Offset(math.cos(ang) * radius * v, math.sin(ang) * radius * v);
      canvas.drawCircle(p, 2.6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.gridSteps != gridSteps || oldDelegate.glowColor != glowColor;
}

class _HeatmapPainter extends CustomPainter {
  final List<_HeatDay> days;
  final double t;

  _HeatmapPainter({required this.days, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final cell = 12.0;
    final gap = 4.0;
    final cols = (size.width / (cell + gap)).floor();
    final rows = 7;
    final maxCells = cols * rows;

    final shown = days.take(maxCells).toList();

    for (int i = 0; i < shown.length; i++) {
      final r = i % rows;
      final c = i ~/ rows;

      final x = c * (cell + gap);
      final y = r * (cell + gap);

      final v = (shown[i].intensity * t).clamp(0.0, 1.0);
      final color = Color.lerp(
        Colors.white.withOpacity(.08),
        _T.ok.withOpacity(.90),
        v,
      )!;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, cell, cell),
        const Radius.circular(4),
      );

      canvas.drawRRect(rect, Paint()..color = color);
      canvas.drawRRect(
        rect,
        Paint()
          ..color = Colors.white.withOpacity(.06)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) => oldDelegate.days != days || oldDelegate.t != t;
}

/// ===================
/// INTERACTIVE LINE CHART (tap/drag)
/// ===================
class InteractiveLineChart extends StatefulWidget {
  final List<double> values; // 0..1
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Color glowColor;
  const InteractiveLineChart({
    super.key,
    required this.values,
    required this.selectedIndex,
    required this.onSelect,
    this.glowColor = _T.glowB,
  });

  @override
  State<InteractiveLineChart> createState() => _InteractiveLineChartState();
}

class _InteractiveLineChartState extends State<InteractiveLineChart> {
  void _handle(Offset local, Size size) {
    if (widget.values.length < 2) return;
    const pad = 10.0;
    final w = size.width - pad * 2;
    final dx = (local.dx - pad).clamp(0.0, w);
    final t = (dx / math.max(1.0, w)).clamp(0.0, 1.0);
    final idx = (t * (widget.values.length - 1)).round().clamp(0, widget.values.length - 1);
    widget.onSelect(idx);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final size = Size(c.maxWidth, c.maxHeight);
        return GestureDetector(
          onTapDown: (d) => _handle(d.localPosition, size),
          onPanStart: (d) => _handle(d.localPosition, size),
          onPanUpdate: (d) => _handle(d.localPosition, size),
          child: CustomPaint(
            painter: _InteractiveLinePainter(
              values: widget.values,
              selectedIndex: widget.selectedIndex,
              glowColor: widget.glowColor,
            ),
          ),
        );
      },
    );
  }
}

class _InteractiveLinePainter extends CustomPainter {
  final List<double> values;
  final int selectedIndex;
  final Color glowColor;

  _InteractiveLinePainter({
    required this.values,
    required this.selectedIndex,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final pad = 10.0;
    final w = size.width - pad * 2;
    final h = size.height - pad * 2;

    // grid
    final grid = Paint()
      ..color = Colors.white.withOpacity(.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 1; i <= 3; i++) {
      final y = pad + (h * i / 4);
      canvas.drawLine(Offset(pad, y), Offset(pad + w, y), grid);
    }

    Offset pt(int i) {
      final x = pad + w * (i / (values.length - 1));
      final y = pad + h * (1 - values[i].clamp(0.0, 1.0));
      return Offset(x, y);
    }

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final p = pt(i);
      if (i == 0) path.moveTo(p.dx, p.dy);
      else path.lineTo(p.dx, p.dy);
    }

    // glow + line
    canvas.drawPath(
      path,
      Paint()
        ..color = glowColor.withOpacity(.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = glowColor.withOpacity(.95)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // points
    final dot = Paint()..color = Colors.white.withOpacity(.85);
    for (int i = 0; i < values.length; i++) {
      canvas.drawCircle(pt(i), 2.2, dot);
    }

    // selected highlight
    final sp = pt(selectedIndex.clamp(0, values.length - 1));
    // vertical marker
    canvas.drawLine(
      Offset(sp.dx, pad),
      Offset(sp.dx, pad + h),
      Paint()..color = Colors.white.withOpacity(.10),
    );
    // selected point glow
    canvas.drawCircle(
      sp,
      10,
      Paint()
        ..color = glowColor.withOpacity(.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    canvas.drawCircle(sp, 4.5, Paint()..color = Colors.white.withOpacity(.95));
    canvas.drawCircle(sp, 7, Paint()..color = glowColor.withOpacity(.55)..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant _InteractiveLinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.selectedIndex != selectedIndex || oldDelegate.glowColor != glowColor;
}

/// ===================
/// RISK GAUGE (streaks)
/// ===================
class RiskGauge extends StatelessWidget {
  final double risk; // 0..1
  const RiskGauge({super.key, required this.risk});

  @override
  Widget build(BuildContext context) {
    final r = risk.clamp(0.0, 1.0);
    final pct = (r * 100).round();
    final color = pct < 35 ? _T.ok : (pct < 65 ? _T.warn : _T.bad);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            height: 76,
            child: CustomPaint(painter: _GaugePainter(risk: r, color: color)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Riesgo de romper racha', style: _h()),
                const SizedBox(height: 6),
                Text('$pct% ${pct < 35 ? 'BAJO' : (pct < 65 ? 'MEDIO' : 'ALTO')}', style: TextStyle(color: color, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(
                  pct < 35
                      ? 'Vas sólido. Protege el ritmo.'
                      : (pct < 65
                          ? 'Estás resbalando. Aplica “versión mínima” hoy.'
                          : 'Peligro real. Haz el hábito aunque sea 10 minutos.'),
                  style: _s(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double risk;
  final Color color;
  _GaugePainter({required this.risk, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = math.min(size.width, size.height) / 2;

    // background arc (semi)
    final bg = Paint()
      ..color = Colors.white.withOpacity(.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final rect = Rect.fromCircle(center: c, radius: r - 6);

    // draw base 180°
    canvas.drawArc(rect, math.pi, math.pi, false, bg);

    // risk arc
    final sweep = math.pi * risk.clamp(0.0, 1.0);
    canvas.drawArc(rect, math.pi, sweep, false, fg);

    // needle
    final ang = math.pi + sweep;
    final needle = Paint()
      ..color = Colors.white.withOpacity(.85)
      ..strokeWidth = 2.0;
    final p2 = c + Offset(math.cos(ang) * (r - 12), math.sin(ang) * (r - 12));
    canvas.drawLine(c, p2, needle);
    canvas.drawCircle(c, 3, Paint()..color = Colors.white.withOpacity(.9));
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => oldDelegate.risk != risk || oldDelegate.color != color;
}

/// ============================================================================
/// 1) AREAS DETAIL SCREEN V2
/// ============================================================================
class AreasDetailScreenV2 extends StatefulWidget {
  const AreasDetailScreenV2({super.key});
  @override
  State<AreasDetailScreenV2> createState() => _AreasDetailScreenV2State();
}

class _AreasDetailScreenV2State extends State<AreasDetailScreenV2> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _t;

  final PageController _page = PageController(viewportFraction: 0.92);
  int weekIndex = 0; // 0..3
  String areaSelected = 'Salud';

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    _t = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = AreasMockV2.build();

    final areas = data.areas;
    final selectedArea = areas.firstWhere((e) => e.name == areaSelected);

    final week = data.weeks[weekIndex];
    final radarValues = week.radar.map((e) => (e * _t.value).clamp(0.0, 1.0)).toList();

    return Scaffold(
      backgroundColor: _T.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Detalle de Áreas'),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _t,
        builder: (_, __) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GlowCard(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('Radar + Semanas', style: _h())),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.22),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: Colors.white.withOpacity(.10)),
                              ),
                              child: Text('Week ${weekIndex + 1}/4', style: TextStyle(color: Colors.white.withOpacity(.82), fontWeight: FontWeight.w900, fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 190,
                              height: 190,
                              child: CustomPaint(
                                painter: _RadarPainter(
                                  values: radarValues,
                                  gridSteps: 4,
                                  glowColor: _T.glowA,
                                  fillGradient: _T.LineGradient,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                children: [
                                  _AreaSelectorGrid(
                                    areas: areas,
                                    selected: areaSelected,
                                    onSelect: (v) => setState(() => areaSelected = v),
                                  ),
                                  const SizedBox(height: 10),
                                  _AreaMetaCard(area: selectedArea, week: week, t: _t.value),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Week carousel
                        SizedBox(
                          height: 120,
                          child: PageView.builder(
                            controller: _page,
                            itemCount: data.weeks.length,
                            onPageChanged: (i) {
                              setState(() => weekIndex = i);
                              _c
                                ..reset()
                                ..forward();
                            },
                            itemBuilder: (_, i) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _WeekCard(week: data.weeks[i], active: i == weekIndex, t: _t.value),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _PageDots(count: data.weeks.length, index: weekIndex),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                _Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hábitos que alimentan ${selectedArea.name}', style: _h()),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 160,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: _InteractiveLinePainter(
                              values: selectedArea.weekTrends[weekIndex].map((e) => (e * _t.value).clamp(0.0, 1.0)).toList(),
                              selectedIndex: math.min(weekIndex, selectedArea.weekTrends[weekIndex].length - 1),
                              glowColor: _accentForArea(selectedArea.name),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _StatChip(icon: Icons.auto_awesome_rounded, label: 'XP', value: '+${(week.xp * _t.value).round()}', color: _T.glowB),
                            _StatChip(icon: Icons.favorite_rounded, label: 'HP', value: '+${(week.hp * _t.value).round()}', color: _T.ok),
                            _StatChip(icon: Icons.savings_rounded, label: 'Varos', value: '+${(week.varos * _t.value).round()}', color: _T.warn),
                            _StatChip(icon: Icons.local_fire_department_rounded, label: 'Racha', value: '${(selectedArea.streak * _t.value).round()}d', color: _T.warn),
                          ],
                        ),
                        const SizedBox(height: 14),

                        ...selectedArea.habits.map((h) => _HabitProgressRow(
                              name: h.name,
                              completion: (h.completionByWeek[weekIndex] * _t.value).clamp(0.0, 1.0),
                              streak: h.streak,
                              accent: _accentForArea(selectedArea.name),
                              subtitle: 'impacto: +${h.xpImpact} XP • +${h.hpImpact} HP • +${h.varosImpact} Varos',
                            )),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                _GlowCard(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Misiones de mejora (modo pro)', style: _h()),
                        const SizedBox(height: 10),
                        _Mission(
                          title: 'Sube ${selectedArea.name} +15% en 14 días',
                          body: 'Elige 1 hábito ancla y aplica: “No pierdas 2 días seguidos”.',
                          icon: Icons.rocket_launch_rounded,
                        ),
                        const SizedBox(height: 10),
                        _Mission(
                          title: 'Versión mínima diaria',
                          body: 'Si no puedes completo, haces mínimo (10 min). Mantén la identidad.',
                          icon: Icons.bolt_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _accentForArea(String area) => _accentForArea(area);

  static Color _accentForArea(String area) {
    switch (area) {
      case 'Salud':
        return _T.ok;
      case 'Mente':
        return _T.glowB;
      case 'Espiritualidad':
        return _T.glowA;
      case 'Dinero':
        return _T.warn;
      case 'Proyectos':
        return _T.glowC;
      default:
        return _T.glowB;
    }
  }
}

class _PageDots extends StatelessWidget {
  final int count;
  final int index;
  const _PageDots({required this.count, required this.index});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 6),
          width: i == index ? 18 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: i == index ? Colors.white.withOpacity(.75) : Colors.white.withOpacity(.18),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}

class _WeekCard extends StatelessWidget {
  final WeekPack week;
  final bool active;
  final double t;
  const _WeekCard({required this.week, required this.active, required this.t});

  @override
  Widget build(BuildContext context) {
    final opacity = active ? 1.0 : 0.75;
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.22),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? _T.glowA.withOpacity(.40) : Colors.white.withOpacity(.10)),
          boxShadow: active
              ? [BoxShadow(color: _T.glowA.withOpacity(.12), blurRadius: 26, spreadRadius: 1)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(week.title, style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(week.subtitle, style: _s()),
            const Spacer(),
            Row(
              children: [
                _MiniBadge(label: 'XP', value: '+${(week.xp * t).round()}', color: _T.glowB),
                const SizedBox(width: 8),
                _MiniBadge(label: 'HP', value: '+${(week.hp * t).round()}', color: _T.ok),
                const SizedBox(width: 8),
                _MiniBadge(label: 'V', value: '+${(week.varos * t).round()}', color: _T.warn),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniBadge({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.28)),
      ),
      child: Text('$label $value', style: TextStyle(color: Colors.white.withOpacity(.9), fontWeight: FontWeight.w900, fontSize: 11)),
    );
  }
}

class _AreaMetaCard extends StatelessWidget {
  final AreaPack area;
  final WeekPack week;
  final double t;
  const _AreaMetaCard({required this.area, required this.week, required this.t});

  @override
  Widget build(BuildContext context) {
    final score = (area.scoreByWeek[week.index] * t).clamp(0.0, 1.0);
    final pct = (score * 100).round();
    final accent = AreasDetailScreenV2._accentForArea(area.name);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: CustomPaint(painter: _RingPainter(progress: score, color: accent, glow: true)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Área: ${area.name}', style: TextStyle(color: Colors.white.withOpacity(.90), fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text('Score semana: $pct% • ${week.subtitle}', style: _s()),
                const SizedBox(height: 6),
                Text(
                  pct >= 80 ? 'Dominio sólido.' : (pct >= 60 ? 'Buen avance.' : 'Zona crítica: sube consistencia.'),
                  style: TextStyle(color: Colors.white.withOpacity(.72), fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AreaSelectorGrid extends StatelessWidget {
  final List<AreaPack> areas;
  final String selected;
  final ValueChanged<String> onSelect;
  const _AreaSelectorGrid({required this.areas, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: areas.map((a) {
        final sel = selected == a.name;
        final accent = AreasDetailScreenV2._accentForArea(a.name);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onSelect(a.name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: sel ? accent.withOpacity(.16) : _T.card2,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: sel ? accent.withOpacity(.45) : Colors.white.withOpacity(.06)),
              ),
              child: Row(
                children: [
                  Icon(a.icon, size: 18, color: Colors.white.withOpacity(.9)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(a.name, style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900, fontSize: 12)),
                  ),
                  Text('${(a.scoreByWeek.last * 100).round()}%', style: TextStyle(color: Colors.white.withOpacity(.70), fontWeight: FontWeight.w900, fontSize: 12)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _HabitProgressRow extends StatelessWidget {
  final String name;
  final double completion;
  final int streak;
  final Color accent;
  final String subtitle;

  const _HabitProgressRow({
    required this.name,
    required this.completion,
    required this.streak,
    required this.accent,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (completion * 100).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _T.card2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(name, style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900))),
                Text('$pct%', style: TextStyle(color: accent.withOpacity(.95), fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 6),
            Text('racha $streak días • $subtitle', style: _s()),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 9,
                color: Colors.white.withOpacity(.08),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: completion.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [accent.withOpacity(.9), accent.withOpacity(.35)])),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Mission extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;

  const _Mission({required this.title, required this.body, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: _T.LineGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: _T.glowA.withOpacity(.25), blurRadius: 20, spreadRadius: 1)],
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _b()),
                const SizedBox(height: 6),
                Text(body, style: _s()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// 2) DAILY PROGRESS DETAIL SCREEN V2
/// ============================================================================
class DailyProgressDetailScreenV2 extends StatefulWidget {
  const DailyProgressDetailScreenV2({super.key});
  @override
  State<DailyProgressDetailScreenV2> createState() => _DailyProgressDetailScreenV2State();
}

class _DailyProgressDetailScreenV2State extends State<DailyProgressDetailScreenV2> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _t;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _t = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = DailyMockV2.build();
    selectedIndex = selectedIndex.clamp(0, data.days.length - 1);
    final day = data.days[selectedIndex];

    return Scaffold(
      backgroundColor: _T.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Progreso Diario'),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _t,
        builder: (_, __) {
          final t = _t.value;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GlowCard(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Evolución (toca la gráfica)', style: _h()),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 190,
                          width: double.infinity,
                          child: InteractiveLineChart(
                            values: data.trend.map((e) => (e * t).clamp(0.0, 1.0)).toList(),
                            selectedIndex: selectedIndex,
                            onSelect: (i) => setState(() => selectedIndex = i),
                            glowColor: _T.glowB,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('Tip: arrastra para “scrub” día por día.', style: _s()),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                _Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Detalle del día seleccionado', style: _h()),
                        const SizedBox(height: 10),
                        _DayHeroCard(day: day, t: t),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _StatChip(icon: Icons.auto_awesome_rounded, label: 'XP', value: '+${(day.xp * t).round()}', color: _T.glowB),
                            _StatChip(icon: Icons.favorite_rounded, label: 'HP', value: '+${(day.hp * t).round()}', color: _T.ok),
                            _StatChip(icon: Icons.savings_rounded, label: 'Varos', value: '+${(day.varos * t).round()}', color: _T.warn),
                            _StatChip(icon: Icons.check_circle_rounded, label: 'Hábitos', value: '${day.done}/${day.total}', color: _T.glowA),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                _Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Heatmap de consistencia', style: _h()),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 92,
                          width: double.infinity,
                          child: CustomPaint(painter: _HeatmapPainter(days: data.heat, t: t)),
                        ),
                        const SizedBox(height: 10),
                        Text('Regla de oro: no perder 2 días seguidos.', style: _s()),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                _Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Últimos 14 días (scroll mental)', style: _h()),
                        const SizedBox(height: 10),
                        ...data.days.take(14).map((d) => _DayRowCompact(day: d, t: t, selected: d == day)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                _GlowCard(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Insight del sistema', style: _h()),
                        const SizedBox(height: 8),
                        Text(
                          'Si en los días “bajos” haces versión mínima (10 min), el promedio semanal se dispara. '
                          'Tu objetivo no es motivación: es protección de consistencia.',
                          style: _s(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DayHeroCard extends StatelessWidget {
  final DayPack day;
  final double t;
  const _DayHeroCard({required this.day, required this.t});

  @override
  Widget build(BuildContext context) {
    final score = (day.score * t).clamp(0.0, 1.0);
    final pct = (score * 100).round();
    final accent = pct >= 80 ? _T.ok : (pct >= 60 ? _T.warn : _T.bad);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CustomPaint(painter: _RingPainter(progress: score, color: accent, glow: true)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_wd(day.date.weekday)} ${day.date.day}/${day.date.month}', style: _b()),
                const SizedBox(height: 6),
                Text('Score del día: $pct% • ${day.done}/${day.total} hábitos', style: _s()),
                const SizedBox(height: 6),
                Text(
                  pct >= 80 ? 'Día élite. Mantén el ritual.' : (pct >= 60 ? 'Buen día. Ajusta una cosa.' : 'Día flojo. Mañana es obligatorio.'),
                  style: TextStyle(color: Colors.white.withOpacity(.78), fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _wd(int w) {
    switch (w) {
      case DateTime.monday:
        return 'Lu';
      case DateTime.tuesday:
        return 'Ma';
      case DateTime.wednesday:
        return 'Mi';
      case DateTime.thursday:
        return 'Ju';
      case DateTime.friday:
        return 'Vi';
      case DateTime.saturday:
        return 'Sa';
      case DateTime.sunday:
        return 'Do';
      default:
        return '';
    }
  }
}

class _DayRowCompact extends StatelessWidget {
  final DayPack day;
  final double t;
  final bool selected;
  const _DayRowCompact({required this.day, required this.t, required this.selected});

  @override
  Widget build(BuildContext context) {
    final v = (day.score * t).clamp(0.0, 1.0);
    final pct = (v * 100).round();
    final accent = pct >= 80 ? _T.ok : (pct >= 60 ? _T.warn : _T.bad);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? accent.withOpacity(.10) : _T.card2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? accent.withOpacity(.35) : Colors.white.withOpacity(.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text('${day.date.day}/${day.date.month}', style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900))),
                Text('$pct%', style: TextStyle(color: accent.withOpacity(.95), fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 9,
                color: Colors.white.withOpacity(.08),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: v,
                  child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [accent.withOpacity(.9), accent.withOpacity(.35)]))),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text('+${(day.xp * t).round()} XP • +${(day.hp * t).round()} HP • +${(day.varos * t).round()} Varos • ${day.done}/${day.total}', style: _s()),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// 3) STREAKS DETAIL SCREEN V2
/// ============================================================================
class StreaksDetailScreenV2 extends StatefulWidget {
  const StreaksDetailScreenV2({super.key});
  @override
  State<StreaksDetailScreenV2> createState() => _StreaksDetailScreenV2State();
}

class _StreaksDetailScreenV2State extends State<StreaksDetailScreenV2> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _t = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = StreaksMockV2.build();

    return Scaffold(
      backgroundColor: _T.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Detalle de Rachas'),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _t,
        builder: (_, __) {
          final t = _t.value;

          // Risk model (simple pero efectivo): promedio últimos 7 días + tendencia
          final risk = _RiskModel.estimateRisk(
            last7: data.last7.map((e) => e.intensity).toList(),
            currentStreak: data.current,
            bestStreak: data.best,
          );
          final riskAnimated = (risk * t).clamp(0.0, 1.0);

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GlowCard(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tu poder está en no romper la cadena.', style: _h()),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _BigTile(
                                title: 'Racha actual',
                                value: '${(data.current * t).round()} días',
                                subtitle: 'Hoy no se negocia',
                                icon: Icons.local_fire_department_rounded,
                                accent: _T.warn,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _BigTile(
                                title: 'Mejor racha',
                                value: '${(data.best * t).round()} días',
                                subtitle: 'Tu récord',
                                icon: Icons.emoji_events_rounded,
                                accent: _T.glowB,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        RiskGauge(risk: riskAnimated),
                        const SizedBox(height: 12),
                        Text(
                          'Si el riesgo es alto, aplica: versión mínima + “mañana obligatorio”.',
                          style: _s(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                _Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Consistencia (heatmap)', style: _h()),
                        const SizedBox(height: 10),
                        SizedBox(height: 92, width: double.infinity, child: CustomPaint(painter: _HeatmapPainter(days: data.heat, t: t))),
                        const SizedBox(height: 10),
                        Text('Verde = cumplido • Gris = fallido', style: _s()),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                _Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rachas por hábito (dónde eres fuerte)', style: _h()),
                        const SizedBox(height: 10),
                        ...data.habits.map((h) => _HabitStreakRowV2(h: h, t: t)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                _GlowCard(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reglas brutales (las que funcionan)', style: _h()),
                        const SizedBox(height: 10),
                        _RuleTile(title: 'No pierdas 2 días seguidos', body: 'Fallaste hoy → mañana es obligatorio. Ahí nace el cambio.', icon: Icons.shield_rounded),
                        const SizedBox(height: 10),
                        _RuleTile(title: 'Versión mínima', body: 'Si no puedes 1h, haces 10 min. Mantén la cadena viva.', icon: Icons.bolt_rounded),
                        const SizedBox(height: 10),
                        _RuleTile(title: 'Preparación anti-fallo', body: 'Deja listo lo mínimo: ropa/agua/tiempo. Reduce fricción.', icon: Icons.inventory_2_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BigTile extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accent;

  const _BigTile({required this.title, required this.value, required this.subtitle, required this.icon, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _T.card2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withOpacity(.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withOpacity(.35)),
            ),
            child: Icon(icon, color: Colors.white.withOpacity(.92)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 11)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle, style: _s()),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _HabitStreakRowV2 extends StatelessWidget {
  final HabitStreakPack h;
  final double t;
  const _HabitStreakRowV2({required this.h, required this.t});

  @override
  Widget build(BuildContext context) {
    final v = (h.consistency / 100.0 * t).clamp(0.0, 1.0);
    final pct = (v * 100).round();
    final accent = pct >= 80 ? _T.ok : (pct >= 60 ? _T.warn : _T.bad);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _T.card2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(h.name, style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900))),
                Text('${(h.streak * t).round()}d', style: TextStyle(color: accent.withOpacity(.95), fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 6),
            Text('mejor: ${h.best}d • consistencia: ${h.consistency}%', style: _s()),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 9,
                color: Colors.white.withOpacity(.08),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: v,
                  child: Container(
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [accent.withOpacity(.9), accent.withOpacity(.35)])),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleTile extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  const _RuleTile({required this.title, required this.body, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: _T.LineGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: _T.glowA.withOpacity(.25), blurRadius: 18, spreadRadius: 1)],
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _b()),
                const SizedBox(height: 6),
                Text(body, style: _s()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ===================
/// MOCK DATA (V2) MODELS
/// ===================
class _HeatDay {
  final DateTime date;
  final double intensity; // 0..1
  _HeatDay(this.date, this.intensity);
}

// Areas
class AreasDashboardV2 {
  final List<AreaPack> areas;
  final List<WeekPack> weeks;
  AreasDashboardV2({required this.areas, required this.weeks});
}

class WeekPack {
  final int index;
  final String title;
  final String subtitle;
  final int xp;
  final int hp;
  final int varos;
  final List<double> radar; // 5
  WeekPack({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.xp,
    required this.hp,
    required this.varos,
    required this.radar,
  });
}

class AreaPack {
  final String name;
  final IconData icon;
  final List<double> scoreByWeek; // 4
  final List<List<double>> weekTrends; // 4 weeks, each list points
  final int streak;
  final List<AreaHabitPack> habits;
  AreaPack({
    required this.name,
    required this.icon,
    required this.scoreByWeek,
    required this.weekTrends,
    required this.streak,
    required this.habits,
  });
}

class AreaHabitPack {
  final String name;
  final List<double> completionByWeek; // 4
  final int streak;
  final int xpImpact;
  final int hpImpact;
  final int varosImpact;
  AreaHabitPack({
    required this.name,
    required this.completionByWeek,
    required this.streak,
    required this.xpImpact,
    required this.hpImpact,
    required this.varosImpact,
  });
}

class AreasMockV2 {
  static AreasDashboardV2 build() {
    // Week packs control radar by week
    final weeks = List.generate(4, (i) {
      final base = 0.55 + i * 0.05;
      final radar = [
        (base + 0.05).clamp(0.0, 1.0), // Mente
        (base + 0.18).clamp(0.0, 1.0), // Salud
        (base - 0.12).clamp(0.0, 1.0), // Espiritualidad
        (base + 0.02).clamp(0.0, 1.0), // Dinero
        (base + 0.10).clamp(0.0, 1.0), // Proyectos
      ].map((e) => e.clamp(0.0, 1.0)).toList();

      return WeekPack(
        index: i,
        title: 'Semana ${i + 1}',
        subtitle: i == 0
            ? 'Ajuste y arranque'
            : (i == 1 ? 'Ritmo y consistencia' : (i == 2 ? 'Subida fuerte' : 'Cierre con disciplina')),
        xp: 220 + i * 60,
        hp: 28 + i * 10,
        varos: 140 + i * 50,
        radar: radar,
      );
    });

    List<double> trend(int n, double start, double end, double wobble) {
      return List<double>.generate(n, (i) {
        final t = i / math.max(1, n - 1);
        final base = start + (end - start) * t;
        final w = math.sin(i * 0.9) * wobble;
        return (base + w).clamp(0.0, 1.0);
      });
    }

    AreaPack area({
      required String name,
      required IconData icon,
      required List<double> scoreByWeek,
      required int streak,
      required List<AreaHabitPack> habits,
    }) {
      final weekTrends = List.generate(4, (w) {
        final s = scoreByWeek[w];
        return trend(12, (s - .16).clamp(0.0, 1.0), s.clamp(0.0, 1.0), .05);
      });

      return AreaPack(
        name: name,
        icon: icon,
        scoreByWeek: scoreByWeek,
        weekTrends: weekTrends,
        streak: streak,
        habits: habits,
      );
    }

    final areas = [
      area(
        name: 'Mente',
        icon: Icons.psychology_rounded,
        scoreByWeek: [0.58, 0.62, 0.66, 0.64],
        streak: 8,
        habits: [
          AreaHabitPack(name: 'Lectura', completionByWeek: [0.70, 0.78, 0.82, 0.80], streak: 7, xpImpact: 18, hpImpact: 0, varosImpact: 6),
          AreaHabitPack(name: 'Meditación', completionByWeek: [0.84, 0.90, 0.93, 0.92], streak: 12, xpImpact: 14, hpImpact: 6, varosImpact: 4),
          AreaHabitPack(name: 'No redes', completionByWeek: [0.20, 0.26, 0.30, 0.22], streak: 0, xpImpact: 10, hpImpact: 4, varosImpact: 8),
        ],
      ),
      area(
        name: 'Salud',
        icon: Icons.favorite_rounded,
        scoreByWeek: [0.74, 0.80, 0.86, 0.82],
        streak: 12,
        habits: [
          AreaHabitPack(name: 'Gimnasio', completionByWeek: [0.78, 0.86, 0.90, 0.88], streak: 9, xpImpact: 22, hpImpact: 10, varosImpact: 6),
          AreaHabitPack(name: 'Agua', completionByWeek: [0.58, 0.68, 0.74, 0.70], streak: 4, xpImpact: 8, hpImpact: 4, varosImpact: 2),
          AreaHabitPack(name: 'Dormir temprano', completionByWeek: [0.26, 0.34, 0.40, 0.34], streak: 1, xpImpact: 12, hpImpact: 10, varosImpact: 4),
        ],
      ),
      area(
        name: 'Espiritualidad',
        icon: Icons.self_improvement_rounded,
        scoreByWeek: [0.34, 0.38, 0.46, 0.41],
        streak: 3,
        habits: [
          AreaHabitPack(name: 'Respiración', completionByWeek: [0.44, 0.52, 0.58, 0.56], streak: 2, xpImpact: 10, hpImpact: 6, varosImpact: 2),
          AreaHabitPack(name: 'Gratitud', completionByWeek: [0.38, 0.44, 0.52, 0.49], streak: 2, xpImpact: 8, hpImpact: 4, varosImpact: 2),
          AreaHabitPack(name: 'Oración', completionByWeek: [0.28, 0.32, 0.40, 0.35], streak: 1, xpImpact: 12, hpImpact: 2, varosImpact: 1),
        ],
      ),
      area(
        name: 'Dinero',
        icon: Icons.savings_rounded,
        scoreByWeek: [0.52, 0.56, 0.62, 0.58],
        streak: 5,
        habits: [
          AreaHabitPack(name: 'Gastos al día', completionByWeek: [0.54, 0.62, 0.68, 0.62], streak: 4, xpImpact: 10, hpImpact: 0, varosImpact: 10),
          AreaHabitPack(name: 'Ahorro diario', completionByWeek: [0.18, 0.26, 0.34, 0.29], streak: 0, xpImpact: 18, hpImpact: 0, varosImpact: 14),
          AreaHabitPack(name: 'No malgastar', completionByWeek: [0.40, 0.46, 0.52, 0.48], streak: 2, xpImpact: 10, hpImpact: 0, varosImpact: 12),
        ],
      ),
      area(
        name: 'Proyectos',
        icon: Icons.rocket_launch_rounded,
        scoreByWeek: [0.64, 0.70, 0.78, 0.73],
        streak: 6,
        habits: [
          AreaHabitPack(name: 'My Life Game', completionByWeek: [0.62, 0.70, 0.78, 0.74], streak: 6, xpImpact: 22, hpImpact: 0, varosImpact: 8),
          AreaHabitPack(name: 'Col en Ruta', completionByWeek: [0.56, 0.62, 0.70, 0.66], streak: 4, xpImpact: 18, hpImpact: 0, varosImpact: 8),
          AreaHabitPack(name: 'Inglés', completionByWeek: [0.40, 0.48, 0.56, 0.51], streak: 2, xpImpact: 12, hpImpact: 0, varosImpact: 4),
        ],
      ),
    ];

    return AreasDashboardV2(areas: areas, weeks: weeks);
  }
}

// Daily
class DayPack {
  final DateTime date;
  final double score; // 0..1
  final int done;
  final int total;
  final int xp;
  final int hp;
  final int varos;
  DayPack({
    required this.date,
    required this.score,
    required this.done,
    required this.total,
    required this.xp,
    required this.hp,
    required this.varos,
  });
}

class DailyDataV2 {
  final List<double> trend;
  final List<DayPack> days;
  final List<_HeatDay> heat;
  DailyDataV2({required this.trend, required this.days, required this.heat});
}

class DailyMockV2 {
  static DailyDataV2 build() {
    final now = DateTime.now();

    final trend = List<double>.generate(18, (i) {
      final base = 0.42 + (i / 17) * 0.40;
      final wobble = math.sin(i * 0.9) * 0.06;
      return (base + wobble).clamp(0.0, 1.0);
    });

    final days = List<DayPack>.generate(18, (i) {
      final date = now.subtract(Duration(days: (17 - i)));
      final score = trend[i];
      final total = 8;
      final done = (score * total).round().clamp(0, total);
      return DayPack(
        date: date,
        score: score,
        done: done,
        total: total,
        xp: (score * 90).round(),
        hp: (score * 22).round(),
        varos: (score * 70).round(),
      );
    });

    final heat = List<_HeatDay>.generate(84, (i) {
      final v = ((math.sin(i * 0.55) + 1) / 2).clamp(0.0, 1.0);
      return _HeatDay(now.subtract(Duration(days: i)), v);
    });

    return DailyDataV2(trend: trend, days: days.reversed.toList(), heat: heat);
  }
}

// Streaks
class HabitStreakPack {
  final String name;
  final int streak;
  final int best;
  final int consistency; // %
  HabitStreakPack({required this.name, required this.streak, required this.best, required this.consistency});
}

class StreaksDataV2 {
  final int current;
  final int best;
  final List<_HeatDay> heat;
  final List<_HeatDay> last7;
  final List<HabitStreakPack> habits;
  StreaksDataV2({
    required this.current,
    required this.best,
    required this.heat,
    required this.last7,
    required this.habits,
  });
}

class StreaksMockV2 {
  static StreaksDataV2 build() {
    final now = DateTime.now();

    final heat = List<_HeatDay>.generate(84, (i) {
      final v = ((math.sin(i * 0.55) + 1) / 2).clamp(0.0, 1.0);
      return _HeatDay(now.subtract(Duration(days: i)), v);
    });

    final last7 = List<_HeatDay>.generate(7, (i) {
      // make it a bit “realistic” oscillation (last day slightly lower)
      final v = (0.55 + math.sin((i + 1) * 0.9) * 0.18).clamp(0.0, 1.0);
      return _HeatDay(now.subtract(Duration(days: 6 - i)), v);
    });

    final habits = [
      HabitStreakPack(name: 'Meditación', streak: 12, best: 24, consistency: 78),
      HabitStreakPack(name: 'Gimnasio', streak: 9, best: 20, consistency: 71),
      HabitStreakPack(name: 'Lectura', streak: 7, best: 18, consistency: 66),
      HabitStreakPack(name: 'Dormir temprano', streak: 1, best: 9, consistency: 34),
      HabitStreakPack(name: 'Ahorro diario', streak: 0, best: 6, consistency: 29),
    ];

    return StreaksDataV2(
      current: 12,
      best: 31,
      heat: heat,
      last7: last7,
      habits: habits,
    );
  }
}

class _RiskModel {
  /// Riesgo 0..1
  /// - si últimos 7 días bajos => riesgo sube
  /// - si vienes bajando => riesgo sube
  /// - si racha actual es alta cerca del récord => riesgo baja (orgullo/identidad)
  static double estimateRisk({
    required List<double> last7,
    required int currentStreak,
    required int bestStreak,
  }) {
    if (last7.isEmpty) return 0.4;

    final avg = last7.reduce((a, b) => a + b) / last7.length;
    final trend = last7.last - last7.first; // <0 bajando

    // base: promedio bajo => riesgo alto
    double risk = (1 - avg);

    // penaliza tendencia negativa
    if (trend < 0) risk += (-trend) * 0.6;

    // protege por identidad (racha alta)
    final identity = (currentStreak / math.max(1, bestStreak)).clamp(0.0, 1.0);
    risk -= identity * 0.18;

    // clamp
    return risk.clamp(0.0, 1.0);
  }
}

String _wd(int w) {
  switch (w) {
    case DateTime.monday:
      return 'Lu';
    case DateTime.tuesday:
      return 'Ma';
    case DateTime.wednesday:
      return 'Mi';
    case DateTime.thursday:
      return 'Ju';
    case DateTime.friday:
      return 'Vi';
    case DateTime.saturday:
      return 'Sa';
    case DateTime.sunday:
      return 'Do';
    default:
      return '';
  }
}