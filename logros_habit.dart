import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// ------------------------------------------------------------
/// 1) MODELO
/// ------------------------------------------------------------

enum AchievementCategory {
  longestStreak,
  goals,
  habits,
}

class Achievement {
  final String id;
  final AchievementCategory category;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final int target; // meta (ej: 5 días, 500 xp, etc)

  int progress; // progreso actual
  bool unlocked;

  Achievement({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.target,
    this.progress = 0,
    this.unlocked = false,
  });

  double get percent => target == 0 ? 0 : (progress / target).clamp(0, 1);

  Achievement copy() => Achievement(
        id: id,
        category: category,
        title: title,
        subtitle: subtitle,
        icon: icon,
        accent: accent,
        target: target,
        progress: progress,
        unlocked: unlocked,
      );
}

/// ------------------------------------------------------------
/// 2) “ENGINE” DE LOGROS (ejemplos reales)
///    - Aquí conectas tu app: cada vez que pasa algo,
///      llamas un método y él te devuelve los logros nuevos.
/// ------------------------------------------------------------

class AchievementEngine extends ChangeNotifier {
  /// Simula “storage”/estado global.
  /// En tu app real: persistes en SQLite/Firestore/local.
  final List<Achievement> _achievements = [
    // Racha más larga
    Achievement(
      id: 'streak_2',
      category: AchievementCategory.longestStreak,
      title: 'Racha 2 días',
      subtitle: 'Completa 2 días seguidos',
      icon: Icons.local_fire_department_rounded,
      accent: const Color(0xFF7A7A7A),
      target: 2,
    ),
    Achievement(
      id: 'streak_5',
      category: AchievementCategory.longestStreak,
      title: 'Racha 5 días',
      subtitle: 'Completa 5 días seguidos',
      icon: Icons.local_fire_department_rounded,
      accent: const Color(0xFF7A7A7A),
      target: 5,
    ),
    Achievement(
      id: 'streak_7',
      category: AchievementCategory.longestStreak,
      title: 'Racha 7 días',
      subtitle: 'Completa 7 días seguidos',
      icon: Icons.local_fire_department_rounded,
      accent: const Color(0xFF7A7A7A),
      target: 7,
    ),
    Achievement(
      id: 'streak_30',
      category: AchievementCategory.longestStreak,
      title: 'Racha 30 días',
      subtitle: 'Completa 30 días seguidos',
      icon: Icons.local_fire_department_rounded,
      accent: const Color(0xFF7A7A7A),
      target: 30,
    ),

    // Objetivos (bandera)
    Achievement(
      id: 'goal_100',
      category: AchievementCategory.goals,
      title: '100%',
      subtitle: 'Cumple un objetivo al 100%',
      icon: Icons.flag_rounded,
      accent: const Color(0xFF37C7FF),
      target: 1,
    ),
    Achievement(
      id: 'goal_200',
      category: AchievementCategory.goals,
      title: '200%',
      subtitle: 'Cumple 2 objetivos',
      icon: Icons.flag_rounded,
      accent: const Color(0xFF7A7A7A),
      target: 2,
    ),
    Achievement(
      id: 'goal_300',
      category: AchievementCategory.goals,
      title: '300%',
      subtitle: 'Cumple 3 objetivos',
      icon: Icons.flag_rounded,
      accent: const Color(0xFF7A7A7A),
      target: 3,
    ),

    // Hábitos (tipos)
    Achievement(
      id: 'habit_good',
      category: AchievementCategory.habits,
      title: 'Buen hábito',
      subtitle: 'Completa 10 veces un buen hábito',
      icon: Icons.thumb_up_alt_rounded,
      accent: const Color(0xFF2EE66B),
      target: 10,
    ),
    Achievement(
      id: 'habit_best_start',
      category: AchievementCategory.habits,
      title: 'Mejor comienzo',
      subtitle: 'Completa 5 hábitos en un día',
      icon: Icons.directions_run_rounded,
      accent: const Color(0xFFFF9A2E),
      target: 5,
    ),
    Achievement(
      id: 'xp_500',
      category: AchievementCategory.habits,
      title: 'XP 500',
      subtitle: 'Acumula 500 XP',
      icon: Icons.auto_graph_rounded,
      accent: const Color(0xFF7A7A7A),
      target: 500,
    ),
  ];

  // Estado “global” típico
  int currentStreakDays = 0;
  int habitsCompletedToday = 0;
  int totalGoalsCompleted = 0;
  int totalGoodHabitCompletions = 0;
  int totalXp = 0;

