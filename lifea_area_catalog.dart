import '../models/life_area.dart';

class LifeAreaCatalog {
  static const areas = <LifeArea>[
    LifeArea(
      id: LifeAreaId.mind,
      title: 'Mente',
      tagline: 'Claridad • Foco • Dominio',
      becomeTitle: 'Te conviertes en alguien imparable',
      becomeDescription:
          'Cuando tu mente está entrenada, tu vida deja de depender del ánimo. Tomas decisiones limpias, ejecutas con calma, y avanzas incluso en días difíciles.',
      accentColor: 0xFF4AA3FF,
      iconGlyph: '🧠',
      slides: [
        OnboardingSlide(
          title: 'Tu mente decide tu año',
          description:
              'Los hábitos de mente controlan tu atención. Sin atención, no hay disciplina. Sin disciplina, no hay progreso.',
          powerUp: '+FOCO',
          symbol: '🎯',
        ),
        OnboardingSlide(
          title: 'Menos ansiedad, más acción',
          description:
              'Entrenar mente reduce ruido mental. Empiezas a actuar más, pensar menos, y sostenerte con firmeza.',
          powerUp: '+CALMA',
          symbol: '🫧',
        ),
        OnboardingSlide(
          title: 'Identidad: el que cumple',
          description:
              'Cumplir hábitos mentales cambia tu identidad: eres el tipo de persona que se gobierna a sí misma.',
          powerUp: '+DOMINIO',
          symbol: '👑',
        ),
      ],
    ),
    LifeArea(
      id: LifeAreaId.health,
      title: 'Salud',
      tagline: 'Energía • Fuerza • Resistencia',
      becomeTitle: 'Te conviertes en tu mejor versión física',
      becomeDescription:
          'La salud te da poder real: energía diaria, presencia, autoestima y rendimiento. Es el multiplicador de todo.',
      accentColor: 0xFF48E6B6,
      iconGlyph: '💪',
      slides: [
        OnboardingSlide(
          title: 'Energía = Libertad',
          description:
              'Cuando tu cuerpo responde, tu vida se expande. No negocias con la pereza: te mueves.',
          powerUp: '+ENERGÍA',
          symbol: '⚡',
        ),
        OnboardingSlide(
          title: 'Tu físico es tu postura mental',
          description:
              'Entrenar no es por estética: es por carácter. Un cuerpo fuerte sostiene una mente fuerte.',
          powerUp: '+FUERZA',
          symbol: '🏋️',
        ),
        OnboardingSlide(
          title: 'Consistencia > Motivación',
          description:
              'Hábito de salud te enseña a cumplir sin ganas. Ese aprendizaje se transfiere a toda tu vida.',
          powerUp: '+DISCIPLINA',
          symbol: '🛡️',
        ),
      ],
    ),
    LifeArea(
      id: LifeAreaId.finance,
      title: 'Finanzas',
      tagline: 'Control • Abundancia • Paz',
      becomeTitle: 'Te conviertes en alguien con estabilidad y poder',
      becomeDescription:
          'Finanzas sanas = paz mental. Cuando dominas tus hábitos financieros, compras libertad: decisiones, tiempo y tranquilidad.',
      accentColor: 0xFFFFD166,
      iconGlyph: '💰',
      slides: [
        OnboardingSlide(
          title: 'Lo que no mides, te domina',
          description:
              'Registrar gastos, ahorrar y planear rompe el ciclo “gano y se va”. Empiezas a gobernar.',
          powerUp: '+CONTROL',
          symbol: '📊',
        ),
        OnboardingSlide(
          title: 'Abundancia con disciplina',
          description:
              'No es magia. Es consistencia: menos impulsos, mejores decisiones, resultados inevitables.',
          powerUp: '+ABUNDANCIA',
          symbol: '🏦',
        ),
        OnboardingSlide(
          title: 'Paz: tu nuevo estándar',
          description:
              'Cuando estás estable, tu mente se libera. Tu energía se va a crear, no a sobrevivir.',
          powerUp: '+PAZ',
          symbol: '🕊️',
        ),
      ],
    ),
    LifeArea(
      id: LifeAreaId.projects,
      title: 'Proyectos',
      tagline: 'Creación • Impacto • Progreso',
      becomeTitle: 'Te conviertes en constructor, no espectador',
      becomeDescription:
          'Un proyecto es una identidad. Hacerlo avanzar cada día te convierte en alguien que produce resultados, no excusas.',
      accentColor: 0xFFB388FF,
      iconGlyph: '🛠️',
      slides: [
        OnboardingSlide(
          title: 'La obra te transforma',
          description:
              'Crear algo real exige enfoque. En el proceso, te vuelves más firme, más claro, más capaz.',
          powerUp: '+PRODUCCIÓN',
          symbol: '🏗️',
        ),
        OnboardingSlide(
          title: 'Pequeño diario, grande anual',
          description:
              'Un hábito de 30-60 min diario acumula como loco. El progreso se vuelve visible.',
          powerUp: '+PROGRESO',
          symbol: '📈',
        ),
        OnboardingSlide(
          title: 'Eres el tipo que termina',
          description:
              'Terminar proyectos eleva autoestima y respeto propio. Empiezas a confiar en ti.',
          powerUp: '+CONFIANZA',
          symbol: '✅',
        ),
      ],
    ),
    LifeArea(
      id: LifeAreaId.spirituality,
      title: 'Espiritualidad',
      tagline: 'Presencia • Sentido • Intención',
      becomeTitle: 'Te conviertes en alguien centrado y presente',
      becomeDescription:
          'Sin centro interno, cualquier éxito se siente vacío. Esta área te da dirección, propósito y calma.',
      accentColor: 0xFF6EE7FF,
      iconGlyph: '🧘',
      slides: [
        OnboardingSlide(
          title: 'Presencia antes que prisa',
          description:
              'Meditación / reflexión reduce impulso y reactividad. Dejas de vivir en automático.',
          powerUp: '+PRESENCIA',
          symbol: '🌙',
        ),
        OnboardingSlide(
          title: 'Sentido: tu brújula',
          description:
              'Los hábitos de espíritu te conectan con lo que vale. Tus decisiones se vuelven coherentes.',
          powerUp: '+SENTIDO',
          symbol: '🧭',
        ),
        OnboardingSlide(
          title: 'Calma en medio del caos',
          description:
              'No se trata de evitar problemas, sino de atravesarlos con estabilidad interna.',
          powerUp: '+CALMA',
          symbol: '🌊',
        ),
      ],
    ),
    LifeArea(
      id: LifeAreaId.relationships,
      title: 'Relaciones',
      tagline: 'Conexión • Respeto • Amor',
      becomeTitle: 'Te conviertes en alguien que construye vínculos reales',
      becomeDescription:
          'Los hábitos relacionales (comunicación, límites, presencia) elevan tus vínculos. Te vuelves alguien confiable.',
      accentColor: 0xFFFF6B9E,
      iconGlyph: '❤️',
      slides: [
        OnboardingSlide(
          title: 'Conexión intencional',
          description:
              'No es “estar cerca”, es “estar presente”. La calidad de tu atención mejora tu relación.',
          powerUp: '+CONEXIÓN',
          symbol: '🤝',
        ),
        OnboardingSlide(
          title: 'Límites = respeto',
          description:
              'Los hábitos de límites evitan desgaste. Te respetas tú, y te respetan los demás.',
          powerUp: '+RESPETO',
          symbol: '🧱',
        ),
        OnboardingSlide(
          title: 'Amor estable, no ansioso',
          description:
              'Cuando tienes hábitos emocionales, tus relaciones dejan de ser una montaña rusa.',
          powerUp: '+ESTABILIDAD',
          symbol: '💎',
        ),
      ],
    ),
  ];
}