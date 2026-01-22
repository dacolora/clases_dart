import 'package:flutter/material.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _searchCtrl = TextEditingController();

  // Mock data (ajústalo a tu modelo real)
  final List<_HabitRecommendation> _items = const [
    _HabitRecommendation(
      icon: Icons.air, // "Respira"
      title: 'Respira',
      durationLabel: '3 m.',
      subtitle: 'Relájate y desestrésate',
    ),
    _HabitRecommendation(
      icon: Icons.water_drop,
      title: 'Beber Agua',
      durationLabel: '',
      subtitle: 'Si tienes sed, ya estás deshidratado',
    ),
    _HabitRecommendation(
      icon: Icons.layers,
      title: 'Limpiar y Ordenar',
      durationLabel: '10 m.',
      subtitle: 'Mantén tu ambiente limpio y ordenado para una mejor productividad',
    ),
    _HabitRecommendation(
      icon: Icons.restaurant,
      title: 'Comer Más Frutas y Verduras',
      durationLabel: '',
      subtitle: 'Práctico, divertido para comer, y bueno para tu salud.',
    ),
    _HabitRecommendation(
      icon: Icons.directions_run,
      title: 'Hacer Ejercicio',
      durationLabel: '',
      subtitle: 'Vuélvete más inteligente y ten más energía',
    ),
    _HabitRecommendation(
      icon: Icons.emoji_food_beverage,
      title: 'Tomar Té',
      durationLabel: '',
      subtitle: 'El té es la elección perfecta de bebida.',
    ),
    _HabitRecommendation(
      icon: Icons.laptop_mac,
      title: 'Aprender y Estudiar',
      durationLabel: '45 m.',
      subtitle: 'Tómate un tiempo para aprender algo nuevo cada día',
    ),
  ];

  int _addedCount = 0;
  Duration _addedTotal = Duration.zero;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items.where((h) {
      final q = _searchCtrl.text.trim().toLowerCase();
      if (q.isEmpty) return true;
      return h.title.toLowerCase().contains(q) || h.subtitle.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS grouped background
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _SearchBar(
              controller: _searchCtrl,
              hintText: 'Buscar o añadir nuevo hábito',
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            _SectionHeader(title: 'Hábitos Recomendados'),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 6),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE5E5EA),
                  indent: 64, // para que la línea no pase por el ícono
                ),
                itemBuilder: (context, index) {
                  final habit = filtered[index];
                  return _HabitRow(
                    habit: habit,
                    onAdd: () {
                      // Demo: aumenta contador y suma duración si existe.
                      setState(() {
                        _addedCount++;
                        final parsed = _parseMinutes(habit.durationLabel);
                        if (parsed != null) {
                          _addedTotal += Duration(minutes: parsed);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    const accent = Color(0xFFB00020); // rojo tipo iOS/Apple Music vibe
    final subtitle = '${_addedCount} hábitos • ${_formatDurationShort(_addedTotal)}';

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Añadir hábito',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.maybePop(context),
          child: const Text(
            'Hecho',
            style: TextStyle(
              color: accent,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  String _formatDurationShort(Duration d) {
    // En tu screenshot es “0s”. Mantengámoslo simple:
    if (d.inSeconds < 60) return '${d.inSeconds}s';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  int? _parseMinutes(String label) {
    // "3 m." o "10 m." -> 3, 10
    final t = label.trim().toLowerCase();
    if (!t.contains('m')) return null;
    final digits = RegExp(r'\d+').firstMatch(t)?.group(0);
    if (digits == null) return null;
    return int.tryParse(digits);
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E5EA)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(Icons.search, color: Color(0xFF8E8E93)),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (controller.text.isNotEmpty) ...[
              GestureDetector(
                onTap: () {
                  controller.clear();
                  onChanged('');
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.cancel, color: Color(0xFF8E8E93), size: 18),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF8E8E93),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HabitRow extends StatelessWidget {
  const _HabitRow({
    required this.habit,
    required this.onAdd,
  });

  final _HabitRecommendation habit;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFB00020);

    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 36,
              child: Icon(habit.icon, color: const Color(0xFFB0B0B5), size: 26),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          habit.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (habit.durationLabel.trim().isNotEmpty) ...[
                        const SizedBox(width: 10),
                        Text(
                          habit.durationLabel,
                          style: const TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    habit.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 13.5,
                      height: 1.2,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _AddButton(
              onPressed: onAdd,
              color: accent,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.onPressed,
    required this.color,
  });

  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Añadir'),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }
}

class _HabitRecommendation {
  final IconData icon;
  final String title;
  final String durationLabel;
  final String subtitle;

  const _HabitRecommendation({
    required this.icon,
    required this.title,
    required this.durationLabel,
    required this.subtitle,
  });
}