import 'package:flutter/material.dart';
import '../../models/life_area.dart';

class CreateHabitScreen extends StatelessWidget {
  final LifeArea area;

  const CreateHabitScreen({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    final glow = Color(area.accentColor);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text('Crear hábito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFF0B1224),
            border: Border.all(color: glow.withOpacity(0.25)),
            boxShadow: [
              BoxShadow(
                color: glow.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${area.iconGlyph}  Área seleccionada: ${area.title}',
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Aquí conectas tu formulario real de creación de hábito.\n'
                'Pero lo importante es que ya llegaste con intención.',
                style: TextStyle(
                  fontSize: 13.2,
                  height: 1.35,
                  color: Colors.white.withOpacity(0.72),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: glow.withOpacity(0.20),
                  foregroundColor: glow.withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: glow.withOpacity(0.45)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Listo',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}