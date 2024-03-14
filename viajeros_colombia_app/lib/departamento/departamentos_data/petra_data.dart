import 'package:travel_app_colombia/departamento/departamentos_data/wonder_data.dart';

import '../depatamento_model.dart';

class PetraData extends WonderData {
  PetraData()
      : super(
          type: WonderType.petra,
          title: petraTitle,
          subTitle: petraSubTitle,
          regionTitle: petraRegionTitle,
          artifactCulture: petraArtifactCulture,
          lat: 30.328830750209903,
          lng: 35.44398203484667,
          pullQuote2: petraPullQuote2,
          pullQuote2Author: petraPullQuote2Author,
          notaHistoria1: petraCallout1,
          notaHistoria2: petraCallout2,
          descripcion: petraHistoryInfo2,
          constructionInfo2: petraConstructionInfo2,
          locationInfo2: petraLocationInfo2,
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
            '325900',
            '325902',
            '325919',
            '325884',
            '325887',
            '325891',
          ],
          hiddenArtifacts: const [
            '322592',
            '325918',
            '326243',
          ],
        );
}

const petraTitle = "Petra";
const petraSubTitle = "The Lost City";
const petraRegionTitle = "Ma’an, Jordan";
const petraArtifactCulture = "Nabataean";
const petraArtifactGeolocation = "Levant";
const petraPullQuote1Top = "A Rose-Red City";
const petraPullQuote1Bottom = "Half as Old as Time";
const petraPullQuote1Author = "John William Burgon";
const petraPullQuote2 =
    "Petra is a brilliant display of man’s artistry in turning barren rock into a majestic wonder.";
const petraPullQuote2Author = "Edward Dawson";
const petraCallout1 =
    "They were particularly skillful in harvesting rainwater, agriculture and stone carving.";
const petraCallout2 =
    "Perhaps a more prominent resemblance to Hellenistic style in Petra comes with its Treasury.";
const petraVideoCaption =
    "“Stunning Stone Monuments of Petra | National Geographic.” Youtube, uploaded by National Geographic.";
const petraMapCaption =
    "Map showing location of Petra in Ma’an Governorate, Jordan.";
const petraHistoryInfo1 =
    "The area around Petra has been inhabited from as early as 7000  BCE, and the Nabataeans might have settled in what would become the capital city of their kingdom as early as the 4th century BCE.\nThe trading business gained the Nabataeans considerable revenue and Petra became the focus of their wealth. The Nabataeans were accustomed to living in the barren deserts, unlike their enemies, and were able to repel attacks by taking advantage of the area's mountainous terrain.";
const petraHistoryInfo2 =
    "Petra flourished in the 1st century CE, when its famous Al-Khazneh structure - believed to be the mausoleum of Nabataean king Aretas IV - was constructed, and its population peaked at an estimated 20,000 inhabitants.\nAccess to the city is through a 3/4 mile-long (1.2 km) gorge called the Siq, which leads directly to the Khazneh.";
const petraConstructionInfo1 =
    "Famous for its rock-cut architecture and water conduit system, Petra is also called the \"Red Rose City\" because of the color of the stone from which it is carved.\nAnother thing Petra is known for is its Hellenistic (“Greek”) architecture. These influences can be seen in many of the facades at Petra and are a reflection of the cultures that the Nabataens traded with.";
const petraConstructionInfo2 =
    "The facade of the Treasury features a broken pediment with a central tholos (“dome”) inside, and two obelisks appear to form into the rock of Petra at the top. Near the bottom of the Treasury we see twin Greek Gods: Pollux, Castor, and Dioscuri, who protect travelers on their journeys. \nNear the top of the Treasury, two victories are seen standing on each side of a female figure on the tholos. This female figure is believed to be the Isis-Tyche, Isis being the Egyptian Goddess and Tyche being the Greek Goddess of good fortune.";
const petraLocationInfo1 =
    "Petra is located in southern Jordan. It is adjacent to the mountain of Jabal Al-Madbah, in a basin surrounded by mountains forming the eastern flank of the Arabah valley running from the Dead Sea to the Gulf of Aqaba.";
const petraLocationInfo2 =
    "The area around Petra has been inhabited from as early as 7000 BC, and the Nabataeans might have settled in what would become the capital city of their kingdom as early as the 4th century BC.\nArchaeological work has only discovered evidence of Nabataean presence dating back to the second century BC, by which time Petra had become their capital. The Nabataeans were nomadic Arabs who invested in Petra's proximity to the incense trade routes by establishing it as a major regional trading hub.";
const petra1200bce =
    "First Edomites occupied the area and established a foothold.";
const petra106bce = "Became part of the Roman province Arabia";
const petra551ce =
    "After being damaged by earthquakes, habitation of the city all but ceased.";
const petra1812ce =
    "Rediscovered by the Swiss traveler Johann Ludwig Burckhardt.";
const petra1958ce =
    "Excavations led on the site by the British School of Archaeology and the American Center of Oriental Research.";
const petra1989ce = "Appeared in the film Indiana Jones and The Last Crusade.";
const petraCollectible1Title = "Camel and riders";
const petraCollectible1Icon = "statue";
const petraCollectible2Title = "Vessel";
const petraCollectible2Icon = "vase";
const petraCollectible3Title = "Open bowl";
const petraCollectible3Icon = "vase";
