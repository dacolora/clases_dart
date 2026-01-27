import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// LIFE ANALYTICS / INFORME DEL JUGADOR
/// - UI premium tipo RPG (oscuro, glow, cards, gradients)
/// - Sin paquetes externos
/// - Radar chart, progress ring, line chart y heatmap hechos con CustomPainter
/// ---------------------------------------------------------------------------

class LifeAnalyticsScreen extends StatefulWidget {
  const LifeAnalyticsScreen({super.key});

  @override
  State<LifeAnalyticsScreen> createState() => _LifeAnalyticsScreenState();
}

class _LifeAnalyticsScreenState extends State<LifeAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _t;

  AnalyticsRange _range = AnalyticsRange.days30;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
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
    final theme = Theme.of(context);

    // ⚠️ Reemplaza esto por tu provider / repo
    final data = LifeAnalyticsMock.build(range: _range);

    return Scaffold(
      backgroundColor: const Color(0xFF070A14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Análisis de Vida'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Filtros',
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _t,
        builder: (context, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                  child: Column(
                    children: [
                      _PlayerHeaderCard(data: data, t: _t.value),
                      const SizedBox(height: 14),
                      _RangeSelector(
                        value: _range,
                        onChanged: (v) {
                          setState(() => _range = v);
                          _c
                            ..reset()
                            ..forward();
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _DisciplineCard(data: data, t: _t.value),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StreakCard(data: data, t: _t.value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _RadarAreasCard(data: data, t: _t.value),
                      const SizedBox(height: 14),
                      _HabitRankingCard(data: data, t: _t.value),
                      const SizedBox(height: 14),
                      _ImpactCard(data: data, t: _t.value),
                      const SizedBox(height: 14),
                      _HeatmapCard(data: data, t: _t.value),
                      const SizedBox(height: 14),
                      _TrendCard(data: data, t: _t.value),
                      const SizedBox(height: 14),
                      _InsightCard(data: data, t: _t.value),
                      const SizedBox(height: 24),
                      Text(
                        'Hecho para que veas quién te estás convirtiendo.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(.55),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// =============================
/// DATA MODELS (simple y claros)
/// =============================
enum AnalyticsRange { days7, days30, days90, all }

class LifeAnalyticsData {
  final String playerName;
  final int levelGlobal;
  final double xpProgress; // 0..1 hacia el siguiente nivel global
  final int xpTotal;
  final int hpCurrent;
  final int hpMax;
  final int varosTotal;

  final double discipline; // 0..1
  final int currentStreak;
  final int bestStreak;

  final List<AreaScore> areas; // 5 áreas para radar
  final List<HabitScore> bestHabits; // top 3
  final List<HabitScore> criticalHabits; // worst 3

  final int monthXpGain;
  final int monthHpGain;
  final int monthVarosGain;
  final int monthHpLoss;

  final List<HeatDay> heatDays; // heatmap
  final List<double> trendValues; // 0..1 para line chart
  final String insightTitle;
  final String insightBody;

  LifeAnalyticsData({
    required this.playerName,
    required this.levelGlobal,
    required this.xpProgress,
    required this.xpTotal,
    required this.hpCurrent,
    required this.hpMax,
    required this.varosTotal,
    required this.discipline,
    required this.currentStreak,
    required this.bestStreak,
    required this.areas,
    required this.bestHabits,
    required this.criticalHabits,
    required this.monthXpGain,
    required this.monthHpGain,
    required this.monthVarosGain,
    required this.monthHpLoss,
    required this.heatDays,
    required this.trendValues,
    required this.insightTitle,
    required this.insightBody,
  });
}

class AreaScore {
  final String name;
  final double value; // 0..1
  final IconData icon;
  AreaScore(this.name, this.value, this.icon);
}

class HabitScore {
  final String name;
  final String area;
  final double completion; // 0..1
  final int streak;
  HabitScore({
    required this.name,
    required this.area,
    required this.completion,
    required this.streak,
  });
}

class HeatDay {
  final DateTime date;
  final double intensity; // 0..1
  HeatDay(this.date, this.intensity);
}

/// ===========================================
/// UI TOKENS (colores y estilos del “universo”)
/// ===========================================
class _Tokens {
  static const bg0 = Color(0xFF070A14);
  static const card = Color(0xFF0C1023);
  static const card2 = Color(0xFF0A0E1D);

  static const glowA = Color(0xFF9B7BFF); // morado
  static const glowB = Color(0xFF49D3FF); // cyan
  static const glowC = Color(0xFFFF4FD8); // fucsia
  static const ok = Color(0xFF48FFB1);
  static const warn = Color(0xFFFFD166);
  static const bad = Color(0xFFFF5C77);

  static LinearGradient cosmicGrad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0C1023),
      Color(0xFF121B3A),
      Color(0xFF0A0E1D),
    ],
  );

  static LinearGradient glowGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glowA, glowB, glowC],
  );
}

/// ================
/// CARDS / SECTIONS
/// ================
class _PlayerHeaderCard extends StatelessWidget {
  final LifeAnalyticsData data;
  final double t;
  const _PlayerHeaderCard({required this.data, required this.t});

  @override
  Widget build(BuildContext context) {
    final level = data.levelGlobal;
    final xpPct = (data.xpProgress * t).clamp(0.0, 1.0);
    final hpPct = (data.hpCurrent / math.max(1, data.hpMax)).clamp(0.0, 1.0);

    return _GlowCard(
      height: 160,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            _AvatarOrb(t: t),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informe del Jugador',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(.9),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${data.playerName} • Nivel $level',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(.75),
                        ),
                  ),
                  const Spacer(),
                  _MiniStatRow(
                    label: 'XP total',
                    value: '${data.xpTotal}',
                    icon: Icons.auto_awesome_rounded,
                  ),
                  const SizedBox(height: 8),
                  _MiniStatRow(
                    label: 'Varos',
                    value: '${data.varosTotal}',
                    icon: Icons.savings_rounded,
                  ),
                  const SizedBox(height: 10),
                  _Bars(
                    xp: xpPct,
                    hp: hpPct * t,
                    hpText: '${data.hpCurrent}/${data.hpMax} HP',
                    xpText: '${(xpPct * 100).round()}% hacia el siguiente nivel',
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

class _RangeSelector extends StatelessWidget {
  final AnalyticsRange value;
  final ValueChanged<AnalyticsRange> onChanged;
  const _RangeSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget chip(String text, AnalyticsRange v) {
      final selected = value == v;
      return InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => onChanged(v),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? _Tokens.glowA.withOpacity(.22) : _Tokens.card,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? _Tokens.glowA.withOpacity(.55)
                  : Colors.white.withOpacity(.08),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selected
                  ? Colors.white.withOpacity(.92)
                  : Colors.white.withOpacity(.65),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip('7D', AnalyticsRange.days7),
        const SizedBox(width: 8),
        chip('30D', AnalyticsRange.days30),
        const SizedBox(width: 8),
        chip('90D', AnalyticsRange.days90),
        const SizedBox(width: 8),
        chip('Todo', AnalyticsRange.all),
      ],
    );
  }
}

class _DisciplineCard extends StatelessWidget {
  final LifeAnalyticsData data;
  final double t;
  const _DisciplineCard({required this.data, required this.t});

  @override
  Widget build(BuildContext context) {
    final value = (data.discipline * t).clamp(0.0, 1.0);
    final pct = (value * 100).round();
    final color = pct >= 80
        ? _Tokens.ok
        : (pct >= 60 ? _Tokens.warn : _Tokens.bad);

    return _Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: CustomPaint(
                painter: _RingPainter(
                  progress: value,
                  color: color,
                  glow: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Disciplina Global',
                    style: _h(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$pct% cumplimiento',
                    style: _b(),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pct >= 80
                        ? 'Ritmo élite. No lo negocies.'
                        : (pct >= 60
                            ? 'Bien. Sube consistencia para despegar.'
                            : 'Estás perdiendo XP por inercia. Ajusta hoy.'),
                    style: _s(),
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

class _StreakCard extends StatelessWidget {
  final LifeAnalyticsData data;
  final double t;
  const _StreakCard({required this.data, required this.t});

  @override
  Widget build(BuildContext context) {
    final a = (data.currentStreak * t).round();
    final b = (data.bestStreak * t).round();

    return _Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rachas', style: _h()),
            const SizedBox(height: 10),
            Row(
              children: [
                _Pill(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Actual',
                  value: '$a días',
                  accent: _Tokens.warn,
                ),
                const SizedBox(width: 10),
                _Pill(
                  icon: Icons.emoji_events_rounded,
                  label: 'Mejor',
                  value: '$b días',
                  accent: _Tokens.glowB,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Tu racha es tu identidad en acción.',
              style: _s(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarAreasCard extends StatelessWidget {
  final LifeAnalyticsData data;
  final double t;
  const _RadarAreasCard({required this.data, required this.t});

  @override
  Widget build(BuildContext context) {
    final values = data.areas.map((e) => (e.value * t).clamp(0.0, 1.0)).toList();

    final best = _bestArea(data.areas);
    final worst = _worstArea(data.areas);

    return _Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Radar de Áreas', style: _h()),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CustomPaint(
                    painter: _RadarPainter(
                      values: values,
                      gridSteps: 4,
                      glowColor: _Tokens.glowA,
                      fillGradient: _Tokens.glowGrad,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      _AreaBadge(
                        title: 'Más fuerte',
                        name: best.name,
                        value: best.value,
                        icon: best.icon,
                        color: _Tokens.ok,
                      ),
                      const SizedBox(height: 10),
                      _AreaBadge(
                        title: 'Más débil',
                        name: worst.name,
                        value: worst.value,
                        icon: worst.icon,
                        color: _Tokens.bad,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Equilibrio = progreso sostenible.',
                        style: _s(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AreaScore _bestArea(List<AreaScore> a) => a.reduce((x, y) => x.value >= y.value ? x : y);
  AreaScore _worstArea(List<AreaScore> a) => a.reduce((x, y) => x.value <= y.value ? x : y);
}

class _HabitRankingCard extends StatelessWidget {
  final LifeAnalyticsData data;
  final double t;
  const _HabitRankingCard({required this.data, required this.t});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ranking de Hábitos', style: _h()),
            const SizedBox(height: 10),
            Text('🥇 Tus hábitos más sólidos', style: _b()),
            const SizedBox(height: 8),
            ...data.bestHabits.map((h) => _HabitRow(h: h, t: t, positive: true)),
            const SizedBox(height: 12),
            Text('⚠️ Hábitos críticos', style: _b()),
            const SizedBox(height: 8),
            ...data.criticalHabits.map((h) => _HabitRow(h: h, t: t, positive: false)),
          ],
        ),
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final LifeAnalyticsData data;
  final double t;
  const _ImpactCard({required this.data, required this.t});

  @override
  Widget build(BuildContext context) {
    int lerpInt(int v) => (v * t).round();

    return _GlowCard(
      height: null,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Impacto en tu Personaje', style: _h()),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _StatChip(
                  icon: Icons.auto_awesome_rounded,
                  label: 'XP',
                  value: '+${lerpInt(data.monthXpGain)}',
                  color: _Tokens.glowB,
                ),
                _StatChip(
                  icon: Icons.favorite_rounded,
                  label: 'HP',
                  value: '+${lerpInt(data.monthHpGain)}',
                  color: _Tokens.ok,
                ),
                _StatChip(
                  icon: Icons.savings_rounded,
                  label: 'Varos',
                  value: '+${lerpInt(data.monthVarosGain)}',
                  color: _Tokens.warn,
                ),
                _StatChip(
                  icon: Icons.warning_amber_rounded,
                  label: 'Pérdida HP',
                  value: '-${lerpInt(data.monthHpLoss)}',
                  color: _Tokens.bad,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Si mantienes este ritmo, subes de nivel más rápido que tu “yo” de ayer.',
              style: _s(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeatmapCard extends StatelessWidget {
  final LifeAnalyticsData data;
  final double t;
  const _HeatmapCard({required this.data, required this.t});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calendario de Consistencia', style: _h()),
            const SizedBox(height: 10),
            Text(
              'Verde intenso = día perfecto • Verde claro = parcial • Gris = fallido',
              style: _s(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 86,
              width: double.infinity,
              child: CustomPaint(
                painter: _HeatmapPainter(
                  days: data.heatDays,
                  t: t,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  final LifeAnalyticsData data;
  final double t;
  const _TrendCard({required this.data, required this.t});

  @override
  Widget build(BuildContext context) {
    final last = data.trendValues.isNotEmpty ? data.trendValues.last : 0.0;
    final prev = data.trendValues.length >= 2 ? data.trendValues[data.trendValues.length - 2] : last;
    final diff = ((last - prev) * 100).round();

    return _Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Evolución', style: _h()),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: CustomPaint(
                painter: _LinePainter(
                  values: data.trendValues.map((e) => (e * t).clamp(0.0, 1.0)).toList(),
                  glowColor: _Tokens.glowB,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              diff >= 0
                  ? 'Vas subiendo: +$diff% vs el periodo anterior.'
                  : 'Vas bajando: $diff% vs el periodo anterior.',
              style: _b(),
            ),
            const SizedBox(height: 6),
            Text(
              'Lo que se mide, se domina.',
              style: _s(),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final LifeAnalyticsData data;
  final double t;
  const _InsightCard({required this.data, required this.t});

  @override
  Widget build(BuildContext context) {
    return _GlowCard(
      height: null,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: _Tokens.glowGrad,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: _Tokens.glowA.withOpacity(.35),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(Icons.psychology_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Opacity(
                opacity: (0.2 + 0.8 * t).clamp(0.0, 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.insightTitle, style: _b()),
                    const SizedBox(height: 6),
                    Text(data.insightBody, style: _s()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================
/// SMALL UI PIECES
/// ================
class _AvatarOrb extends StatelessWidget {
  final double t;
  const _AvatarOrb({required this.t});

  @override
  Widget build(BuildContext context) {
    final s = 68.0;
    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _Tokens.glowGrad,
        boxShadow: [
          BoxShadow(
            color: _Tokens.glowB.withOpacity(.25),
            blurRadius: 30,
            spreadRadius: 2,
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2 + 0.3 * t,
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 40),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.35),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withOpacity(.12)),
              ),
              child: Text(
                'PRO',
                style: TextStyle(
                  color: Colors.white.withOpacity(.85),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _MiniStatRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white.withOpacity(.75)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white.withOpacity(.92), fontSize: 12, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _Bars extends StatelessWidget {
  final double xp;
  final double hp;
  final String xpText;
  final String hpText;

  const _Bars({
    required this.xp,
    required this.hp,
    required this.xpText,
    required this.hpText,
  });

  @override
  Widget build(BuildContext context) {
    Widget bar(double v, Color c) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 10,
          color: Colors.white.withOpacity(.08),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: v.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [c.withOpacity(.95), c.withOpacity(.45)],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bar(xp, _Tokens.glowB),
        const SizedBox(height: 6),
        Text(xpText, style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 11)),
        const SizedBox(height: 10),
        bar(hp, _Tokens.ok),
        const SizedBox(height: 6),
        Text(hpText, style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 11)),
      ],
    );
  }
}

class _AreaBadge extends StatelessWidget {
  final String title;
  final String name;
  final double value;
  final IconData icon;
  final Color color;

  const _AreaBadge({
    required this.title,
    required this.name,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).round();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _Tokens.card2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(.14),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(.35)),
            ),
            child: Icon(icon, size: 18, color: Colors.white.withOpacity(.9)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 11)),
                const SizedBox(height: 2),
                Text('$name • $pct%', style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitRow extends StatelessWidget {
  final HabitScore h;
  final double t;
  final bool positive;

  const _HabitRow({required this.h, required this.t, required this.positive});

  @override
  Widget build(BuildContext context) {
    final v = (h.completion * t).clamp(0.0, 1.0);
    final pct = (v * 100).round();
    final c = positive ? _Tokens.ok : _Tokens.bad;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _Tokens.card2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    h.name,
                    style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900),
                  ),
                ),
                Text(
                  '$pct%',
                  style: TextStyle(color: c.withOpacity(.95), fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${h.area} • racha ${h.streak} días',
              style: TextStyle(color: Colors.white.withOpacity(.55), fontSize: 12),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 9,
                color: Colors.white.withOpacity(.08),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: v,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [c.withOpacity(.9), c.withOpacity(.35)]),
                      ),
                    ),
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

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  const _Pill({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _Tokens.card2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: accent.withOpacity(.14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withOpacity(.35)),
              ),
              child: Icon(icon, size: 18, color: Colors.white.withOpacity(.9)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

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
          Text(
            '$label: ',
            style: TextStyle(color: Colors.white.withOpacity(.65), fontWeight: FontWeight.w700),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white.withOpacity(.92), fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

TextStyle _h() => TextStyle(color: Colors.white.withOpacity(.9), fontWeight: FontWeight.w900, fontSize: 14);
TextStyle _b() => TextStyle(color: Colors.white.withOpacity(.88), fontWeight: FontWeight.w800, fontSize: 13);
TextStyle _s() => TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12, height: 1.25);

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _Tokens.cosmicGrad,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: child,
    );
  }
}

class _GlowCard extends StatelessWidget {
  final double? height;
  final Widget child;
  const _GlowCard({required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: _Tokens.cosmicGrad,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(.10)),
        boxShadow: [
          BoxShadow(
            color: _Tokens.glowA.withOpacity(.14),
            blurRadius: 28,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: _Tokens.glowB.withOpacity(.10),
            blurRadius: 36,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// ===================
/// CUSTOM PAINTERS
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

    if (glow) {
      fg.maskFilter = MaskFilter.blur(BlurStyle.normal, 6);
    }

    canvas.drawCircle(c, r - 6, bg);

    final sweep = 2 * math.pi * progress.clamp(0.0, 1.0);
    final rect = Rect.fromCircle(center: c, radius: r - 6);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, fg);

    // % text
    final pct = (progress * 100).round();
    final tp = TextPainter(
      text: TextSpan(
        text: '$pct',
        style: TextStyle(
          color: Colors.white.withOpacity(.92),
          fontWeight: FontWeight.w900,
          fontSize: 16,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color || oldDelegate.glow != glow;
  }
}

class _RadarPainter extends CustomPainter {
  final List<double> values; // 5 items 0..1
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

    // grid polygons
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

    // axis lines
    for (int i = 0; i < n; i++) {
      final ang = (-math.pi / 2) + (2 * math.pi * i / n);
      final p = center + Offset(math.cos(ang) * radius, math.sin(ang) * radius);
      canvas.drawLine(center, p, gridPaint);
    }

    // value polygon
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

    // dots
    final dotPaint = Paint()..color = Colors.white.withOpacity(.9);
    for (int i = 0; i < n; i++) {
      final v = values[i].clamp(0.0, 1.0);
      final ang = (-math.pi / 2) + (2 * math.pi * i / n);
      final p = center + Offset(math.cos(ang) * radius * v, math.sin(ang) * radius * v);
      canvas.drawCircle(p, 2.6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.gridSteps != gridSteps ||
        oldDelegate.glowColor != glowColor;
  }
}

class _HeatmapPainter extends CustomPainter {
  final List<HeatDay> days;
  final double t;

  _HeatmapPainter({required this.days, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    // Heatmap horizontal: 30-90 días en una rejilla compacta
    // Ajusta: 7 filas (semana) x columnas dinámicas
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
        _Tokens.ok.withOpacity(.90),
        v,
      )!;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, cell, cell),
        const Radius.circular(4),
      );

      final paint = Paint()..color = color;
      canvas.drawRRect(rect, paint);

      // tiny border
      final border = Paint()
        ..color = Colors.white.withOpacity(.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRRect(rect, border);
    }
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) {
    return oldDelegate.days != days || oldDelegate.t != t;
  }
}

class _LinePainter extends CustomPainter {
  final List<double> values; // 0..1
  final Color glowColor;

  _LinePainter({required this.values, required this.glowColor});

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

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = pad + w * (i / (values.length - 1));
      final y = pad + h * (1 - values[i].clamp(0.0, 1.0));
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }

    final glow = Paint()
      ..color = glowColor.withOpacity(.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final line = Paint()
      ..color = glowColor.withOpacity(.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, glow);
    canvas.drawPath(path, line);

    // points
    final p = Paint()..color = Colors.white.withOpacity(.9);
    for (int i = 0; i < values.length; i++) {
      final x = pad + w * (i / (values.length - 1));
      final y = pad + h * (1 - values[i].clamp(0.0, 1.0));
      canvas.drawCircle(Offset(x, y), 2.4, p);
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.glowColor != glowColor;
  }
}

/// ===================
/// MOCK DATA (reemplaza)
/// ===================
class LifeAnalyticsMock {
  static LifeAnalyticsData build({required AnalyticsRange range}) {
    // Cambia un poquito según rango para que sientas el selector
    double factor;
    switch (range) {
      case AnalyticsRange.days7:
        factor = 0.86;
        break;
      case AnalyticsRange.days30:
        factor = 1.0;
        break;
      case AnalyticsRange.days90:
        factor = 0.92;
        break;
      case AnalyticsRange.all:
        factor = 0.95;
        break;
    }

    final areas = <AreaScore>[
      AreaScore('Mente', 0.64 * factor, Icons.psychology_rounded),
      AreaScore('Salud', 0.82 * factor, Icons.favorite_rounded),
      AreaScore('Espiritualidad', 0.41 * factor, Icons.self_improvement_rounded),
      AreaScore('Dinero', 0.58 * factor, Icons.savings_rounded),
      AreaScore('Proyectos', 0.73 * factor, Icons.rocket_launch_rounded),
    ];

    final best = <HabitScore>[
      HabitScore(name: 'Meditar', area: 'Mente', completion: 0.92 * factor, streak: 12),
      HabitScore(name: 'Gimnasio', area: 'Salud', completion: 0.88 * factor, streak: 9),
      HabitScore(name: 'Lectura', area: 'Mente', completion: 0.81 * factor, streak: 7),
    ];

    final critical = <HabitScore>[
      HabitScore(name: 'Dormir temprano', area: 'Salud', completion: 0.34 * factor, streak: 1),
      HabitScore(name: 'Ahorro diario', area: 'Dinero', completion: 0.29 * factor, streak: 0),
      HabitScore(name: 'No redes', area: 'Mente', completion: 0.22 * factor, streak: 0),
    ];

    final now = DateTime.now();
    final daysCount = range == AnalyticsRange.days7
        ? 49
        : (range == AnalyticsRange.days30 ? 70 : 84);

    final heat = List<HeatDay>.generate(daysCount, (i) {
      final d = now.subtract(Duration(days: i));
      final seed = (math.sin(i * 0.55) + 1) / 2; // 0..1
      final intensity = (seed * 0.9 * factor).clamp(0.0, 1.0);
      return HeatDay(d, intensity);
    });

    // trend values
    final trendLen = range == AnalyticsRange.days7 ? 7 : (range == AnalyticsRange.days30 ? 12 : 18);
    final trend = List<double>.generate(trendLen, (i) {
      final base = 0.45 + (i / math.max(1, trendLen - 1)) * 0.35;
      final wobble = (math.sin(i * 0.9) * 0.06);
      return (base + wobble) * factor;
    }).map((e) => e.clamp(0.0, 1.0)).toList();

    final discipline = 0.74 * factor;

    return LifeAnalyticsData(
      playerName: 'Daniel',
      levelGlobal: 6,
      xpProgress: 0.63 * factor,
      xpTotal: (12840 * factor).round(),
      hpCurrent: (82 * factor).round(),
      hpMax: 120,
      varosTotal: (4320 * factor).round(),
      discipline: discipline,
      currentStreak: (12 * factor).round(),
      bestStreak: 31,
      areas: areas,
      bestHabits: best,
      criticalHabits: critical,
      monthXpGain: (420 * factor).round(),
      monthHpGain: (65 * factor).round(),
      monthVarosGain: (310 * factor).round(),
      monthHpLoss: (90 * factor).round(),
      heatDays: heat,
      trendValues: trend,
      insightTitle: 'Insight',
      insightBody:
          'Tu disciplina es buena, pero el descanso está tirando HP al piso. '
          'Si subes “D