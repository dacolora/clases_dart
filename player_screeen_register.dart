import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ============================================================================
/// PLAYER PROFILE SCREEN - “CLIENT EXPERIENCE” 😈🔥
/// - Basado en PlayerHeaderCard (incluido acá como versión pro si no lo tienes)
/// - XP, Nivel, HP (% vida), progreso general
/// - Varos: acumulado / gastado / disponible
/// - Varos por hábito (ranking)
/// - Gastos (ledger): en qué se la gastó (skins, boosts, items, etc.)
/// - Stats de vida: días activos, hábitos completados, mejor racha
///
/// Sin paquetes externos.
/// ============================================================================

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({super.key});

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _t;

  int selectedHabitIndex = 0;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 850));
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
    final data = PlayerProfileMock.build();
    selectedHabitIndex = selectedHabitIndex.clamp(0, data.habits.length - 1);
    final habit = data.habits[selectedHabitIndex];

    return Scaffold(
      backgroundColor: _T.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Perfil del Jugador'),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _t,
        builder: (_, __) {
          final t = _t.value;

          final xpNow = (data.xpCurrent * t).round();
          final hpPct = (data.hpPercent * t).clamp(0.0, 1.0);

          final varosEarned = (data.varosTotalEarned * t).round();
          final varosSpent = (data.varosSpent * t).round();
          final varosBalance = math.max(0, varosEarned - varosSpent);

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =======================
                // HEADER (PlayerHeaderCard)
                // =======================
                PlayerHeaderCard(
                  playerName: data.playerName,
                  title: data.title,
                  level: data.level,
                  xpCurrent: xpNow,
                  xpToNext: data.xpToNext,
                  hpPercent: hpPct,
                  lifePercent: (data.lifePercent * t).clamp(0.0, 1.0),
                  streakBest: data.bestStreak,
                  daysActive: data.daysActive,
                ),

                const SizedBox(height: 14),

                // =======================
                // WALLET / VAROS SUMMARY
                // =======================
                _GlowCard(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('Economía del jugador', style: _h())),
                            _Badge(
                              icon: Icons.savings_rounded,
                              label: 'Saldo',
                              value: _fmt(varosBalance),
                              color: _T.warn,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _StatChip(
                              icon: Icons.add_circle_rounded,
                              label: 'Acumulado',
                              value: _fmt(varosEarned),
                              color: _T.ok,
                            ),
                            _StatChip(
                              icon: Icons.shopping_bag_rounded,
                              label: 'Gastado',
                              value: _fmt(varosSpent),
                              color: _T.bad,
                            ),
                            _StatChip(
                              icon: Icons.wallet_rounded,
                              label: 'Disponible',
                              value: _fmt(varosBalance),
                              color: _T.warn,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('De dónde viene el varo (ranking por hábito)', style: _b()),
                        const SizedBox(height: 10),
                        ...List.generate(data.habits.length, (i) {
                          final h = data.habits[i];
                          final max = data.habits.map((e) => e.varosEarned).reduce(math.max).toDouble();
                          final v = (h.varosEarned / math.max(1, max) * t).clamp(0.0, 1.0);
                          final selected = i == selectedHabitIndex;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => setState(() => selectedHabitIndex = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: selected ? _T.warn.withOpacity(.12) : _T.card2,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: selected ? _T.warn.withOpacity(.35) : Colors.white.withOpacity(.08),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            h.name,
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(.92),
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '+${_fmt((h.varosEarned * t).round())}',
                                          style: TextStyle(
                                            color: _T.warn.withOpacity(.95),
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _Bar(value: v, accent: _T.warn),
                                    const SizedBox(height: 6),
                                    Text('XP +${h.xpEarned} • HP +${h.hpEarned} • racha ${h.streak}d', style: _s()),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // =======================
                // HABIT DETAIL (selected)
                // =======================
                _Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('Detalle del hábito', style: _h())),
                            _Badge(
                              icon: Icons.local_fire_department_rounded,
                              label: 'Racha',
                              value: '${(habit.streak * t).round()}d',
                              color: _T.warn,
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        _HabitHero(habit: habit, t: t),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _StatChip(icon: Icons.auto_awesome_rounded, label: 'XP', value: '+${(habit.xpEarned * t).round()}', color: _T.glowB),
                            _StatChip(icon: Icons.favorite_rounded, label: 'HP', value: '+${(habit.hpEarned * t).round()}', color: _T.ok),
                            _StatChip(icon: Icons.savings_rounded, label: 'Varos', value: '+${(habit.varosEarned * t).round()}', color: _T.warn),
                            _StatChip(icon: Icons.check_circle_rounded, label: 'Completado', value: '${(habit.completedCount * t).round()}x', color: _T.glowA),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text('Progreso mensual (mock)', style: _b()),
                        const SizedBox(height: 10),
                        _MiniMonthBars(values: habit.monthProgress.map((e) => (e * t).clamp(0.0, 1.0)).toList()),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // =======================
                // SPENDING LEDGER (en qué se gastó)
                // =======================
                _GlowCard(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('En qué te gastaste los varos', style: _h())),
                            _Badge(
                              icon: Icons.receipt_long_rounded,
                              label: 'Movimientos',
                              value: '${data.spends.length}',
                              color: _T.glowA,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...data.spends.take(8).map((s) => _SpendRow(spend: s, t: t)),
                        const SizedBox(height: 8),
                        Text('Tip: si quieres subir % de vida, compra “Boost de Consistencia” y úsalo en días flojos.', style: _s()),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // =======================
                // LIFE STATS / IDENTITY
                // =======================
                _Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estadísticas de vida', style: _h()),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _StatChip(icon: Icons.calendar_today_rounded, label: 'Días activos', value: '${(data.daysActive * t).round()}', color: _T.glowB),
                            _StatChip(icon: Icons.checklist_rounded, label: 'Hábitos hechos', value: '${(data.totalCompletions * t).round()}', color: _T.ok),
                            _StatChip(icon: Icons.emoji_events_rounded, label: 'Mejor racha', value: '${(data.bestStreak * t).round()}d', color: _T.warn),
                            _StatChip(icon: Icons.trending_up_rounded, label: 'Mejor semana', value: '${(data.bestWeekPct * 100 * t).round()}%', color: _T.glowA),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('Tu identidad actual', style: _b()),
                        const SizedBox(height: 10),
                        _IdentityCard(
                          headline: 'Jugador disciplinado',
                          body:
                              'Cuando fallas, no negocias el “mañana obligatorio”. Si el día está pesado, haces versión mínima (10 min) y proteges la racha.',
                          t: t,
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

  String _fmt(int n) {
    // simple format (ej: 12.4k)
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

/// ============================================================================
/// PLAYER HEADER CARD (PRO)
/// ============================================================================
class PlayerHeaderCard extends StatelessWidget {
  final String playerName;
  final String title;
  final int level;
  final int xpCurrent;
  final int xpToNext;
  final double hpPercent;   // 0..1
  final double lifePercent; // 0..1
  final int streakBest;
  final int daysActive;

  const PlayerHeaderCard({
    super.key,
    required this.playerName,
    required this.title,
    required this.level,
    required this.xpCurrent,
    required this.xpToNext,
    required this.hpPercent,
    required this.lifePercent,
    required this.streakBest,
    required this.daysActive,
  });

  @override
  Widget build(BuildContext context) {
    final xpProg = (xpCurrent / math.max(1, xpToNext)).clamp(0.0, 1.0);
    final hp = hpPercent.clamp(0.0, 1.0);
    final life = lifePercent.clamp(0.0, 1.0);

    return _GlowCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // avatar placeholder
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: _T.LineGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: _T.glowA.withOpacity(.25), blurRadius: 18, spreadRadius: 1)],
                  ),
                  child: Icon(Icons.person_rounded, color: Colors.white.withOpacity(.92)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(playerName, style: TextStyle(color: Colors.white.withOpacity(.95), fontWeight: FontWeight.w900, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(title, style: _s()),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _Badge(icon: Icons.stairs_rounded, label: 'Nivel', value: '$level', color: _T.glowB),
                          const SizedBox(width: 8),
                          _Badge(icon: Icons.local_fire_department_rounded, label: 'Best', value: '${streakBest}d', color: _T.warn),
                          const SizedBox(width: 8),
                          _Badge(icon: Icons.calendar_today_rounded, label: 'Días', value: '$daysActive', color: _T.glowA),
                        ],
                      ),
                    ],
                  ),
                ),
                // HP ring
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CustomPaint(
                    painter: _RingPainter(progress: hp, color: hp > .66 ? _T.ok : (hp > .33 ? _T.warn : _T.bad), glow: true),
                  ),
                )
              ],
            ),

            const SizedBox(height: 14),

            // XP bar
            Row(
              children: [
                Icon(Icons.auto_awesome_rounded, size: 18, color: _T.glowB.withOpacity(.95)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Experiencia', style: TextStyle(color: Colors.white.withOpacity(.82), fontWeight: FontWeight.w900)),
                ),
                Text('$xpCurrent / $xpToNext', style: TextStyle(color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 10),
            _Bar(value: xpProg, accent: _T.glowB),
            const SizedBox(height: 14),

            // life percent big
            Container(
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
                    width: 56,
                    height: 56,
                    child: CustomPaint(painter: _RingPainter(progress: life, color: _T.glowA, glow: true)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('% de vida (lifetime)', style: _b()),
                        const SizedBox(height: 6),
                        Text(
                          '${(life * 100).round()}% completado • progreso total',
                          style: _s(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// UI PARTS
/// ============================================================================
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

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _Badge({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.26)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white.withOpacity(.92)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(.70), fontWeight: FontWeight.w900, fontSize: 11)),
          const SizedBox(width: 6),
          Text(value, style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900, fontSize: 11)),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double value;
  final Color accent;
  const _Bar({required this.value, required this.accent});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 10,
        color: Colors.white.withOpacity(.08),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [accent.withOpacity(.9), accent.withOpacity(.35)]),
            ),
          ),
        ),
      ),
    );
  }
}

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

/// Habit hero
class _HabitHero extends StatelessWidget {
  final HabitEconomyPack habit;
  final double t;
  const _HabitHero({required this.habit, required this.t});

  @override
  Widget build(BuildContext context) {
    final pct = (habit.completionRate * t).clamp(0.0, 1.0);
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
            width: 62,
            height: 62,
            child: CustomPaint(painter: _RingPainter(progress: pct, color: _T.ok, glow: true)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.name, style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text('tasa de cumplimiento ${(pct * 100).round()}% • completado ${habit.completedCount} veces', style: _s()),
                const SizedBox(height: 6),
                Text(habit.lore, style: _s()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Monthly bars
class _MiniMonthBars extends StatelessWidget {
  final List<double> values; // 6 months
  const _MiniMonthBars({required this.values});

  @override
  Widget build(BuildContext context) {
    const labels = ['Ago', 'Sep', 'Oct', 'Nov', 'Dic', 'Ene'];
    return Row(
      children: List.generate(values.length, (i) {
        final v = values[i].clamp(0.0, 1.0);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Container(
                  height: 70,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(.06)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FractionallySizedBox(
                      heightFactor: v,
                      widthFactor: 1,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [_T.ok.withOpacity(.9), _T.ok.withOpacity(.25)]),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(labels[i], style: _s()),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// Spend row
class _SpendRow extends StatelessWidget {
  final SpendPack spend;
  final double t;
  const _SpendRow({required this.spend, required this.t});

  @override
  Widget build(BuildContext context) {
    final amount = (spend.amount * t).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _T.card2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: spend.accent.withOpacity(.14),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: spend.accent.withOpacity(.28)),
              ),
              child: Icon(spend.icon, color: Colors.white.withOpacity(.92), size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(spend.title, style: _b()),
                  const SizedBox(height: 4),
                  Text('${spend.category} • ${spend.dateLabel}', style: _s()),
                ],
              ),
            ),
            Text(
              '-$amount',
              style: TextStyle(color: _T.bad.withOpacity(.95), fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}

/// Identity card
class _IdentityCard extends StatelessWidget {
  final String headline;
  final String body;
  final double t;
  const _IdentityCard({required this.headline, required this.body, required this.t});

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
            child: Icon(Icons.psychology_alt_rounded, color: Colors.white.withOpacity(.95)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(headline, style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(body, style: _s()),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// ============================================================================
/// MOCK MODELS
/// ============================================================================
class PlayerProfileData {
  final String playerName;
  final String title;

  final int level;
  final int xpCurrent;
  final int xpToNext;

  final double hpPercent;
  final double lifePercent;

  final int daysActive;
  final int totalCompletions;
  final int bestStreak;
  final double bestWeekPct;

  final int varosTotalEarned;
  final int varosSpent;

  final List<HabitEconomyPack> habits;
  final List<SpendPack> spends;

  PlayerProfileData({
    required this.playerName,
    required this.title,
    required this.level,
    required this.xpCurrent,
    required this.xpToNext,
    required this.hpPercent,
    required this.lifePercent,
    required this.daysActive,
    required this.totalCompletions,
    required this.bestStreak,
    required this.bestWeekPct,
    required this.varosTotalEarned,
    required this.varosSpent,
    required this.habits,
    required this.spends,
  });
}

class HabitEconomyPack {
  final String name;
  final int xpEarned;
  final int hpEarned;
  final int varosEarned;

  final int streak;
  final int completedCount;
  final double completionRate;

  final String lore;
  final List<double> monthProgress; // 6

  HabitEconomyPack({
    required this.name,
    required this.xpEarned,
    required this.hpEarned,
    required this.varosEarned,
    required this.streak,
    required this.completedCount,
    required this.completionRate,
    required this.lore,
    required this.monthProgress,
  });
}

class SpendPack {
  final String title;
  final String category;
  final String dateLabel;
  final int amount;
  final IconData icon;
  final Color accent;

  SpendPack({
    required this.title,
    required this.category,
    required this.dateLabel,
    required this.amount,
    required this.icon,
    required this.accent,
  });
}

class PlayerProfileMock {
  static PlayerProfileData build() {
    final habits = [
      HabitEconomyPack(
        name: 'Gimnasio',
        xpEarned: 1240,
        hpEarned: 280,
        varosEarned: 980,
        streak: 9,
        completedCount: 41,
        completionRate: 0.78,
        lore: 'Tu cuerpo es tu armadura. Cada sesión sube tu presencia.',
        monthProgress: [0.56, 0.62, 0.70, 0.74, 0.78, 0.80],
      ),
      HabitEconomyPack(
        name: 'Muay Thai / Box',
        xpEarned: 980,
        hpEarned: 220,
        varosEarned: 820,
        streak: 6,
        completedCount: 30,
        completionRate: 0.66,
        lore: 'Disciplina bajo presión. Te forma la mente.',
        monthProgress: [0.44, 0.52, 0.58, 0.62, 0.68, 0.70],
      ),
      HabitEconomyPack(
        name: 'Meditación',
        xpEarned: 820,
        hpEarned: 260,
        varosEarned: 560,
        streak: 12,
        completedCount: 52,
        completionRate: 0.84,
        lore: 'Silencio = control. El jugador que se domina, gana.',
        monthProgress: [0.62, 0.68, 0.74, 0.78, 0.82, 0.86],
      ),
      HabitEconomyPack(
        name: 'Lectura',
        xpEarned: 740,
        hpEarned: 0,
        varosEarned: 430,
        streak: 7,
        completedCount: 45,
        completionRate: 0.70,
        lore: 'Ideas nuevas = upgrades permanentes.',
        monthProgress: [0.48, 0.52, 0.58, 0.60, 0.66, 0.68],
      ),
      HabitEconomyPack(
        name: 'No malgastar',
        xpEarned: 520,
        hpEarned: 0,
        varosEarned: 910,
        streak: 3,
        completedCount: 23,
        completionRate: 0.52,
        lore: 'El varo no se gana: se protege.',
        monthProgress: [0.30, 0.34, 0.42, 0.48, 0.52, 0.54],
      ),
    ];

    final totalVaros = habits.fold<int>(0, (a, b) => a + b.varosEarned);
    final spends = [
      SpendPack(title: 'Skin “Cosmic Knight”', category: 'Skins', dateLabel: 'hace 3 días', amount: 240, icon: Icons.auto_awesome_rounded, accent: _T.glowA),
      SpendPack(title: 'Boost de Consistencia', category: 'Boosts', dateLabel: 'hace 6 días', amount: 120, icon: Icons.bolt_rounded, accent: _T.ok),
      SpendPack(title: 'Fondo “Nebula”', category: 'Fondos', dateLabel: 'hace 9 días', amount: 180, icon: Icons.landscape_rounded, accent: _T.glowB),
      SpendPack(title: 'Sticker pack', category: 'Cosméticos', dateLabel: 'hace 12 días', amount: 80, icon: Icons.emoji_emotions_rounded, accent: _T.warn),
      SpendPack(title: 'Potion HP', category: 'Items', dateLabel: 'hace 15 días', amount: 60, icon: Icons.favorite_rounded, accent: _T.bad),
    ];

    final spent = spends.fold<int>(0, (a, b) => a + b.amount);

    return PlayerProfileData(
      playerName: 'Daniel',
      title: 'Monk Mode • My Life Game',
      level: 17,
      xpCurrent: 3420,
      xpToNext: 5000,
      hpPercent: 0.74,
      lifePercent: 0.41,
      daysActive: 96,
      totalCompletions: 412,
      bestStreak: 31,
      bestWeekPct: 0.86,
      varosTotalEarned: totalVaros,
      varosSpent: spent,
      habits: habits..sort((a, b) => b.varosEarned.compareTo(a.varosEarned)),
      spends: spends,
    );
  }
}