enum LifeAreaId {
  mind,
  health,
  finance,
  projects,
  spirituality,
  relationships,
}

class LifeArea {
  final LifeAreaId id;
  final String title;
  final String tagline; // micro-frase para la card
  final String becomeTitle; // "Te conviertes en..."
  final String becomeDescription; // narrativa poderosa
  final List<OnboardingSlide> slides;
  final int accentColor; // ARGB int
  final String iconGlyph; // emoji / fallback

  const LifeArea({
    required this.id,
    required this.title,
    required this.tagline,
    required this.becomeTitle,
    required this.becomeDescription,
    required this.slides,
    required this.accentColor,
    required this.iconGlyph,
  });
}

class OnboardingSlide {
  final String title;
  final String description;
  final String powerUp; // “+Focus”, “+Disciplina”, etc.
  final String symbol; // emoji / glyph

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.powerUp,
    required this.symbol,
  });
}