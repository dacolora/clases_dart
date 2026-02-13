import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgeHabitScreen extends StatefulWidget {
  const ForgeHabitScreen({super.key});

  @override
  State<ForgeHabitScreen> createState() => _ForgeHabitScreenState();
}

class _ForgeHabitScreenState extends State<ForgeHabitScreen>
    with SingleTickerProviderStateMixin {
  final _titleCtrl = TextEditingController();

  late final AnimationController _bgController;

  Difficulty _difficulty = Difficulty.normal;
  String _mantra = _pickMantra();

  // Simulación de player
  final int _currentLevel = 7;
  final int _xpToNextLevel = 1000; // ejemplo
  final int _currentXpInLevel = 420; // ejemplo

  @override
  void initState() {
    super.initState();
    _bgController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bgController.dispose();
    super.dispose();
  }

  static String _pickMantra() {
    const mantras = [
      "Disciplina > motivación.",
      "Tu yo futuro te está observando.",
      "Lo que repites, te construye.",
      "Hoy forjas carácter. Mañana forjas destino.",
      "No es un hábito. Es una habilidad.",
    ];
    return mantras[Random().nextInt(mantras.length)];
  }

  DifficultySpec get spec => _difficulty.spec;

  int get projectedDays => 30;
  int get projectedXp => spec.gainXp * projectedDays;
  int get projectedVaros => spec.gainVaros * projectedDays;
  int get projectedHp => spec.gainHp * projectedDays;

  int get estimatedLevelGain {
    // Cálculo simple: XP total / xpToNextLevel
    final totalXp = _currentXpInLevel + projectedXp;
    return totalXp ~/ _xpToNextLevel; // niveles ganados estimados
  }

  int get estimatedLevel => _currentLevel + estimatedLevelGain;

  double get impactScore {
    // Una escala simple de “impacto” según dificultad y título
    final base = switch (_difficulty) {
      Difficulty.easy => 0.45,
      Difficulty.normal => 0.65,
      Difficulty.elite => 0.85,
    };
    final hasTitle = _titleCtrl.text.trim().isNotEmpty;
    return (base + (hasTitle ? 0.10 : 0.0)).clamp(0.0, 1.0);
  }

  void _selectDifficulty(Difficulty d) {
    if (_difficulty == d) return;
    HapticFeedback.lightImpact();
    setState(() {
      _difficulty = d;
    });
  }

  void _activateHabit() {
    HapticFeedback.mediumImpact();
    setState(() => _mantra = _pickMantra());

    final name = _titleCtrl.text.trim();
    final title = name.isEmpty ? "Nueva habilidad" : name;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withOpacity(0.85),
        content: Row(
          children: [
            const Text("✨ "),
            Expanded(
              child: Text(
                "Habilidad desbloqueada: $title",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF05070E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          "FORJAR NUEVA HABILIDAD",
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
        actions: [
          TextButton(
            onPressed: _activateHabit,
            child: const Text(
              "Activar",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fondo épico con gradiente + partículas animadas
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) {
              return CustomPaint(
                painter: _EpicBackgroundPainter(
                  t: _bgController.value,
                  // Área Mente: azul profundo
                  colorA: const Color(0xFF06122C),
                  colorB: const Color(0xFF0A2E5C),
                  glow: const Color(0xFF2D9CFF),
                ),
                child: const SizedBox.expand(),
              );
            },
          ),

          // Contenido
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _AreaBanner(
                  areaName: "Mente",
                  subtitle: "Cada hábito moldea tu versión futura.",
                  icon: "🧠",
                ),
                const SizedBox(height: 14),

                _GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "✍️ Nombre de la habilidad",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _titleCtrl,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: "Ej: Meditación estratégica 10 min",
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.06),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.12),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.12),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.28),
                            ),
                          ),
                          prefixIcon: const Icon(Icons.flag_rounded),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Este hábito fortalecerá tu área mental.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ImpactBar(value: impactScore),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                _GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🎚 Dificultad (decisión estratégica)",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DifficultyCard(
                              label: "Fácil",
                              tag: "Riesgo bajo",
                              selected: _difficulty == Difficulty.easy,
                              accent: const Color(0xFF38D39F),
                              gains: const Gains(xp: 15, varos: 20, hp: 3),
                              losses: const Losses(xp: 8, hp: 6),
                              onTap: () => _selectDifficulty(Difficulty.easy),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DifficultyCard(
                              label: "Normal",
                              tag: "Balanceado",
                              selected: _difficulty == Difficulty.normal,
                              accent: const Color(0xFF2D9CFF),
                              gains: const Gains(xp: 25, varos: 40, hp: 5),
                              losses: const Losses(xp: 15, hp: 10),
                              onTap: () => _selectDifficulty(Difficulty.normal),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DifficultyCard(
                              label: "Élite",
                              tag: "Alto impacto",
                              selected: _difficulty == Difficulty.elite,
                              accent: const Color(0xFFFF6B6B),
                              gains: const Gains(xp: 50, varos: 80, hp: 8),
                              losses: const Losses(xp: 30, hp: 18),
                              onTap: () => _selectDifficulty(Difficulty.elite),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                _GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🎁 Al cumplir",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, anim) =>
                            FadeTransition(opacity: anim, child: child),
                        child: Wrap(
                          key: ValueKey(_difficulty),
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _Pill(
                              icon: "🧠",
                              label: "+${spec.gainXp} XP",
                              glow: spec.accent,
                            ),
                            _Pill(
                              icon: "💰",
                              label: "+${spec.gainVaros} Varos",
                              glow: spec.accent,
                            ),
                            _Pill(
                              icon: "❤️",
                              label: "+${spec.gainHp} HP",
                              glow: spec.accent,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "⚠️ Si fallas",
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Wrap(
                          key: ValueKey("loss_${_difficulty.name}"),
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _Pill(
                              icon: "🧠",
                              label: "-${spec.loseXp} XP",
                              glow: const Color(0xFFFF6B6B),
                              negative: true,
                            ),
                            _Pill(
                              icon: "💔",
                              label: "-${spec.loseHp} HP",
                              glow: const Color(0xFFFF6B6B),
                              negative: true,
                            ),
                            _Pill(
                              icon: "🪙",
                              label: "Varos NO bajan",
                              glow: Colors.white.withOpacity(0.35),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Consecuencia real, sin destruirte: pierdes impulso y disciplina.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.70),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                _GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🔮 Proyección a $projectedDays días",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _ProjectionRow(
                        left: "Si lo cumples diario:",
                        right: "Impacto estimado: ${(impactScore * 100).round()}%",
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _Pill(icon: "🧠", label: "+$projectedXp XP", glow: spec.accent),
                          _Pill(icon: "💰", label: "+$projectedVaros Varos", glow: spec.accent),
                          _Pill(icon: "❤️", label: "+$projectedHp HP", glow: spec.accent),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _PlayerForecast(
                        currentLevel: _currentLevel,
                        estimatedLevel: estimatedLevel,
                        accent: spec.accent,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                _GlassCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "“$_mantra”",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => setState(() => _mantra = _pickMantra()),
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                _ActivateButton(
                  accent: spec.accent,
                  onPressed: _activateHabit,
                  label: "🔥 ACTIVAR HÁBITO",
                  subLabel: "Nueva habilidad desbloqueada",
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------- DATA -------------------- */

enum Difficulty { easy, normal, elite }

class DifficultySpec {
  final int gainXp;
  final int gainVaros;
  final int gainHp;
  final int loseXp;
  final int loseHp;
  final Color accent;

  const DifficultySpec({
    required this.gainXp,
    required this.gainVaros,
    required this.gainHp,
    required this.loseXp,
    required this.loseHp,
    required this.accent,
  });
}

extension DifficultyX on Difficulty {
  DifficultySpec get spec {
    switch (this) {
      case Difficulty.easy:
        return const DifficultySpec(
          gainXp: 15,
          gainVaros: 20,
          gainHp: 3,
          loseXp: 8,
          loseHp: 6,
          accent: Color(0xFF38D39F),
        );
      case Difficulty.normal:
        return const DifficultySpec(
          gainXp: 25,
          gainVaros: 40,
          gainHp: 5,
          loseXp: 15,
          loseHp: 10,
          accent: Color(0xFF2D9CFF),
        );
      case Difficulty.elite:
        return const DifficultySpec(
          gainXp: 50,
          gainVaros: 80,
          gainHp: 8,
          loseXp: 30,
          loseHp: 18,
          accent: Color(0xFFFF6B6B),
        );
    }
  }
}

class Gains {
  final int xp;
  final int varos;
  final int hp;
  const Gains({required this.xp, required this.varos, required this.hp});
}

class Losses {
  final int xp;
  final int hp;
  const Losses({required this.xp, required this.hp});
}

/* -------------------- UI PIECES -------------------- */

class _AreaBanner extends StatelessWidget {
  final String areaName;
  final String subtitle;
  final String icon;

  const _AreaBanner({
    required this.areaName,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Área seleccionada: $areaName",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.06),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.35),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ImpactBar extends StatelessWidget {
  final double value;
  const _ImpactBar({required this.value});

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Impacto estimado en tu vida: $pct%",
          style: TextStyle(
            color: Colors.white.withOpacity(0.78),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 10,
            color: Colors.white.withOpacity(0.08),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                height: 10,
                width: MediaQuery.of(context).size.width * 0.70 * value,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.white.withOpacity(0.35),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DifficultyCard extends StatelessWidget {
  final String label;
  final String tag;
  final bool selected;
  final Color accent;
  final Gains gains;
  final Losses losses;
  final VoidCallback onTap;

  const DifficultyCard({
    super.key,
    required this.label,
    required this.tag,
    required this.selected,
    required this.accent,
    required this.gains,
    required this.losses,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = selected ? accent.withOpacity(0.65) : Colors.white.withOpacity(0.12);
    final bg = selected ? Colors.white.withOpacity(0.10) : Colors.white.withOpacity(0.06);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        scale: selected ? 1.03 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: bg,
            border: Border.all(color: border),
            boxShadow: [
              if (selected)
                BoxShadow(
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                  color: accent.withOpacity(0.18),
                )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                  ),
                  if (selected)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: accent.withOpacity(0.18),
                        border: Border.all(color: accent.withOpacity(0.45)),
                      ),
                      child: const Text(
                        "✓",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                tag,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.70),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              _TinyLine(icon: "🧠", text: "+${gains.xp} XP"),
              _TinyLine(icon: "💰", text: "+${gains.varos} Varos"),
              _TinyLine(icon: "❤️", text: "+${gains.hp} HP"),
              const SizedBox(height: 8),
              Opacity(
                opacity: 0.85,
                child: _TinyLine(icon: "⚠️", text: "-${losses.xp} XP / -${losses.hp} HP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TinyLine extends StatelessWidget {
  final String icon;
  final String text;
  const _TinyLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String icon;
  final String label;
  final Color glow;
  final bool negative;

  const _Pill({
    required this.icon,
    required this.label,
    required this.glow,
    this.negative = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Colors.white.withOpacity(0.06);
    final border = negative ? glow.withOpacity(0.45) : Colors.white.withOpacity(0.12);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: bg,
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: glow.withOpacity(0.10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectionRow extends StatelessWidget {
  final String left;
  final String right;

  const _ProjectionRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: TextStyle(
              color: Colors.white.withOpacity(0.80),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          right,
          style: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PlayerForecast extends StatelessWidget {
  final int currentLevel;
  final int estimatedLevel;
  final Color accent;

  const _PlayerForecast({
    required this.currentLevel,
    required this.estimatedLevel,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final diff = estimatedLevel - currentLevel;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withOpacity(0.16),
              border: Border.all(color: accent.withOpacity(0.42)),
            ),
            alignment: Alignment.center,
            child: const Text("🧍‍♂️", style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Impacto en tu personaje",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  "Nivel actual: $currentLevel  →  Nivel estimado: $estimatedLevel  (${diff >= 0 ? "+" : ""}$diff)",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.78),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivateButton extends StatefulWidget {
  final Color accent;
  final VoidCallback onPressed;
  final String label;
  final String subLabel;

  const _ActivateButton({
    required this.accent,
    required this.onPressed,
    required this.label,
    required this.subLabel,
  });

  @override
  State<_ActivateButton> createState() => _ActivateButtonState();
}

class _ActivateButtonState extends State<_ActivateButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.985 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: widget.accent.withOpacity(0.55)),
            boxShadow: [
              BoxShadow(
                blurRadius: 26,
                offset: const Offset(0, 14),
                color: widget.accent.withOpacity(0.22),
              ),
            ],
            gradient: LinearGradient(
              colors: [
                widget.accent.withOpacity(0.35),
                Colors.white.withOpacity(0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subLabel,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.72),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.bolt_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------- BACKGROUND PAINTER -------------------- */

class _EpicBackgroundPainter extends CustomPainter {
  final double t; // 0..1
  final Color colorA;
  final Color colorB;
  final Color glow;

  _EpicBackgroundPainter({
    required this.t,
    required this.colorA,
    required this.colorB,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Gradiente base
    final rect = Offset.zero & size;
    final bg = Paint()
      ..shader = LinearGradient(
        colors: [colorA, colorB, const Color(0xFF05070E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    canvas.drawRect(rect, bg);

    // Glow central
    final glowPaint = Paint()
      ..color = glow.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);

    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.25), 240, glowPaint);

    // Partículas
    final particlePaint = Paint()..color = Colors.white.withOpacity(0.06);
    final rnd = Random(1337);

    for (int i = 0; i < 70; i++) {
      final baseX = rnd.nextDouble() * size.width;
      final speed = 0.15 + rnd.nextDouble() * 0.85;
      final y = (rnd.nextDouble() * size.height + (1 - t) * size.height * speed) % size.height;
      final r = 0.6 + rnd.nextDouble() * 1.8;

      canvas.drawCircle(Offset(baseX, y), r, particlePaint);
    }

    // Neblina suave arriba
    final fog = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.05),
          Colors.transparent,
        ],
        radius: 1.0,
        center: const Alignment(0.0, -1.0),
      ).createShader(rect);

    canvas.drawRect(rect, fog);
  }

  @override
  bool shouldRepaint(covariant _EpicBackgroundPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.colorA != colorA ||
        oldDelegate.colorB != colorB ||
        oldDelegate.glow != glow;
  }
}