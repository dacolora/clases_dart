import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/life_area.dart';
import '../create_habit/create_habit_screen.dart';

class AreaOnboardingScreen extends StatefulWidget {
  final LifeArea area;

  const AreaOnboardingScreen({super.key, required this.area});

  @override
  State<AreaOnboardingScreen> createState() => _AreaOnboardingScreenState();
}

class _AreaOnboardingScreenState extends State<AreaOnboardingScreen> {
  final controller = PageController();
  int page = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glow = Color(widget.area.accentColor);
    final slides = widget.area.slides;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.area.title),
        actions: [
          TextButton(
            onPressed: () => _goCreate(context),
            child: Text(
              'Saltar',
              style: TextStyle(
                color: glow.withOpacity(0.95),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.1,
              colors: [
                glow.withOpacity(0.18),
                const Color(0xFF060A14),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Column(
              children: [
                _HeroAreaCard(area: widget.area, glow: glow),
                const SizedBox(height: 14),
                Expanded(
                  child: PageView.builder(
                    controller: controller,
                    itemCount: slides.length,
                    onPageChanged: (i) => setState(() => page = i),
                    itemBuilder: (context, index) {
                      final s = slides[index];
                      return _SlideCard(slide: s, glow: glow);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                _Dots(count: slides.length, index: page, glow: glow),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: page == 0
                            ? () => Navigator.pop(context)
                            : () => controller.previousPage(
                                  duration: const Duration(milliseconds: 260),
                                  curve: Curves.easeOutCubic,
                                ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white.withOpacity(0.85),
                          side: BorderSide(color: Colors.white.withOpacity(0.12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(page == 0 ? 'Volver' : 'Atrás'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          if (page < slides.length - 1) {
                            controller.nextPage(
                              duration: const Duration(milliseconds: 260),
                              curve: Curves.easeOutCubic,
                            );
                          } else {
                            _goCreate(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: glow.withOpacity(0.22),
                          foregroundColor: glow.withOpacity(0.98),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: glow.withOpacity(0.45)),
                          ),
                        ),
                        child: Text(
                          page < slides.length - 1 ? 'Siguiente' : 'Crear hábito',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goCreate(BuildContext context) {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => CreateHabitScreen(area: widget.area),
        transitionsBuilder: (_, anim, __, child) {
          final curve = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curve,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, 0.05), end: Offset.zero)
                  .animate(curve),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _HeroAreaCard extends StatelessWidget {
  final LifeArea area;
  final Color glow;

  const _HeroAreaCard({required this.area, required this.glow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFF0B1224).withOpacity(0.92),
        border: Border.all(color: glow.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: glow.withOpacity(0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  glow.withOpacity(0.55),
                  glow.withOpacity(0.12),
                  Colors.transparent,
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Text(area.iconGlyph, style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  area.becomeTitle,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  area.becomeDescription,
                  style: TextStyle(
                    fontSize: 12.8,
                    height: 1.35,
                    color: Colors.white.withOpacity(0.72),
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

class _SlideCard extends StatelessWidget {
  final OnboardingSlide slide;
  final Color glow;

  const _SlideCard({required this.slide, required this.glow});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0B1224).withOpacity(0.92),
              Color.lerp(const Color(0xFF0B1224), glow, 0.14)!.withOpacity(0.88),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: glow.withOpacity(0.22),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(slide.symbol, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    slide.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: glow.withOpacity(0.14),
                    border: Border.all(color: glow.withOpacity(0.35)),
                  ),
                  child: Text(
                    slide.powerUp,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w900,
                      color: glow.withOpacity(0.95),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              slide.description,
              style: TextStyle(
                fontSize: 13.2,
                height: 1.4,
                color: Colors.white.withOpacity(0.80),
              ),
            ),
            const Spacer(),
            Text(
              'Consejo: crea un hábito pequeño pero diario. El juego es la constancia.',
              style: TextStyle(
                fontSize: 12.0,
                height: 1.35,
                color: Colors.white.withOpacity(0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;
  final Color glow;

  const _Dots({
    required this.count,
    required this.index,
    required this.glow,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: active ? 18 : 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            color: active ? glow.withOpacity(0.85) : Colors.white.withOpacity(0.18),
          ),
        );
      }),
    );
  }
}