import 'package:travel_app_colombia/departamento/departamentos_data/wonder_data.dart';

import '../depatamento_model.dart';

class MachuPicchuData extends WonderData {
  MachuPicchuData()
      : super(
          type: WonderType.machuPicchu,
          title: machuPicchuTitle,
          subTitle: machuPicchuSubTitle,
          regionTitle: machuPicchuRegionTitle,
          artifactCulture: machuPicchuArtifactCulture,
          lat: -13.162690683637758,
          lng: -72.54500778824891,
          pullQuote2: machuPicchuPullQuote2,
          pullQuote2Author: machuPicchuPullQuote2Author,
          notaHistoria1: machuPicchuCallout1,
          notaHistoria2: machuPicchuCallout2,
          descripcion: machuPicchuHistoryInfo2,
          constructionInfo2: machuPicchuConstructionInfo2,
          locationInfo2: machuPicchuLocationInfo2,
          informacionGeografica: InformacionGeograficaModel(
              alturaMaxima: 0,
              ecosistemas: [],
              poblacion: 0,
              capital: '',
              rios: [],
              superficie: 0),
          cultura:
              CulturaModel(gruposEtnicos: [], productos: [], tradiciones: []),
          highlightArtifacts: const [
            '313295',
            '316926',
            '309944',
            '309436',
            '309960',
            '316873',
          ],
          hiddenArtifacts: const [
            '308120',
            '309960',
            '313341',
          ],
        );
}

const machuPicchuTitle = "Machu Picchu";
const machuPicchuSubTitle = "Citadel of the Inca";
const machuPicchuRegionTitle = "Cusco Region, Peru";
const machuPicchuArtifactCulture = "Inca";
const machuPicchuArtifactGeolocation = "South America";
const machuPicchuPullQuote1Top = "Few Romances Can Ever Surpass";
const machuPicchuPullQuote1Bottom = "That of the Granite Citadel";
const machuPicchuPullQuote1Author = "Hiram Bingham";
const machuPicchuPullQuote2 =
    "In the variety of its charms and the power of its spell, I know of no other place in the world which can compare with it.";
const machuPicchuPullQuote2Author = "Hiram Bingham";
const machuPicchuCallout1 =
    "During its use as a royal estate, it is estimated that about 750 people lived there, with most serving as support staff who lived there permanently.";
const machuPicchuCallout2 =
    "The Incas were masters of this technique, called ashlar, in which blocks of stone are cut to fit together tightly without mortar.";
const machuPicchuVideoCaption =
    "“Machu Picchu 101 | National Geographic.” Youtube, uploaded by National Geographic.";
const machuPicchuMapCaption =
    "Map showing location of Machu Picchu in the Eastern Cordillera of southern Peru.";
const machuPicchuHistoryInfo1 =
    "Machu Picchu is a 15th-century Inca citadel located in the Eastern Cordillera of southern Peru on a 2,430-meter (7,970 ft) mountain ridge. Construction appears to date from two great Inca rulers, Pachacutec Inca Yupanqui (1438–1471 CE) and Túpac Inca Yupanqui (1472–1493 CE).";
const machuPicchuHistoryInfo2 =
    "There is a consensus among archeologists that Pachacutec ordered the construction of the royal estate for his use as a retreat, most likely after a successful military campaign.\nRather it was used for 80 years before being abandoned, seemingly because of the Spanish conquests in other parts of the Inca Empire.";
const machuPicchuConstructionInfo1 =
    "The central buildings use the classical Inca architectural style of polished dry-stone walls of regular shape. \nInca walls have many stabilizing features: doors and windows are trapezoidal, narrowing from bottom to top; corners usually are rounded; inside corners often incline slightly into the rooms, and outside corners were often tied together by \"L\"-shaped blocks.";
const machuPicchuConstructionInfo2 =
    "This precision construction method made the structures at Machu Picchu resistant to seismic activity.\nThe site itself may have been intentionally built on fault lines to afford better drainage and a ready supply of fractured stone.";
const machuPicchuLocationInfo1 =
    "Machu Picchu is situated above a bow of the Urubamba River, which surrounds the site on three sides, where cliffs drop vertically for 1,480 feet (450 m) to the river at their base. The location of the city was a military secret, and its deep precipices and steep mountains provided natural defenses.";
const machuPicchuLocationInfo2 =
    "The Inca Bridge, an Inca grass rope bridge, across the Urubamba River in the Pongo de Mainique, provided a secret entrance for the Inca army. Another Inca bridge was built to the west of Machu Picchu, the tree-trunk bridge, at a location where a gap occurs in the cliff that measures 20 feet (6 m).";
const machuPicchu1438ce =
    "Speculated to be built and occupied by Inca ruler Pachacuti Inca Yupanqui.";
const machuPicchu1572ce =
    "The last Inca rulers used the site as a bastion to rebel against Spanish rule until they were ultimately wiped out.";
const machuPicchu1867ce =
    "Speculated to have been originally discovered by German explorer Augusto Berns, but his findings were never effectively publicized.";
const machuPicchu1911ce =
    "Introduced to the world by Hiram Bingham of Yale University, who was led there by locals after disclosing he was searching for Vilcabamba, the ’lost city of the Incas’.";
const machuPicchu1964ce =
    "Surrounding sites were excavated thoroughly by Gene Savoy, who found a much more suitable candidate for Vilcabamba in the ruin known as Espíritu Pampa.";
const machuPicchu1997ce =
    "Since its rediscovery, growing numbers of tourists have visited the Machu Picchu each year, with numbers exceeding 1.4 million in 2017.";
const machuPicchuCollectible1Title = "Eight-Pointed Star Tunic";
const machuPicchuCollectible1Icon = "textile";
const machuPicchuCollectible2Title = "Camelid figurine";
const machuPicchuCollectible2Icon = "statue";
const machuPicchuCollectible3Title = "Double Bowl";
const machuPicchuCollectible3Icon = "vase";
