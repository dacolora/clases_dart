import 'package:travel_app_colombia/departamento/departamentos_data/wonder_data.dart';

import '../depatamento_model.dart';
import '../../wonder/show_wonder/data/wonder_type.dart';

class ChichenItzaData extends WonderData {
  ChichenItzaData()
      : super(
          type: WonderType.chichenItza,
          title: chichenItzaTitle,
          subTitle: chichenItzaSubTitle,
          regionTitle: chichenItzaRegionTitle,
          artifactCulture: chichenItzaArtifactCulture,
          lat: 20.68346184201756,
          lng: -88.56769676930931,
          pullQuote2: chichenItzaPullQuote2,
          pullQuote2Author: chichenItzaPullQuote2Author,
          notaHistoria1: chichenItzaCallout1,
          notaHistoria2: chichenItzaCallout2,
          descripcion: chichenItzaHistoryInfo2,
          constructionInfo2: chichenItzaConstructionInfo2,
          locationInfo2: chichenItzaLocationInfo2,
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
            '503940',
            '312595',
            '310551',
            '316304',
            '313151',
            '313256',
          ],
          hiddenArtifacts: const [
            '701645',
            '310555',
            '286467',
          ],
        );
}

const chichenItzaTitle = "Chichen Itza";
const chichenItzaSubTitle = "The Great Mayan City";
const chichenItzaRegionTitle = "Yucatan, Mexico";
const chichenItzaArtifactCulture = "Maya";
const chichenItzaArtifactGeolocation = "North and Central America";
const chichenItzaPullQuote1Top = "The Beauty Between";
const chichenItzaPullQuote1Bottom = "the Heavens and the Underworld";
const chichenItzaPullQuote2 =
    "The Maya and Toltec vision of the world and the universe is revealed in their stone monuments and artistic works.";
const chichenItzaPullQuote2Author = "UNESCO";
const chichenItzaCallout1 =
    "The site exhibits a multitude of architectural styles, reminiscent of styles seen in central Mexico and of the Puuc and Chenes styles of the Northern Maya lowlands.";
const chichenItzaCallout2 =
    "The city comprised an area of at least 1.9 sq miles (5 sq km) of densely clustered architecture.";
const chichenItzaVideoCaption =
    "“Ancient Maya 101 | National Geographic.” Youtube, uploaded by National Geographic.";
const chichenItzaMapCaption =
    "Map showing location of Chichen Itza in Yucatán State, Mexico.";
const chichenItzaHistoryInfo1 =
    "Chichen Itza was a powerful regional capital controlling north and central Yucatán. The earliest hieroglyphic date discovered at Chichen Itza is equivalent to 832 CE, while the last known date was recorded in the Osario temple in 998 CE.\nDominating the North Platform of Chichen Itza is the famous Temple of Kukulcán. The temple was identified by the first Spaniards to see it, as El Castillo (\"the castle\"), and it regularly is referred to as such.";
const chichenItzaHistoryInfo2 =
    "The city was thought to have the most diverse population in the Maya world, a factor that could have contributed to this architectural variety.";
const chichenItzaConstructionInfo1 =
    "The structures of Chichen Itza were built from precisely chiseled limestone blocks that fit together perfectly without the mortar. Many of these stone buildings were originally painted in red, green, blue and purple colors depending on the availability of the pigments.\nThe stepped pyramid El Castillo stands about 98 feet (30 m) high and consists of a series of nine square terraces, each approximately 8.4 feet (2.57 m) high, with a 20 foot (6 m) high temple upon the summit.";
const chichenItzaConstructionInfo2 =
    "It was built upon broken terrain, which was artificially leveled to support structures such as the Castillo pyramid. Important buildings within the center were connected by a dense network of paved roads called sacbeob.";
const chichenItzaLocationInfo1 =
    "Chichen Itza is located in the eastern portion of Yucatán state in Mexico. Nearby, four large sinkholes, called cenotes, could have provided plentiful water year round at Chichen, making it attractive for settlement.";
const chichenItzaLocationInfo2 =
    "Of these cenotes, the \"Cenote Sagrado\" or Sacred Cenote, was used for the sacrifice of precious objects and human beings as a form of worship to the Maya rain god Chaac.";
const chichenItza600ce =
    "Chichen Itza rises to regional prominence toward the end of the Early Classic period";
const chichenItza832ce =
    "The earliest hieroglyphic date discovered at Chichen Itza";
const chichenItza998ce = "Last known date recorded in the Osario temple";
const chichenItza1100ce = "Chichen Itza declines as a regional center";
const chichenItza1527ce =
    "Invaded by Spanish Conquistador Francisco de Montejo";
const chichenItza1535ce = "All Spanish are driven from the Yucatán Peninsula";
const chichenItzaCollectible1Title = "Pendant";
const chichenItzaCollectible1Icon = "jewelry";
const chichenItzaCollectible2Title = "Bird Ornament";
const chichenItzaCollectible2Icon = "jewelry";
const chichenItzaCollectible3Title = "La Prison, à Chichen-Itza";
const chichenItzaCollectible3Icon = "picture";
