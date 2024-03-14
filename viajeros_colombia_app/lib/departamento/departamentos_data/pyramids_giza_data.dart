import 'package:travel_app_colombia/departamento/departamentos_data/wonder_data.dart';

import '../depatamento_model.dart';

class PyramidsGizaData extends WonderData {
  PyramidsGizaData()
      : super(
          //  searchData: _searchData, // included as a part from ./search/
          //    searchSuggestions:
          //       _searchSuggestions, // included as a part from ./search/
          type: WonderType.pyramidsGiza,
          title: pyramidsGizaTitle,
          subTitle: pyramidsGizaSubTitle,
          regionTitle: pyramidsGizaRegionTitle,
          artifactCulture: pyramidsGizaArtifactCulture,
          lat: 29.9792,
          lng: 31.1342,

          pullQuote2: pyramidsGizaPullQuote2,
          pullQuote2Author: pyramidsGizaPullQuote2Author,
          notaHistoria1: pyramidsGizaCallout1,
          notaHistoria2: pyramidsGizaCallout2,

          descripcion: pyramidsGizaHistoryInfo2,
          constructionInfo2: pyramidsGizaConstructionInfo2,
          locationInfo2: pyramidsGizaLocationInfo2,
          informacionGeografica: InformacionGeograficaModel(
              alturaMaxima: 0,
              ecosistemas: [],
              capital: '',
              poblacion: 0,
              rios: [],
              superficie: 0),
          cultura:
              CulturaModel(gruposEtnicos: [], productos: [], tradiciones: []),
          highlightArtifacts: const [
            '543864',
            '546488',
            '557137',
            '543900',
            '543935',
            '544782',
          ],
          hiddenArtifacts: const [
            '546510',
            '543896',
            '545728',
          ],
        );
}

const pyramidsGizaTitle = "Pyramids of Giza";
const pyramidsGizaSubTitle = "The ancient wonder";
const pyramidsGizaRegionTitle = "Cairo, Egypt";
const pyramidsGizaArtifactCulture = "Egyptian";
const pyramidsGizaArtifactGeolocation = "Egypt";
const pyramidsGizaPullQuote1Top = "The Tallest Structures on Earth";
const pyramidsGizaPullQuote1Bottom = "Until the Advent of Modern Skyscrapers";
const pyramidsGizaPullQuote2 =
    "From the heights of these pyramids, forty centuries look down on us.";
const pyramidsGizaPullQuote2Author = "Napoleon Bonaparte";
const pyramidsGizaCallout1 =
    "It is theorized the pyramid not only served as a tomb for the pharaoh, but also as a storage pit for various items he would need in the afterlife.";
const pyramidsGizaCallout2 =
    "The Great Pyramid consists of an estimated 2.3 million blocks. Approximately 5.5 million tonnes of limestone, 8,000 tonnes of granite, and 500,000 tonnes of mortar were used in the construction.";
const pyramidsGizaVideoCaption =
    "“The Great Pyramids of Giza | Egypt’s Ancient Mysteries | National Geographic UK.” Youtube, uploaded by National Geographic UK.";
const pyramidsGizaMapCaption =
    "Map showing location of Giza Pyramids in Greater Cairo, Egypt.";
const pyramidsGizaHistoryInfo1 =
    "The Giza pyramid complex, also called the Giza necropolis, is the site on the Giza Plateau in Greater Cairo, Egypt that includes the Great Pyramid of Giza, the Pyramid of Khafre, and the Pyramid of Menkaure, along with their associated pyramid complexes and the Great Sphinx of Giza. All were built during the Fourth Dynasty of the Old Kingdom of Ancient Egypt, between 2600 and 2500 BCE.";
const pyramidsGizaHistoryInfo2 =
    "The pyramids of Giza and others are thought to have been constructed to house the remains of the deceased pharaohs who ruled over Ancient Egypt. A portion of the pharaoh's spirit called his ka was believed to remain with his corpse. Proper care of the remains was necessary in order for the former Pharaoh to perform his new duties as king of the dead.";
const pyramidsGizaConstructionInfo1 =
    "Most construction theories are based on the idea that the pyramids were built by moving huge stones from a quarry and dragging and lifting them into place. In building the pyramids, the architects might have developed their techniques over time.\nThey would select a site on a relatively flat area of bedrock — not sand — which provided a stable foundation. After carefully surveying the site and laying down the first level of stones, they constructed the pyramids in horizontal levels, one on top of the other.";
const pyramidsGizaConstructionInfo2 =
    "For the Great Pyramid, most of the stone for the interior seems to have been quarried immediately to the south of the construction site. The smooth exterior of the pyramid was made of a fine grade of white limestone that was quarried across the Nile.\nTo ensure that the pyramid remained symmetrical, the exterior casing stones all had to be equal in height and width. Workers might have marked all the blocks to indicate the angle of the pyramid wall and trimmed the surfaces carefully so that the blocks fit together. During construction, the outer surface of the stone was smooth limestone; excess stone has eroded as time has passed.";
const pyramidsGizaLocationInfo1 =
    "The site is at the edges of the Western Desert, approximately 5.6 miles (9 km) west of the Nile River in the city of Giza, and about 8 miles (13 km) southwest of the city center of Cairo.";
const pyramidsGizaLocationInfo2 =
    "Currently, the pyramids are located in the northwestern side of the Western Desert, and it is considered to be one of the best recognizable and the most visited tourist attractions of the planet.";
const pyramidsGiza2575bce =
    "Construction of the 3 pyramids began for three kings of the 4th dynasty; Khufu, Khafre, and Menkaure.";
const pyramidsGiza2465bce =
    "Construction began on the smaller surrounding structures called Mastabas for royalty of the 5th and 6th dynasties.";
const pyramidsGiza443bce =
    "Greek Author Herodotus speculated that the pyramids were built in the span of 20 years with over 100,000 slave labourers. This assumption would last for over 1500 years";
const pyramidsGiza1925ce =
    "Tomb of Queen Hetepheres was discovered, containing furniture and jewelry. One of the last remaining treasure-filled tombs after many years of looting and plundering.";
const pyramidsGiza1979ce =
    "Designated a UNESCO World Heritage Site to prevent any more unauthorized plundering and vandalism.";
const pyramidsGiza1990ce =
    "Discovery of labouror’s districts suggest that the workers building the pyramids were not slaves, and an ingenious building method proved a relatively small work-force was required to build such immense structures.";
const pyramidsGizaCollectible1Title = "Two papyrus fragments";
const pyramidsGizaCollectible1Icon = "scroll";
const pyramidsGizaCollectible2Title = "Fragmentary Face of King Khafre";
const pyramidsGizaCollectible2Icon = "statue";
const pyramidsGizaCollectible3Title = "Jewelry Elements";
const pyramidsGizaCollectible3Icon = "jewelry";
