import '../../atraccion/atraccion_model.dart';
import '../depatamento_model.dart';

class WonderData {
  const WonderData({
    required this.type,
    required this.title,
    required this.subTitle,
    required this.regionTitle,
    required this.informacionGeografica,
    required this.cultura,
    this.artifactCulture = '',
    this.lat = 0,
    this.lng = 0,
    this.imageIds = const [],
    this.pullQuote2 = '',
    this.pullQuote2Author = '',
    this.notaHistoria1 = '',
    this.notaHistoria2 = '',
    this.facts = const [],
    required this.descripcion,
    required this.constructionInfo2,
    required this.locationInfo2,
    this.lugares,
    this.highlightArtifacts = const [],
    this.hiddenArtifacts = const [],
    this.searchSuggestions = const [],
  });

  final WonderType type;
  final String title;
  final String subTitle;
  final String regionTitle;
  final List<AtraccionModel>? lugares;
  final String descripcion;
  final String constructionInfo2;
  final String locationInfo2;

  final String pullQuote2;
  final String pullQuote2Author;
  final String notaHistoria1;
  final String notaHistoria2;

  final List<String> imageIds;
  final List<String> facts;
  final String artifactCulture;

  final InformacionGeograficaModel informacionGeografica;
  final CulturaModel cultura;

  final double lat;
  final double lng;
  final List<String>
      highlightArtifacts; // IDs used to assemble HighlightsData, should not be used directly
  final List<String>
      hiddenArtifacts; // IDs used to assemble CollectibleData, should not be used directly
  final List<String> searchSuggestions;

  String get titleWithBreaks => title.replaceFirst(' ', '\n');

  @override
  List<Object?> get props => [type, title, '', imageIds, facts];
}

enum WonderType {
  chichenItza,
  christRedeemer,
  colosseum,
  greatWall,
  machuPicchu,
  petra,
  pyramidsGiza,
  tajMahal,
}
