#' @importFrom shiny NS tagList
#' @import httr
#' @import png

library(shinyjs)

Wiki <- function(id) {
  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia"),
    fluidRow(
      column(2, imageOutput("imageDisplay1", click = "image_click1")),
      column(2, imageOutput("imageDisplay2", click = "image_click2")),
      column(2, imageOutput("imageDisplay3", click = "image_click3"))

    ),
    useShinyjs()
  )
}

wiki_server <- function(id, data) {
  moduleServer( id, function(input, output, session){

    image_data <- data.frame(
      image_path = c(
        "BirdNETmonitor/BirdWatcherImages/1_Amandava_amandava_Red_Avadavat.png",
        "BirdNETmonitor/BirdWatcherImages/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
        "BirdNETmonitor/BirdWatcherImages/3_Green-winged_Teal,_Port_Aransas,_Texas.png",
        "BirdNETmonitor/BirdWatcherImages/Anas platyrhynchos_Mallard.png",
        "BirdNETmonitor/BirdWatcherImages/Anous minutus_Black Noddy.png",
        "BirdNETmonitor/BirdWatcherImages/Anous stolidus_Brown Noddy.png",
        "BirdNETmonitor/BirdWatcherImages/Anser albifrons_Greater White-fronted Goose.png",
        "BirdNETmonitor/BirdWatcherImages/Anser caerulescens_Snow Goose.png",
        "BirdNETmonitor/BirdWatcherImages/Ardea herodias_Great Blue Heron.png",#9
        "BirdNETmonitor/BirdWatcherImages/Ardenna grisea_Sooty Shearwater",
        "BirdNETmonitor/BirdWatcherImages/Ardenna pacifica_Wedge-tailed Shearwater",
        "BirdNETmonitor/BirdWatcherImages/Ardenna tenuirostris_Short-tailed Shearwater",
        "BirdNETmonitor/BirdWatcherImages/Arenaria interpres_Ruddy Turnstone",
        "BirdNETmonitor/BirdWatcherImages/Asio flammeus_Short-eared Owl",
        "BirdNETmonitor/BirdWatcherImages/Aythya affinis_Lesser Scaup",
        "BirdNETmonitor/BirdWatcherImages/Aythya collaris_Ring-necked Duck",
        "BirdNETmonitor/BirdWatcherImages/Aythya marila_Greater Scaup",
        "BirdNETmonitor/BirdWatcherImages/Aythya valisineria_Canvasback",
        "BirdNETmonitor/BirdWatcherImages/Branta bernicla_Brant",
        "BirdNETmonitor/BirdWatcherImages/Branta canadensis_Canada Goose",
        "BirdNETmonitor/BirdWatcherImages/Branta hutchinsii_Cackling Goose",
        "BirdNETmonitor/BirdWatcherImages/Branta sandvicensis_Hawaiian Goose",
        "BirdNETmonitor/BirdWatcherImages/Bubulcus ibis_Cattle Egret",
        "BirdNETmonitor/BirdWatcherImages/Bucephala albeola_Bufflehead",
        "BirdNETmonitor/BirdWatcherImages/Bulweria bulwerii_Bulwer's Petrel",
        "BirdNETmonitor/BirdWatcherImages/Buteo solitarius_Hawaiian Hawk",
        "BirdNETmonitor/BirdWatcherImages/Calidris acuminata_Sharp-tailed Sandpiper",
        "BirdNETmonitor/BirdWatcherImages/Calidris alba_Sanderling",
        "BirdNETmonitor/BirdWatcherImages/Calidris alpina_Dunlin",
        "BirdNETmonitor/BirdWatcherImages/Calidris mauri_Western Sandpiper",
        "BirdNETmonitor/BirdWatcherImages/Calidris melanotos_Pectoral Sandpiper",
        "BirdNETmonitor/BirdWatcherImages/Calidris minutilla_Least Sandpiper",
        "BirdNETmonitor/BirdWatcherImages/Calidris pugnax_Ruff",
        "BirdNETmonitor/BirdWatcherImages/Calidris subruficollis_Buff-breasted Sandpiper",
        "BirdNETmonitor/BirdWatcherImages/Callipepla californica_California Quail",
        "BirdNETmonitor/BirdWatcherImages/Callipepla gambelii_Gambel's Quail",
        "BirdNETmonitor/BirdWatcherImages/Cardinalis cardinalis_Northern Cardinal",
        "BirdNETmonitor/BirdWatcherImages/Charadrius semipalmatus_Semipalmated Plover",
        "BirdNETmonitor/BirdWatcherImages/Chasiempis sandwichensis_Hawaii Elepaio",
        "BirdNETmonitor/BirdWatcherImages/Chlorodrepanis virens_Hawaii Amakihi",
        "BirdNETmonitor/BirdWatcherImages/Chroicocephalus philadelphia_Bonaparte's Gull",
        "BirdNETmonitor/BirdWatcherImages/Chrysolophus pictus_Golden Pheasant",
        "BirdNETmonitor/BirdWatcherImages/Circus hudsonius_Northern Harrier",
        "BirdNETmonitor/BirdWatcherImages/Columba livia_Rock Pigeon",
        "BirdNETmonitor/BirdWatcherImages/Corvus hawaiiensis_Hawaiian Crow",
        "BirdNETmonitor/BirdWatcherImages/Coturnix japonica_Japanese Quail",
        "BirdNETmonitor/BirdWatcherImages/Crithagra mozambica_Yellow-fronted Canary",
        "BirdNETmonitor/BirdWatcherImages/Cyanoliseus patagonus_Burrowing Parakeet",
        "BirdNETmonitor/BirdWatcherImages/Drepanis coccinea_Iiwi",
        "BirdNETmonitor/BirdWatcherImages/Estrilda astrild_Common Waxbill",
        "BirdNETmonitor/BirdWatcherImages/Euodice cantans_African Silverbill",
        "BirdNETmonitor/BirdWatcherImages/Falco columbarius_Merlin",
        "BirdNETmonitor/BirdWatcherImages/Falco peregrinus_Peregrine Falcon",
        "BirdNETmonitor/BirdWatcherImages/Francolinus francolinus_Black Francolin",
        "BirdNETmonitor/BirdWatcherImages/Fregata minor_Great Frigatebird",
        "BirdNETmonitor/BirdWatcherImages/Fulica alai_Hawaiian Coot",
        "BirdNETmonitor/BirdWatcherImages/Gallinula galeata_Common Gallinule",
        "BirdNETmonitor/BirdWatcherImages/Gallus gallus_Red Junglefowl",
        "BirdNETmonitor/BirdWatcherImages/Garrulax canorus_Chinese Hwamei",
        "BirdNETmonitor/BirdWatcherImages/Geopelia striata_Zebra Dove",
        "BirdNETmonitor/BirdWatcherImages/Glaucestrilda caerulescens_Lavender Waxbill",
        "BirdNETmonitor/BirdWatcherImages/Gygis alba_White Tern",
        "BirdNETmonitor/BirdWatcherImages/Haemorhous mexicanus_House Finch",
        "BirdNETmonitor/BirdWatcherImages/Hemignathus wilsoni_Akiapolaau",
        "BirdNETmonitor/BirdWatcherImages/Himantopus mexicanus_Black-necked Stilt",
        "BirdNETmonitor/BirdWatcherImages/Himatione sanguinea_Apapane",
        "BirdNETmonitor/BirdWatcherImages/Horornis diphone_Japanese Bush Warbler",
        "BirdNETmonitor/BirdWatcherImages/Hydrobates castro_Band-rumped Storm-Petrel",
        "BirdNETmonitor/BirdWatcherImages/Hydrobates leucorhous_Leach's Storm-Petrel",
        "BirdNETmonitor/BirdWatcherImages/Hydroprogne caspia_Caspian Tern",
        "BirdNETmonitor/BirdWatcherImages/Larosterna inca_Inca Tern",
        "BirdNETmonitor/BirdWatcherImages/Larus delawarensis_Ring-billed Gull",
        "BirdNETmonitor/BirdWatcherImages/Larus glaucescens_Glaucous-winged Gull",
        "BirdNETmonitor/BirdWatcherImages/Leiothrix lutea_Red-billed Leiothrix",
        "BirdNETmonitor/BirdWatcherImages/Leucophaeus atricilla_Laughing Gull",
        "BirdNETmonitor/BirdWatcherImages/Leucophaeus pipixcan_Franklin's Gull",
        "BirdNETmonitor/BirdWatcherImages/Limnodromus scolopaceus_Long-billed Dowitcher",
        "BirdNETmonitor/BirdWatcherImages/Limosa haemastica_Hudsonian Godwit",
        "BirdNETmonitor/BirdWatcherImages/Lonchura atricapilla_Chestnut Munia",
        "BirdNETmonitor/BirdWatcherImages/Lonchura punctulata_Scaly-breasted Munia",
        "BirdNETmonitor/BirdWatcherImages/Lophodytes cucullatus_Hooded Merganser",
        "BirdNETmonitor/BirdWatcherImages/Lophura leucomelanos_Kalij Pheasant",
        "BirdNETmonitor/BirdWatcherImages/Loxioides bailleui_Palila",
        "BirdNETmonitor/BirdWatcherImages/Loxops caeruleirostris_Akekee",
        "BirdNETmonitor/BirdWatcherImages/Loxops coccineus_Hawaii Akepa",
        "BirdNETmonitor/BirdWatcherImages/Loxops mana_Hawaii Creeper",
        "BirdNETmonitor/BirdWatcherImages/Mareca americana_American Wigeon",
        "BirdNETmonitor/BirdWatcherImages/Mareca penelope_Eurasian Wigeon",
        "BirdNETmonitor/BirdWatcherImages/Mareca strepera_Gadwall",
        "BirdNETmonitor/BirdWatcherImages/Megaceryle alcyon_Belted Kingfisher",
        "BirdNETmonitor/BirdWatcherImages/Meleagris gallopavo_Wild Turkey",
        "BirdNETmonitor/BirdWatcherImages/Mimus polyglottos_Northern Mockingbird",
        "BirdNETmonitor/BirdWatcherImages/Myadestes obscurus_Omao",
        "BirdNETmonitor/BirdWatcherImages/Myadestes palmeri_Puaiohi",
        "BirdNETmonitor/BirdWatcherImages/Numenius tahitiensis_Bristle-thighed Curlew",
        "BirdNETmonitor/BirdWatcherImages/Nycticorax nycticorax_Black-crowned Night-Heron",
        "BirdNETmonitor/BirdWatcherImages/Onychoprion fuscatus_Sooty Tern",
        "BirdNETmonitor/BirdWatcherImages/Onychoprion lunatus_Gray-backed Tern",
        "BirdNETmonitor/BirdWatcherImages/Oreomystis bairdi_Akikiki",
        "BirdNETmonitor/BirdWatcherImages/Ortygornis pondicerianus_Gray Francolin",
        "BirdNETmonitor/BirdWatcherImages/Padda oryzivora_Java Sparrow",
        "BirdNETmonitor/BirdWatcherImages/Palmeria dolei_Akohekohe",
        "BirdNETmonitor/BirdWatcherImages/Pandion haliaetus_Osprey",
        "BirdNETmonitor/BirdWatcherImages/Paroaria capitata_Yellow-billed Cardinal",
        "BirdNETmonitor/BirdWatcherImages/Paroaria coronata_Red-crested Cardinal",
        "BirdNETmonitor/BirdWatcherImages/Paroreomyza montana_Maui Alauahio",
        "BirdNETmonitor/BirdWatcherImages/Passer domesticus_House Sparrow",
        "BirdNETmonitor/BirdWatcherImages/Pavo cristatus_Indian Peafowl",
        "BirdNETmonitor/BirdWatcherImages/Phaethon lepturus_White-tailed Tropicbird",
        "BirdNETmonitor/BirdWatcherImages/Phaethon rubricauda_Red-tailed Tropicbird",
        "BirdNETmonitor/BirdWatcherImages/Phalaropus fulicarius_Red Phalarope",
        "BirdNETmonitor/BirdWatcherImages/Phasianus colchicus_Ring-necked Pheasant",
        "BirdNETmonitor/BirdWatcherImages/Phoebastria immutabilis_Laysan Albatross",
        "BirdNETmonitor/BirdWatcherImages/Phoebastria nigripes_Black-footed Albatross",
        "BirdNETmonitor/BirdWatcherImages/Plegadis chihi_White-faced Ibis",
        "BirdNETmonitor/BirdWatcherImages/Pluvialis fulva_Pacific Golden-Plover",
        "BirdNETmonitor/BirdWatcherImages/Pluvialis squatarola_Black-bellied Plover",
        "BirdNETmonitor/BirdWatcherImages/Podilymbus podiceps_Pied-billed Grebe",
        "BirdNETmonitor/BirdWatcherImages/Porzana carolina_Sora",
        "BirdNETmonitor/BirdWatcherImages/Pseudonestor xanthophrys_Maui Parrotbill",
        "BirdNETmonitor/BirdWatcherImages/Psittacara erythrogenys_Red-masked Parakeet",
        "BirdNETmonitor/BirdWatcherImages/Psittacara mitratus_Mitred Parakeet",
        "BirdNETmonitor/BirdWatcherImages/Psittacula krameri_Rose-ringed Parakeet",
        "BirdNETmonitor/BirdWatcherImages/Pternistis erckelii_Erckel's Francolin",
        "BirdNETmonitor/BirdWatcherImages/Pterocles exustus_Chestnut-bellied Sandgrouse",
        "BirdNETmonitor/BirdWatcherImages/Pterodroma cookii_Cook's Petrel",
        "BirdNETmonitor/BirdWatcherImages/Pterodroma externa_Juan Fernandez Petrel",
        "BirdNETmonitor/BirdWatcherImages/Pterodroma inexpectata_Mottled Petrel",
        "BirdNETmonitor/BirdWatcherImages/Pterodroma neglecta_Kermadec Petrel",
        "BirdNETmonitor/BirdWatcherImages/Pterodroma nigripennis_Black-winged Petrel",
        "BirdNETmonitor/BirdWatcherImages/Pterodroma sandwichensis_Hawaiian Petrel",
        "BirdNETmonitor/BirdWatcherImages/Puffinus nativitatis_Christmas Shearwater",
        "BirdNETmonitor/BirdWatcherImages/Puffinus newelli_Newell's Shearwater",
        "BirdNETmonitor/BirdWatcherImages/Sicalis flaveola_Saffron Finch",
        "BirdNETmonitor/BirdWatcherImages/Spatula clypeata_Northern Shoveler",
        "BirdNETmonitor/BirdWatcherImages/Spatula cyanoptera_Cinnamon Teal",
        "BirdNETmonitor/BirdWatcherImages/Spatula discors_Blue-winged Teal",
        "BirdNETmonitor/BirdWatcherImages/Stercorarius longicaudus_Long-tailed Jaeger",
        "BirdNETmonitor/BirdWatcherImages/Stercorarius maccormicki_South Polar Skua",
        "BirdNETmonitor/BirdWatcherImages/Stercorarius parasiticus_Parasitic Jaeger",
        "BirdNETmonitor/BirdWatcherImages/Stercorarius pomarinus_Pomarine Jaeger",
        "BirdNETmonitor/BirdWatcherImages/Sterna paradisaea_Arctic Tern",
        "BirdNETmonitor/BirdWatcherImages/Sternula antillarum_Least Tern",
        "BirdNETmonitor/BirdWatcherImages/Streptopelia chinensis_Spotted Dove",
        "BirdNETmonitor/BirdWatcherImages/Sturnella neglecta_Western Meadowlark",
        "BirdNETmonitor/BirdWatcherImages/Sula dactylatra_Masked Booby",
        "BirdNETmonitor/BirdWatcherImages/Sula leucogaster_Brown Booby",
        "BirdNETmonitor/BirdWatcherImages/Sula sula_Red-footed Booby",
        "BirdNETmonitor/BirdWatcherImages/Tringa flavipes_Lesser Yellowlegs",
        "BirdNETmonitor/BirdWatcherImages/Tringa incana_Wandering Tattler",
        "BirdNETmonitor/BirdWatcherImages/Tyto alba_Barn Owl",
        "BirdNETmonitor/BirdWatcherImages/Zenaida macroura_Mourning Dove",
        "BirdNETmonitor/BirdWatcherImages/Zosterops japonicus_Warbling White-eye"

      ),
      link = c(
        "https://ebird.org/species/redava",
        "https://ebird.org/species/norpin",
        "https://ebird.org/species/gnwtea",
        "https://ebird.org/species/mallar3/L2557088",
        "https://ebird.org/species/blknod/L1657549",
        "https://ebird.org/species/brnnod",
        "https://ebird.org/species/gwfgoo",
        "https://ebird.org/species/snogoo",
        "https://ebird.org/species/grbher3",#9


      )
    )

    for (i in 1:3) {
      image_id <- paste0("imageDisplay", i)
      observeEvent(input[[paste0("image_click", i)]], {
        url <- image_data$link[i]
        shinyjs::runjs(paste0("window.open('", url, "', '_blank');"))
      })

      output[[image_id]] <- renderImage({
        list(src = image_data$image_path[i], height = 300)
      }, deleteFile = FALSE)
    }


  })
}

shinyApp(Wiki, wiki_server)