  List<Achievement> get achievements => _achievements.map((e) => e.copy()).toList();

  /// Llamas esto cuando un usuario completa un hábito.
  /// - streakDays: tu racha actual (ya calculada)
  /// - xpEarned: xp ganada por ese hábito
  /// - isGoodHabit: si era buen hábito (o “positivo”)
  /// - completedGoalsDelta: cuántos objetivos completó con esto (0/1)
  ///
  /// Retorna los logros NUEVOS desbloqueados para mostrar el modal.
  List<Achievement> onHabitCompleted({
    required int streakDays,
    required int xpEarned,
    required bool isGoodHabit,
    required int completedGoalsDelta,
    required int habitsCompletedTodayNow,
  }) {
    currentStreakDays = streakDays;
    habitsCompletedToday = habitsCompletedTodayNow;
    totalXp += xpEarned;
    if (isGoodHabit) totalGoodHabitCompletions++;
    totalGoalsCompleted += completedGoalsDelta;

    final newlyUnlocked = <Achievement>[];

    // Actualiza progresos
    _setProgress('streak_2', currentStreakDays);
    _setProgress('streak_5', currentStreakDays);
    _setProgress('streak_7', currentStreakDays);
    _setProgress('streak_30', currentStreakDays);

    _setProgress('goal_100', totalGoalsCompleted >= 1 ? 1 : 0);
    _setProgress('goal_200', totalGoalsCompleted);
    _setProgress('goal_300', totalGoalsCompleted);

    _setProgress('habit_good', totalGoodHabitCompletions);
    _setProgress('habit_best_start', habitsCompletedToday);
    _setProgress('xp_500', totalXp);

    // Desbloquea los que hayan llegado
    for (final a in _achievements) {
      if (!a.unlocked && a.progress >= a.target) {
        a.unlocked = true;
        newlyUnlocked.add(a.copy());
      }
    }

    if (newlyUnlocked.isNotEmpty) notifyListeners();
    return newlyUnlocked;
  }

  void _setProgress(String id, int value) {
    final idx = _achievements.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    _achievements[idx].progress = max(_achievements[idx].progress, value);
  }

  /// Útil para debug/reset
  void resetAll() {
    for (final a in _achievements) {
      a.progress = 0;
      a.unlocked = false;
    }
    currentStreakDays = 0;
    habitsCompletedToday = 0;
    totalGoalsCompleted = 0;
    totalGoodHabitCompletions = 0;
    totalXp = 0;
    notifyListeners();
  }
}

/// ------------------------------------------------------------
/// 3) COLA PARA MOSTRAR MODALES SI SE DESBLOQUEAN VARIOS A LA VEZ
/// ------------------------------------------------------------

class AchievementModalQueue {
  final _queue = <Achievement>[];
  bool _isShowing = false;

  void enqueueAll(
    BuildContext context,
    List<Achievement> achievements, {
    required VoidCallback onViewAll,
  }) {
    _queue.addAll(achievements);
    _pump(context, onViewAll: onViewAll);
  }

  Future<void> _pump(
    BuildContext context, {
    required VoidCallback onViewAll,
  }) async {
    if (_isShowing) return;
    _isShowing = true;

    while (_queue.isNotEmpty) {
      final a = _queue.removeAt(0);
      await showAchievementUnlockedModal(
        context,
        achievement: a,
        onViewAll: onViewAll,
      );
    }

    _isShowing = false;
  }
}

/// ------------------------------------------------------------
/// 4) UI: PANTALLÓN DE LOGROS
/// ------------------------------------------------------------

class AchievementsScreen extends StatefulWidget {
  final AchievementEngine engine;

  const AchievementsScreen({super.key, required this.engine});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final _queue = AchievementModalQueue();

