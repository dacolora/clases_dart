import 'package:flutter/material.dart';
import 'package:travel_app_colombia/departamento/departamentos_data/wonder_data.dart';

import '../depatamento_model.dart';

class TajMahalData extends WonderData {
  TajMahalData()
      : super(
          type: WonderType.tajMahal,
          title: tajMahalTitle,
          subTitle: tajMahalSubTitle,
          regionTitle: tajMahalRegionTitle,
          artifactCulture: tajMahalArtifactCulture,
          lat: 27.17405039840427,
          lng: 78.04211890065208,
          pullQuote2: tajMahalPullQuote2,
          pullQuote2Author: tajMahalPullQuote2Author,
          notaHistoria1: tajMahalCallout1,
          notaHistoria2: tajMahalCallout2,
          descripcion: tajMahalHistoryInfo2,
          constructionInfo2: tajMahalConstructionInfo2,
          locationInfo2: tajMahalLocationInfo2,
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
            '453341',
            '453243',
            '73309',
            '24932',
            '56230',
            '35633',
          ],
          hiddenArtifacts: const [
            '24907',
            '453183',
            '453983',
          ],
        );
}

const tajMahalTitle = "Taj Mahal";
const tajMahalSubTitle = "Heaven on Earth";
const tajMahalRegionTitle = "Agra, India";
const tajMahalArtifactCulture = "Mughal";
const tajMahalArtifactGeolocation = "India";
const tajMahalPullQuote1Top = "Not just a Monument,";
const tajMahalPullQuote1Bottom = "but a Symbol of Love.";
const tajMahalPullQuote1Author = "Suman Pokhrel";
const tajMahalPullQuote2 =
    "The Taj Mahal rises above the banks of the river like a solitary tear suspended on the cheek of time.";
const tajMahalPullQuote2Author = "Rabindranath Tagore";
const tajMahalCallout1 =
    "The Taj Mahal is distinguished as the finest example of Mughal architecture, a blend of Indian, Persian, and Islamic styles.";
const tajMahalCallout2 =
    "It took the efforts of 22,000 laborers, painters, embroidery artists and stonecutters to shape the Taj Mahal.";
const tajMahalVideoCaption =
    "“India’s Taj Mahal Is an Enduring Monument to Love | National Geographic.” Youtube, uploaded by National Geographic.";
const tajMahalMapCaption =
    "Map showing location of Taj Mahal in Uttar Pradesh, India.";
const tajMahalHistoryInfo1 =
    "The Taj Mahal is an ivory-white marble mausoleum on the right bank of the river Yamuna in the Indian city of Agra. It was commissioned in 1632 CE by the Mughal emperor Shah Jahan (r. 1628-1658) to house the tomb of his favorite wife, Mumtaz Mahal; it also houses the tomb of Shah Jahan himself.";
const tajMahalHistoryInfo2 =
    "The tomb is the centerpiece of a 42-acre (17-hectare) complex, which include twin mosque buildings (placed symmetrically on either side of the mausoleum), a guest house, and is set in formal gardens bounded on three sides by walls.";
const tajMahalConstructionInfo1 =
    "The Taj Mahal was constructed using materials from all over India and Asia. It is believed over 1,000 elephants were used to transport building materials.\nThe translucent white marble was brought from Rajasthan, the jasper from Punjab, jade and crystal from China. The turquoise was from Tibet and the lapis from Afghanistan, while the sapphire came from Sri Lanka. In all, twenty-eight types of precious and semi-precious stones were inlaid into the white marble.";
const tajMahalConstructionInfo2 =
    "An area of roughly 3 acres was excavated, filled with dirt to reduce seepage, and leveled at 160 ft above riverbank. In the tomb area, wells were dug and filled with stone and rubble to form the footings of the tomb.\nThe plinth and tomb took roughly 12 years to complete. The remaining parts of the complex took an additional 10 years.";
const tajMahalLocationInfo1 =
    "India's most famed building, it is situated in the eastern part of the city on the southern bank of the Yamuna River, nearly 1 mile east of the Agra Fort, also on the right bank of the Yamuna.";
const tajMahalLocationInfo2 =
    "The Taj Mahal is built on a parcel of land to the south of the walled city of Agra. Shah Jahan presented Maharaja Jai Singh with a large palace in the center of Agra in exchange for the land.";
const tajMahal1631ce =
    "Built by Mughal Emperor Shah Jahān to immortalize his deceased wife.";
const tajMahal1647ce =
    "Construction completed. The project involved over 20,000 workers and spanned 42 acres.";
const tajMahal1658ce =
    "There were plans for a second mausoleum for his own remains, but Shah Jahān was imprisoned by his son for the rest of his life in Agra Fort, and this never came to pass.";
const tajMahal1901ce =
    "Lord Curzon and the British Viceroy of India carried out a major restoration to the monument after over 350 years of decay and corrosion due to factory pollution and exhaust.";
const tajMahal1984ce =
    "To protect the structure from Sikh militants and some Hindu nationalist groups, night viewing was banned to tourists. This ban would last 20 years.";
const tajMahal1998ce =
    "Restoration and research program put into action to help preserve the monument.";
const tajMahalCollectible1Title = "Dagger with Scabbard";
const tajMahalCollectible1Icon = "jewelry";
const tajMahalCollectible2Title = "The House of Bijapur";
const tajMahalCollectible2Icon = "picture";
const tajMahalCollectible3Title = "Panel of Nasta'liq Calligraphy";
const tajMahalCollectible3Icon = "scroll";
