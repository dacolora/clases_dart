import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/life_area_catalog.dart';
import '../../models/life_area.dart';
import '../common/glow_card.dart';
import 'area_onboarding_screen.dart';

class AreaSelectionScreen extends StatefulWidget {
  const AreaSelectionScreen({super.key});

  @override
  State<AreaSelectionScreen> createState() => _AreaSelectionScreenState();
}

class _AreaSelectionScreenState extends State<AreaSelectionScreen> {
  LifeAreaId? selected;

  @override
  Widget build(BuildContext context) {
    final areas = LifeAreaCatalog.areas;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Nuevo hábito'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.builder(
                  itemCount: areas.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.92,
                  ),
                  itemBuilder: (context, index) {
                    final area = areas[index];
                    final isSelected = selected == area.id;

                    return _AreaCard(
                      area: area,
                      selected: isSelected,
                      onTap: () async {
                        HapticFeedback.selectionClick();
                        setState(() => selected = area.id);

                        // pequeña pausa para “sentir” la selección
                        await Future.delayed(const Duration(milliseconds: 140));

                        if (!mounted) return;
                        await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                AreaOnboardingScreen(area: area),
                            transitionsBuilder: (_, anim, __, child) {
                              final curve = CurvedAnimation(
                                parent: anim,
                                curve: Curves.easeOutCubic,
                              );
                              return FadeTransition(
                                opacity: curve,
                                child: SlideTransition(
                                  position: Tween(
                                    begin: const Offset(0, 0.06),
                                    end: Offset.zero,
                                  ).animate(curve),
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              _BottomHint(
                selectedTitle: selected == null
                    ? null
                    : areas.firstWhere((a) => a.id == selected!).title,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Qué parte de tu vida quieres subir de nivel?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Elige un área. Te mostraremos por qué importa…\n'
          'y en qué tipo de persona te conviertes al dominarla.',
          style: TextStyle(
            fontSize: 13.5,
            height: 1.35,
            color: Color(0xFFB9C4FF),
          ),
        ),
      ],
    );
  }
}

class _AreaCard extends StatefulWidget {
  final LifeArea area;
  final bool selected;
  final VoidCallback onTap;

  const _AreaCard({
    required this.area,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_AreaCard> createState() => _AreaCardState();
}

class _AreaCardState extends State<_AreaCard> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final glow = Color(widget.area.accentColor);

    return GestureDetector(
      onTapDown: (_) => setState(() => pressed = true),
      onTapCancel: () => setState(() => pressed = false),
      onTapUp: (_) => setState(() => pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        scale: pressed ? 1.03 : 1.0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: widget.selected ? 1.0 : 0.92,
          child: GlowCard(
            glowColor: glow,
            selected: widget.selected || pressed,
            child: _AreaCardContent(area: widget.area, glow: glow),
          ),
        ),
      ),
    );
  }
}

class _AreaCardContent extends StatelessWidget {
  final LifeArea area;
  final Color glow;

  const _AreaCardContent({required this.area, required this.glow});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // icon "holograma"
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                glow.withOpacity(0.45),
                glow.withOpacity(0.10),
                Colors.transparent,
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            area.iconGlyph,
            style: const TextStyle(fontSize: 28),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          area.title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          area.tagline,
          style: TextStyle(
            fontSize: 12.2,
            height: 1.2,
            color: Colors.white.withOpacity(0.72),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: glow.withOpacity(0.12),
                border: Border.all(color: glow.withOpacity(0.25)),
              ),
              child: Text(
                'Ver transformación',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: glow.withOpacity(0.95),
                ),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: glow.withOpacity(0.9),
            )
          ],
        )
      ],
    );
  }
}

class _BottomHint extends StatelessWidget {
  final String? selectedTitle;

  const _BottomHint({this.selectedTitle});

  @override
  Widget build(BuildContext context) {
    final text = selectedTitle == null
        ? 'Tip: Escoge un área para desbloquear su onboarding.'
        : 'Área seleccionada: $selectedTitle • Toca de nuevo para continuar.';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF0B1224),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.5,
          color: Colors.white.withOpacity(0.75),
        ),
      ),
    );
  }
}