  @override
  void initState() {
    super.initState();

    // Demo: cada vez que el engine cambie, podrías revisar unlocks.
    // En tu app real: mejor lo disparas justo cuando llega `newlyUnlocked`.
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.engine.achievements;

    final longestStreak = items.where((e) => e.category == AchievementCategory.longestStreak).toList();
    final goals = items.where((e) => e.category == AchievementCategory.goals).toList();
    final habits = items.where((e) => e.category == AchievementCategory.habits).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0E0F12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F12),
        elevation: 0,
        centerTitle: true,
        title: const Text('Logros'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => widget.engine.resetAll()),
            child: const Text('Reset', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
        children: [
          _sectionTitle('Racha más larga'),
          const SizedBox(height: 10),
          AchievementsGrid(
            achievements: longestStreak,
            onTap: (a) => _openDetail(context, a),
          ),
          const SizedBox(height: 22),

          _sectionTitle('Objetivos'),
          const SizedBox(height: 10),
          AchievementsGrid(
            achievements: goals,
            onTap: (a) => _openDetail(context, a),
          ),
          const SizedBox(height: 22),

          _sectionTitle('Hábitos'),
          const SizedBox(height: 10),
          AchievementsGrid(
            achievements: habits,
            onTap: (a) => _openDetail(context, a),
          ),

          const SizedBox(height: 22),
          TextButton(
            onPressed: () {
              // DEMO: simula “completé un hábito” y desbloquea cosas.
              final newly = widget.engine.onHabitCompleted(
                streakDays: widget.engine.currentStreakDays + 1,
                xpEarned: 80,
                isGoodHabit: true,
                completedGoalsDelta: (Random().nextBool() ? 1 : 0),
                habitsCompletedTodayNow: widget.engine.habitsCompletedToday + 1,
              );

              if (newly.isNotEmpty) {
                _queue.enqueueAll(
                  context,
                  newly,
                  onViewAll: () {
                    Navigator.of(context).pop(); // cierra modal
                    // ya estás en la pantalla de logros, pero podrías navegar aquí
                  },
                );
              }

              setState(() {});
            },
            child: const Text('Simular completar hábito (demo)'),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, Achievement a) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17181D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 14),
              HexBadge(
                achievement: a,
                size: 86,
                showLabel: false,
              ),
              const SizedBox(height: 14),
              Text(
                a.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                a.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              _progressBar(a),
              const SizedBox(height: 8),
              Text(
                a.unlocked
                    ? 'Desbloqueado ✅'
                    : 'Progreso: ${a.progress}/${a.target}  (${(a.percent * 100).round()}%)',
                style: TextStyle(color: a.unlocked ? Colors.greenAccent : Colors.white54),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _progressBar(Achievement a) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        minHeight: 10,
        value: a.percent,
        backgroundColor: Colors.white10,
        valueColor: AlwaysStoppedAnimation<Color>(a.unlocked ? a.accent : Colors.white30),
      ),
    );
  }

