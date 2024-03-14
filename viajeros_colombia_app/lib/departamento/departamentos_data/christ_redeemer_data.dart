import 'package:travel_app_colombia/departamento/departamentos_data/wonder_data.dart';

import '../depatamento_model.dart';
import '../../wonder/show_wonder/data/wonder_type.dart';

class ChristRedeemerData extends WonderData {
  ChristRedeemerData()
      : super(
          //     searchData: _searchData, // included as a part from ./search/

          type: WonderType.christRedeemer,
          title: christRedeemerTitle,
          subTitle: christRedeemerSubTitle,
          regionTitle: christRedeemerRegionTitle,

          artifactCulture: '',
          lat: -22.95238891944396,
          lng: -43.21045520611561,

          pullQuote2: christRedeemerPullQuote2,
          pullQuote2Author: christRedeemerPullQuote2Author,
          notaHistoria1: christRedeemerCallout1,
          notaHistoria2: christRedeemerCallout2,
          descripcion: christRedeemerHistoryInfo2,
          constructionInfo2: christRedeemerConstructionInfo2,
          locationInfo2: christRedeemerLocationInfo2,
          informacionGeografica: InformacionGeograficaModel(
              alturaMaxima: 0,
              ecosistemas: [],
              poblacion: 0,
              rios: [],
              capital: '',
              superficie: 0),
          cultura:
              CulturaModel(gruposEtnicos: [], productos: [], tradiciones: []),
          highlightArtifacts: const [
            '501319',
            '764815',
            '502019',
            '764814',
            '764816',
          ],
          hiddenArtifacts: const [
            '501302',
            '157985',
            '227759',
          ],
        );
}

const christRedeemerTitle = "Christ the Redeemer";
const christRedeemerSubTitle = "A symbol of peace";
const christRedeemerRegionTitle = "Rio de Janeiro, Brazil";
const christRedeemerArtifactGeolocation = "Brazil";
const christRedeemerPullQuote1Top = "A Perfect Union Between";
const christRedeemerPullQuote1Bottom = "Nature and Architecture";
const christRedeemerPullQuote2 =
    "The statue looms large on the landscape, but it hides as much as it reveals about the diverse religious life of Brazilians.";
const christRedeemerPullQuote2Author = "Thomas Tweed";
const christRedeemerCallout1 =
    "The statue of Christ the Redeemer with open arms, a symbol of peace, was chosen.";
const christRedeemerCallout2 =
    "Construction took nine years, from 1922 to 1931, and cost the equivalent of US 250,000 (equivalent to  3,600,000 in 2020) and the monument opened on October 12, 1931.";
const christRedeemerVideoCaption =
    "“The Majestic Statue of Christ the Redeemer - Seven Wonders of the Modern World - See U in History.” Youtube, uploaded by See U in History / Mythology.";
const christRedeemerMapCaption =
    "Map showing location of Christ the Redeemer in Rio de Janeiro, Brazil.";
const christRedeemerHistoryInfo1 =
    "The placement of a Christian monument on Mount Corcovado was first suggested in the mid-1850s to honor Princess Isabel, regent of Brazil and the daughter of Emperor Pedro II, but the project was not approved.\nIn 1889 the country became a republic, and owing to the separation of church and state the proposed statue was dismissed.";
const christRedeemerHistoryInfo2 =
    "The Catholic Circle of Rio made a second proposal for a landmark statue on the mountain in 1920. The group organized an event called Semana do Monumento (\"Monument Week\") to attract donations and collect signatures to support the building of the statue. The organization was motivated by what they perceived as \"Godlessness\" in the society.\nThe designs considered for the \"Statue of the Christ\" included a representation of the Christian cross, a statue of Jesus with a globe in his hands, and a pedestal symbolizing the world.";
const christRedeemerConstructionInfo1 =
    "Artist Carlos Oswald and local engineer Heitor da Silva Costa designed the statue. French sculptor Paul Landowski created the work. In 1922, Landowski commissioned fellow Parisian Romanian sculptor Gheorghe Leonida, who studied sculpture at the Fine Arts Conservatory in Bucharest and in Italy.";
const christRedeemerConstructionInfo2 =
    "A group of engineers and technicians studied Landowski's submissions and felt building the structure of reinforced concrete instead of steel was more suitable for the cross-shaped statue. The concrete making up the base was supplied from Limhamn, Sweden. The outer layers are soapstone, chosen for its enduring qualities and ease of use.";
const christRedeemerLocationInfo1 =
    "Corcovado, which means \"hunchback\" in Portuguese, is a mountain in central Rio de Janeiro, Brazil. It is a 2,329 foot (710 m) granite peak located in the Tijuca Forest, a national park.";
const christRedeemerLocationInfo2 =
    "Corcovado hill lies just west of the city center but is wholly within the city limits and visible from great distances.";
const christRedeemer1850ce =
    "Plans for the statue were first proposed by Pedro Maria Boss upon Mount Corcovado. This was never approved, however.";
const christRedeemer1921ce =
    "A new plan was proposed by the Roman Catholic archdiocese, and after the citizens of Rio de Janeiro petitioned the president, it was finally approved.";
const christRedeemer1922ce =
    "The foundation of the statue was ceremoniously laid out to commemorate Brazil’s independence from Portugal.";
const christRedeemer1926ce =
    "Construction officially began after the initial design was chosen via a competition and amended by Brazilian artists and engineers.";
const christRedeemer1931ce =
    "Construction of the statue was completed, standing 98’ tall with a 92’ wide arm span.";
const christRedeemer2006ce =
    "A chapel was consecrated at the statue’s base to Our Lady of Aparecida to mark the statue’s 75th anniversary.";
const christRedeemerCollectible1Title = "Engraved Horn";
const christRedeemerCollectible1Icon = "statue";
const christRedeemerCollectible2Title = "Fixed fan";
const christRedeemerCollectible2Icon = "jewelry";
const christRedeemerCollectible3Title = "Handkerchiefs (one of two)";
const christRedeemerCollectible3Icon = "textile";