  Widget _sectionTitle(String t) {
    return Text(
      t,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

/// Grid simple (como en tu screenshot)
class AchievementsGrid extends StatelessWidget {
  final List<Achievement> achievements;
  final void Function(Achievement) onTap;

  const AchievementsGrid({
    super.key,
    required this.achievements,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: achievements.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (_, i) {
        final a = achievements[i];
        return GestureDetector(
          onTap: () => onTap(a),
          child: HexBadge(achievement: a),
        );
      },
    );
  }
}

/// ------------------------------------------------------------
/// 5) BADGE HEXAGONAL (UI core)
//  - bloqueado: gris
//  - desbloqueado: color del logro
/// ------------------------------------------------------------

class HexBadge extends StatelessWidget {
  final Achievement achievement;
  final double size;
  final bool showLabel;

  const HexBadge({
    super.key,
    required this.achievement,
    this.size = 92,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final a = achievement;
    final bg = a.unlocked ? a.accent : const Color(0xFF6B6B6B);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipPath(
          clipper: _HexClipper(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: bg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // fondo sutil
                Opacity(
                  opacity: a.unlocked ? 0.12 : 0.08,
                  child: Icon(a.icon, size: size * 0.88, color: Colors.white),
                ),
                Icon(a.icon, size: size * 0.44, color: Colors.white),
              ],
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 8),
          Text(
            a.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: a.unlocked ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}

class _HexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final r = min(w, h) / 2;

    // Hex regular (flat-top)
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (pi / 3) * i - pi / 6;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// ------------------------------------------------------------
/// 6) MODAL “¡Nuevo logro!” + animación + confetti (sin paquetes)
/// ------------------------------------------------------------

Future<void> showAchievementUnlockedModal(
  BuildContext context, {
  required Achievement achievement,
  required VoidCallback onViewAll,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _AchievementUnlockedSheet(
        achievement: achievement,
        onViewAll: onViewAll,
      );
    },
  );
}

class _AchievementUnlockedSheet extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onViewAll;

  const _AchievementUnlockedSheet({
    required this.achievement,
    required this.onViewAll,
  });

  @override
  State<_AchievementUnlockedSheet> createState() => _AchievementUnlockedSheetState();
}

class _AchievementUnlockedSheetState extends State<_AchievementUnlockedSheet>
    with TickerProviderStateMixin {
  late final AnimationController _popCtrl;
  late final Animation<double> _pop;

  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();

    _popCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _pop = CurvedAnimation(parent: _popCtrl, curve: Curves.elasticOut);

    _confetti = ConfettiController(vsync: this);
    _popCtrl.forward();
    _confetti.play();
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.achievement;

    return SafeArea(
      child: Stack(
        children: [
          // Confetti overlay
          Positioned.fill(
            child: IgnorePointer(
              child: ConfettiOverlay(controller: _confetti),
            ),
          ),

          // Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              decoration: BoxDecoration(
                color: const Color(0xFF17181D),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '¡Nuevo logro!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),

                  ScaleTransition(
                    scale: _pop,
                    child: HexBadge(
                      achievement: a.copy()..unlocked = true, // forzar color en modal
                      size: 110,
                      showLabel: false,
                    ),
                  ),

                  const SizedBox(height: 14),
                  Text(
                    a.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '¡Felicidades! Sigan trabajando así de bien.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D6BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: widget.onViewAll,
                      child: const Text(
                        'Ver todos los logros',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------
/// 7) CONFETTI SIN PAQUETES (Particles + CustomPainter)
/// ------------------------------------------------------------

class ConfettiController extends ChangeNotifier implements TickerProvider {
  final TickerProvider vsync;
  late final Ticker _ticker;

  final _rnd = Random();
  final List<_Particle> _particles = [];

  Duration _elapsed = Duration.zero;
  bool _playing = false;

  ConfettiController({required this.vsync}) {
    _ticker = vsync.createTicker(_onTick);
  }

  void play() {
    _particles.clear();
    _elapsed = Duration.zero;
    _playing = true;

    // crea partículas
    for (int i = 0; i < 120; i++) {
      _particles.add(_Particle(
        x: _rnd.nextDouble(),
        y: -0.1 - _rnd.nextDouble() * 0.6,
        vx: (_rnd.nextDouble() - 0.5) * 0.6,
        vy: 0.8 + _rnd.nextDouble() * 1.4,
        size: 2.0 + _rnd.nextDouble() * 4.5,
        rot: _rnd.nextDouble() * pi,
        vr: (_rnd.nextDouble() - 0.5) * 0.35,
        // colores tipo “confetti”
        color: _pickColor(),
      ));
    }

    _ticker.start();
    notifyListeners();
  }

  void stop() {
    _playing = false;
    _ticker.stop();
    notifyListeners();
  }

  Color _pickColor() {
    const colors = [
      Color(0xFF37C7FF),
      Color(0xFF5D6BFF),
      Color(0xFF2EE66B),
      Color(0xFFFF9A2E),
      Color(0xFFFF4D6D),
      Color(0xFFFFFFFF),
    ];
    return colors[_rnd.nextInt(colors.length)];
  }

  void _onTick(Duration d) {
    if (!_playing) return;

    final delta = d - _elapsed;
    _elapsed = d;

    final dt = delta.inMilliseconds / 1000.0;

    // actualiza partículas
    for (final p in _particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.rot += p.vr * dt;
      p.vy += 0.6 * dt; // gravedad

      // wrap horizontal (mantener dentro)
      if (p.x < -0.1) p.x = 1.1;
      if (p.x > 1.1) p.x = -0.1;
    }

    // dura ~2.3s
    if (_elapsed.inMilliseconds > 2300) {
      stop();
      return;
    }

    notifyListeners();
  }

  List<_Particle> get particles => _particles;

  @override
  Ticker createTicker(TickerCallback onTick) => vsync.createTicker(onTick);
}

class _Particle {
  double x, y;
  double vx, vy;
  double size;
  double rot, vr;
  final Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.rot,
    required this.vr,
    required this.color,
  });
}

class ConfettiOverlay extends StatelessWidget {
  final ConfettiController controller;

  const ConfettiOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return CustomPaint(
          painter: _ConfettiPainter(controller.particles),
        );
      },
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;

  _ConfettiPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final px = p.x * size.width;
      final py = p.y * size.height;

      final paint = Paint()..color = p.color.withOpacity(0.95);
      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rot);

      // rectangulito tipo confetti
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: p.size * 1.6,
        height: p.size,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(p.size * 0.3)),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

/// ------------------------------------------------------------
/// 8) DEMO APP ENTRY
/// ------------------------------------------------------------

class AchievementsDemoApp extends StatelessWidget {
  AchievementsDemoApp({super.key});

  final engine = AchievementEngine();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: false),
      home: AchievementsScreen(engine: engine),
    );
  }
}