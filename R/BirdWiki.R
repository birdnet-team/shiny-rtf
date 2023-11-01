#' @importFrom shiny NS tagList fluidPage titlePanel fluidRow column uiOutput
#' @import httr
#' @import png

Wiki <- function(id){

titlePanel("Hawaiianisches BirdWiki")
mainPanel(
fluidRow(lapply(1:174, function(i) {column(4, uiOutput(ns(paste0("imageDisplay", i))))})))
}



wiki_server <- function(input, output, session) {

  output$imageDisplay1 <- renderUI({
  tags$img(
    src = "file:///C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor.Rcheck/00_pkg_src/BirdNETmonitor/inst/app/www/birds/Amandava_amandava_Red_Avadavat.png",
    height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay2 <- renderUI({
  tags$img(
  src = "Anas_acuta_Northern_Pintail",
  width = "auto",
  height = "auto",
  onclick = "window.open('https://ebird.org/species/norpin', '_blank')"
  )
  })

  output$imageDisplay3 <- renderUI({
  tags$img(
  src = "Anas_crecca_Green-winged_Teal",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay4 <- renderUI({
  tags$img(
  src = "Anas_platyrhynchos_Mallard",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay5 <- renderUI({
  tags$img(
  src = "Anous_minutus_Black_Noddy",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay6 <- renderUI({
  tags$img(
  src = "Anous_stolidus_Brown_Noddy",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay7 <- renderUI({
  tags$img(
  src = "Anser_albifrons_Greater_White-fronted_Goose",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay8 <- renderUI({
  tags$img(
  src = "Anser_caerulescens_Snow_Goose",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay9 <- renderUI({
  tags$img(
  src = "Ardea_herodias_Great_Blue_Heron",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay10 <- renderUI({
  tags$img(
  src = "Ardenna_grisea_Sooty_Shearwater",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay11 <- renderUI({
  tags$img(
  src = "Ardenna_pacifica_Wedge-tailed_Shearwater",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay12 <- renderUI({
  tags$img(
  src = "Ardenna_tenuirostris_Short-tailed_Shearwater",
  width = "300px",
  height = "300px",
  onclick = "window.open('https.ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay13 <- renderUI({
  tags$img(
  src = "Arenaria_interpres_Ruddy_Turnstone.png",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay14 <- renderUI({
  tags$img(
  src = "Asio_flammeus_Short-eared_Owl",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay15 <- renderUI({
  tags$img(
  src = "Aythya_affinis_Lesser_Scaup",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay16 <- renderUI({
  tags$img(
  src = "Aythya_collaris_Ring-necked_Duck",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay17 <- renderUI({
  tags$img(
  src = "Aythya_marila_Greater_Scaup",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay18 <- renderUI({
  tags$img(
  src = "Aythya_valisineria_Canvasback",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay19 <- renderUI({
  tags$img(
  src = "Branta_bernii_Brant",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay20 <- renderUI({
  tags$img(
  src = "Branta_canadensis_Canada_Goose",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay21 <- renderUI({
  tags$img(
  src = "Branta_hutchinsii_Cackling_Goose",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay22 <- renderUI({
  tags$img(
  src = "Branta_sandvicensis_Hawaiian_Goose",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay23 <- renderUI({
  tags$img(
  src = "Bubulcus_ibis_Cattle_Egret",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay24 <- renderUI({
  tags$img(
  src = "Bucephala_albeola_Bufflehead",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay25 <- renderUI({
  tags$img(
  src = "Bulweria_bulwerii_Bulwer_Petrel",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay26 <- renderUI({
  tags$img(
  src = "Buteo_solitarius_Hawaiian_Hawk",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay27 <- renderUI({
  tags$img(
  src = "Calidris_acuminata_Sharp-tailed_Sandpiper",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay28 <- renderUI({
  tags$img(
  src = "Calidris_alba_Sanderling",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay29 <- renderUI({
  tags$img(
  src = "Calidris_alpina_Dunlin",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay30 <- renderUI({
  tags$img(
  src = "Calidris_mauri_Western_Sandpiper",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay31 <- renderUI({
  tags$img(
  src = "Calidris_melanotos_Pectoral_Sandpiper",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay32 <- renderUI({
  tags$img(
  src = "Calidris_minutilla_Least_Sandpiper",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay33 <- renderUI({
  tags$img(
  src = "Calidris_pugnax_Ruff",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay34 <- renderUI({
  tags$img(
  src = "Calidris_subruficollis_Buff-breasted_Sandpiper",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay35 <- renderUI({
  tags$img(
  src = "Callipepla_californica_California_Quail",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay36 <- renderUI({
  tags$img(
  src = "Callipepla_gambelii_Gambels_Quail",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay37 <- renderUI({
  tags$img(
  src = "Cardinalis_cardinalis_Northern_Cardinal",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })


  output$imageDisplay38 <- renderUI({
  tags$img(
  src = "Charadrius_semipalmatus_Semipalmated_Plover",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  )
  })

  output$imageDisplay39 <- renderUI({
  tags$img(
  src = "Chasiempis_sandwichensis_Hawaii_Elepaio",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')")})

  output$imageDisplay40 <- renderUI({
  tags$img(
  src = "Chlorodrepanis_virens_Hawaii_Amakihi",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')")})

  output$imageDisplay41 <- renderUI({
  tags$img(
  src = "Chroicocephalus_philadelphia_Bonaparte_Gull",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')")})

  output$imageDisplay42 <- renderUI({
  tags$img(
  src = "Chrysolophus_pictus_Golden_Pheasant",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')")})

  output$imageDisplay43 <- renderUI({
  tags$img(
  src = "Circus_hudsonius_Northern_Harrier",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')")})

  output$imageDisplay44 <- renderUI({
  tags$img(
  src = "Columba_livia_Rock_Pigeon",
  width = "300px",
  height = "300px",
  onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')")})


  output$imageDisplay45 <- renderUI({
    tags$img(
      src = "Calidris acuminata_Sharp-tailed Sandpiper",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')")})

  output$imageDisplay46 <- renderUI({
    tags$img(
      src = "Calidris alba_Sanderling",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')")})

  output$imageDisplay47 <- renderUI({
    tags$img(
      src = "Calidris alpina_Dunlin",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')")})

  output$imageDisplay48 <- renderUI({
    tags$img(
      src = "Calidris mauri_Western Sandpiper",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')")})

  output$imageDisplay49 <- renderUI({
    tags$img(
      src = "Calidris melanotos_Pectoral Sandpiper",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')")})

  output$imageDisplay50 <- renderUI({
    tags$img(
      src = "Calidris minutilla_Least Sandpiper",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')")})

  output$imageDisplay51 <- renderUI({
    tags$img(
      src = "Calidris pugnax_Ruff",
      width = "300px",
      height = "300px",
      onclick = "window.open('LINK_ZU_RUFF', '_blank')")})

  output$imageDisplay52 <- renderUI({
    tags$img(
      src = "Calidris subruficollis_Buff-breasted Sandpiper",
      width = "300px",
      height = "300px",
      onclick = "window.open('LINK_ZU_BUFF-BREASTED_SANDPIPER', '_blank')")})

  output$imageDisplay53 <- renderUI({
    tags$img(
      src = "Calidris minutilla_Least Sandpiper",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Least_Sandpiper', '_blank')")})

  output$imageDisplay54 <- renderUI({
    tags$img(
      src = "Calidris pugnax_Ruff",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Ruff', '_blank')")})

  output$imageDisplay55 <- renderUI({
    tags$img(
      src = "Calidris subruficollis_Buff-breasted Sandpiper",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Buff-breasted_Sandpiper', '_blank')")})

  output$imageDisplay56 <- renderUI({
    tags$img(
      src = "Callipepla californica_California Quail",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/California_Quail', '_blank')")})

  output$imageDisplay57 <- renderUI({
    tags$img(
      src = "Callipepla gambelii_Gambel's Quail",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Gambel%27s_Quail', '_blank')")})

  output$imageDisplay58 <- renderUI({
    tags$img(
      src = "Cardinalis cardinalis_Northern Cardinal",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Northern_Cardinal', '_blank')")})

  output$imageDisplay59 <- renderUI({
    tags$img(
      src = "Charadrius semipalmatus_Semipalmated Plover",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Semipalmated_Plover', '_blank')")})

  output$imageDisplay60 <- renderUI({
    tags$img(
      src = "Chasiempis sandwichensis_Hawaii Elepaio",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Hawaii_Elepaio', '_blank')")})

  output$imageDisplay61 <- renderUI({
    tags$img(
      src = "Chlorodrepanis virens_Hawaii Amakihi",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Hawaii_Amakihi', '_blank')")})

  output$imageDisplay62 <- renderUI({
    tags$img(
      src = "Chroicocephalus philadelphia_Bonaparte's Gull",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Bonaparte%27s_Gull', '_blank')")})

  output$imageDisplay63 <- renderUI({
    tags$img(
      src = "Chrysolophus pictus_Golden Pheasant",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Golden_Pheasant', '_blank')")})

  output$imageDisplay64 <- renderUI({
    tags$img(
      src = "Circus hudsonius_Northern Harrier",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Northern_Harrier', '_blank')")})

  output$imageDisplay65 <- renderUI({
    tags$img(
      src = "Columba livia_Rock Pigeon",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Rock_Pigeon', '_blank')")})

  output$imageDisplay66 <- renderUI({
    tags$img(
      src = "Corvus hawaiiensis_Hawaiian Crow",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Hawaiian_Crow', '_blank')")})

  output$imageDisplay67 <- renderUI({
    tags$img(
      src = "Coturnix japonica_Japanese Quail",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Japanese_Quail', '_blank')")})

  output$imageDisplay68 <- renderUI({
    tags$img(
      src = "Crithagra mozambica_Yellow-fronted Canary",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Yellow-fronted_Canary', '_blank')")})

  output$imageDisplay68 <- renderUI({
    tags$img(
      src = "Cyanoliseus patagonus_Burrowing Parakeet",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Burrowing_Parakeet', '_blank')")})

  output$imageDisplay69 <- renderUI({
    tags$img(
      src = "Drepanis coccinea_Iiwi",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Iiwi', '_blank')")})

  output$imageDisplay70 <- renderUI({
    tags$img(
      src = "Estrilda astrild_Common Waxbill",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Common_Waxbill', '_blank')")})

  output$imageDisplay71 <- renderUI({
    tags$img(
      src = "Euodice cantans_African Silverbill",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/African_Silverbill', '_blank')")})

  output$imageDisplay72 <- renderUI({
    tags$img(
      src = "Falco columbarius_Merlin",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Merlin_(bird)', '_blank')")})

  output$imageDisplay73 <- renderUI({
    tags$img(
      src = "Falco peregrinus_Peregrine Falcon",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Peregrine_Falcon', '_blank')")})

  output$imageDisplay74 <- renderUI({
    tags$img(
      src = "Francolinus francolinus_Black Francolin",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Black_Francolin', '_blank')")})

  output$imageDisplay75 <- renderUI({
    tags$img(
      src = "Fregata minor_Great Frigatebird",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Great_Frigatebird', '_blank')")})

  output$imageDisplay76 <- renderUI({
    tags$img(
      src = "Fulica alai_Hawaiian Coot",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Hawaiian_Coot', '_blank')")})

  output$imageDisplay77 <- renderUI({
    tags$img(
      src = "Gallinula galeata_Common Gallinule",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Common_Gallinule', '_blank')")})

  output$imageDisplay78 <- renderUI({
    tags$img(
      src = "Gallus gallus_Red Junglefowl",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Red_Junglefowl', '_blank')")})

  output$imageDisplay79 <- renderUI({
    tags$img(
      src = "Garrulax canorus_Chinese Hwamei",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Chinese_Hwamei', '_blank')")})

  output$imageDisplay80 <- renderUI({
    tags$img(
      src = "Geopelia striata_Zebra Dove",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Zebra_Dove', '_blank')")})

  output$imageDisplay81 <- renderUI({
    tags$img(
      src = "Glaucestrilda caerulescens_Lavender Waxbill",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Lavender_Waxbill', '_blank')")})

  output$imageDisplay82 <- renderUI({
    tags$img(
      src = "Gygis alba_White Tern",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/White_Tern', '_blank')")})

  output$imageDisplay83 <- renderUI({
    tags$img(
      src = "Haemorhous mexicanus_House Finch",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/House_Finch', '_blank')")})

  output$imageDisplay84 <- renderUI({
    tags$img(
      src = "Hemignathus wilsoni_Akiapolaau",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Akiapolaau', '_blank')")})

  output$imageDisplay85 <- renderUI({
    tags$img(
      src = "Himantopus mexicanus_Black-necked Stilt",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Black-necked_Stilt', '_blank')")})

  output$imageDisplay86 <- renderUI({
    tags$img(
      src = "Himatione sanguinea_Apapane",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Apapane', '_blank')")})

  output$imageDisplay87 <- renderUI({
    tags$img(
      src = "Horornis diphone_Japanese Bush Warbler",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Japanese_Bush_Warbler', '_blank')")})

  output$imageDisplay88 <- renderUI({
    tags$img(
      src = "Hydrobates castro_Band-rumped Storm-Petrel",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Band-rumped_Storm-Petrel', '_blank')")})

  output$imageDisplay89 <- renderUI({
    tags$img(
      src = "Hydrobates leucorhous_Leach's Storm-Petrel",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Leach%27s_Storm-Petrel', '_blank')")})

  output$imageDisplay90 <- renderUI({
    tags$img(
      src = "Hydroprogne caspia_Caspian Tern",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Caspian_Tern', '_blank')")})

  output$imageDisplay91 <- renderUI({
    tags$img(
      src = "Larosterna inca_Inca Tern",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Inca_Tern', '_blank')")})

  output$imageDisplay92 <- renderUI({
    tags$img(
      src = "Larus delawarensis_Ring-billed Gull",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Ring-billed_Gull', '_blank')")})

  output$imageDisplay93 <- renderUI({
    tags$img(
      src = "Larus glaucescens_Glaucous-winged Gull",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Glaucous-winged_Gull', '_blank')")})

  output$imageDisplay94 <- renderUI({
    tags$img(
      src = "Leiothrix lutea_Red-billed Leiothrix",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Red-billed_Leiothrix', '_blank')")})

  output$imageDisplay95 <- renderUI({
    tags$img(
      src = "Leucophaeus atricilla_Laughing Gull",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Laughing_Gull', '_blank')")})

  output$imageDisplay96 <- renderUI({
    tags$img(
      src = "Leucophaeus pipixcan_Franklin's Gull",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Franklin%27s_Gull', '_blank')")})

  output$imageDisplay97 <- renderUI({
    tags$img(
      src = "Limnodromus scolopaceus_Long-billed Dowitcher",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Long-billed_dowitcher', '_blank')")
  })

  output$imageDisplay98 <- renderUI({
    tags$img(
      src = "Limosa haemastica_Hudsonian Godwit",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Hudsonian_godwit', '_blank')")
  })

  output$imageDisplay99 <- renderUI({
    tags$img(
      src = "Lonchura atricapilla_Chestnut Munia",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Chestnut_munia', '_blank')")
  })

  output$imageDisplay100 <- renderUI({
    tags$img(
      src = "Lonchura punctulata_Scaly-breasted Munia",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Scaly-breasted_munia', '_blank')")
  })

  output$imageDisplay101 <- renderUI({
    tags$img(
      src = "Lophodytes cucullatus_Hooded Merganser",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Hooded_merganser', '_blank')")
  })

  output$imageDisplay102 <- renderUI({
    tags$img(
      src = "Lophura leucomelanos_Kalij Pheasant",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Kalij_pheasant', '_blank')")
  })

  output$imageDisplay103 <- renderUI({
    tags$img(
      src = "Loxioides bailleui_Palila",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Palila', '_blank')")
  })

  output$imageDisplay104 <- renderUI({
    tags$img(
      src = "Loxops caeruleirostris_Akekee",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Akekee', '_blank')")
  })

  output$imageDisplay105 <- renderUI({
    tags$img(
      src = "Loxops coccineus_Hawaii Akepa",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Hawaii_akepa', '_blank')")
  })

  output$imageDisplay106 <- renderUI({
    tags$img(
      src = "Loxops mana_Hawaii Creeper",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Hawaii_creeper', '_blank')")
  })

  output$imageDisplay107 <- renderUI({
    tags$img(
      src = "Mareca americana_American Wigeon",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/American_wigeon', '_blank')")
  })

  output$imageDisplay108 <- renderUI({
    tags$img(
      src = "Mareca penelope_Eurasian Wigeon",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Eurasian_wigeon', '_blank')")
  })

  output$imageDisplay109 <- renderUI({
    tags$img(
      src = "Mareca strepera_Gadwall",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Gadwall', '_blank')")
  })

  output$imageDisplay110 <- renderUI({
    tags$img(
      src = "Megaceryle alcyon_Belted Kingfisher",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Belted_kingfisher', '_blank')")
  })

  output$imageDisplay111 <- renderUI({
    tags$img(
      src = "Meleagris gallopavo_Wild Turkey",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Wild_turkey', '_blank')")
  })

  output$imageDisplay112 <- renderUI({
    tags$img(
      src = "Mimus polyglottos_Northern Mockingbird",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Northern_mockingbird', '_blank')")
  })

  output$imageDisplay113 <- renderUI({
    tags$img(
      src = "Myadestes obscurus_Omao",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Omao', '_blank')")
  })

  output$imageDisplay114 <- renderUI({
    tags$img(
      src = "Myadestes palmeri_Puaiohi",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Puaiohi', '_blank')")
  })

  output$imageDisplay115 <- renderUI({
    tags$img(
      src = "Numenius tahitiensis_Bristle-thighed Curlew",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Bristle-thighed_curlew', '_blank')")
  })

  output$imageDisplay116 <- renderUI({
    tags$img(
      src = "Nycticorax nycticorax_Black-crowned Night-Heron",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Black-crowned_night-heron', '_blank')")
  })

  output$imageDisplay117 <- renderUI({
    tags$img(
      src = "Onychoprion fuscatus_Sooty Tern",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Sooty_tern', '_blank')")
  })

  output$imageDisplay118 <- renderUI({
    tags$img(
      src = "Onychoprion lunatus_Gray-backed Tern",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Gray-backed_tern', '_blank')")
  })

  output$imageDisplay119 <- renderUI({
    tags$img(
      src = "Oreomystis bairdi_Akikiki",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Akikiki', '_blank')")
  })

  output$imageDisplay120 <- renderUI({
    tags$img(
      src = "Ortygornis pondicerianus_Gray Francolin",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Gray_francolin', '_blank')")
  })

  output$imageDisplay121 <- renderUI({
    tags$img(
      src = "Padda oryzivora_Java Sparrow",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Java_sparrow', '_blank')")
  })

  output$imageDisplay122 <- renderUI({
    tags$img(
      src = "Palmeria dolei_Akohekohe",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Akohekohe', '_blank')")
  })

  output$imageDisplay123 <- renderUI({
    tags$img(
      src = "Pandion haliaetus_Osprey",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Osprey', '_blank')")
  })

  output$imageDisplay124 <- renderUI({
    tags$img(
      src = "Paroaria capitata_Yellow-billed Cardinal",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Yellow-billed_cardinal', '_blank')")
  })

  output$imageDisplay125 <- renderUI({
    tags$img(
      src = "Paroaria coronata_Red-crested Cardinal",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Red-crested_cardinal', '_blank')")
  })

  output$imageDisplay126 <- renderUI({
    tags$img(
      src = "Paroreomyza montana_Maui Alauahio",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Maui_alauahio', '_blank')")
  })

  output$imageDisplay127 <- renderUI({
    tags$img(
      src = "Passer domesticus_House Sparrow",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/House_sparrow', '_blank')")
  })

  output$imageDisplay128 <- renderUI({
    tags$img(
      src = "Pavo cristatus_Indian Peafowl",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Indian_peafowl', '_blank')")
  })

  output$imageDisplay129 <- renderUI({
    tags$img(
      src = "Phaethon lepturus_White-tailed Tropicbird",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/White-tailed_tropicbird', '_blank')")
  })

  output$imageDisplay130 <- renderUI({
    tags$img(
      src = "Phaethon rubricauda_Red-tailed Tropicbird",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Red-tailed_tropicbird', '_blank')")
  })

  output$imageDisplay131 <- renderUI({
    tags$img(
      src = "Phalaropus fulicarius_Red Phalarope",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Red_phalarope', '_blank')")
  })

  output$imageDisplay132 <- renderUI({
    tags$img(
      src = "Phasianus colchicus_Ring-necked Pheasant",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Ring-necked_pheasant', '_blank')")
  })

  output$imageDisplay133 <- renderUI({
    tags$img(
      src = "Phoebastria immutabilis_Laysan Albatross",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Laysan_albatross', '_blank')")
  })

  output$imageDisplay134 <- renderUI({
    tags$img(
      src = "Phoebastria nigripes_Black-footed Albatross",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Black-footed_albatross', '_blank')")
  })

  output$imageDisplay135 <- renderUI({
    tags$img(
      src = "Plegadis chihi_White-faced Ibis",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/White-faced_ibis', '_blank')")
  })

  output$imageDisplay136 <- renderUI({
    tags$img(
      src = "Pluvialis fulva_Pacific Golden-Plover",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Pacific_golden-plover', '_blank')")
  })

  output$imageDisplay137 <- renderUI({
    tags$img(
      src = "Pluvialis squatarola_Black-bellied Plover",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Black-bellied_plover', '_blank')")
  })

  output$imageDisplay138 <- renderUI({
    tags$img(
      src = "Podilymbus podiceps_Pied-billed Grebe",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Pied-billed_grebe', '_blank')")
  })

  output$imageDisplay139 <- renderUI({
    tags$img(
      src = "Porzana carolina_Sora",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Sora_(bird)', '_blank')")
  })

  output$imageDisplay140 <- renderUI({
    tags$img(
      src = "Pseudonestor xanthophrys_Maui Parrotbill",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Maui_parrotbill', '_blank')")
  })

  output$imageDisplay141 <- renderUI({
    tags$img(
      src = "Psittacara erythrogenys_Red-masked Parakeet",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Red-masked_parakeet', '_blank')")
  })

  output$imageDisplay142 <- renderUI({
    tags$img(
      src = "Psittacara mitratus_Mitred Parakeet",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Mitred_parakeet', '_blank')")
  })

  output$imageDisplay143 <- renderUI({
    tags$img(
      src = "Psittacula krameri_Rose-ringed Parakeet",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Rose-ringed_parakeet', '_blank')")
  })

  output$imageDisplay145 <- renderUI({
    tags$img(
      src = "Pternistis erckelii_Erckel's Francolin",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Erckel%27s_francolin', '_blank')")
  })

  output$imageDisplay146 <- renderUI({
    tags$img(
      src = "Pterocles exustus_Chestnut-bellied Sandgrouse",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Chestnut-bellied_sandgrouse', '_blank')")
  })

  output$imageDisplay147 <- renderUI({
    tags$img(
      src = "Pterodroma cookii_Cook's Petrel",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Cook%27s_petrel', '_blank')")
  })

  output$imageDisplay148 <- renderUI({
    tags$img(
      src = "Pterodroma externa_Juan Fernandez Petrel",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Juan_Fernandez_petrel', '_blank')")
  })

  output$imageDisplay149 <- renderUI({
    tags$img(
      src = "Pterodroma inexpectata_Mottled Petrel",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Mottled_petrel', '_blank')")
  })

  output$imageDisplay150 <- renderUI({
    tags$img(
      src = "Pterodroma neglecta_Kermadec Petrel",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Kermadec_petrel', '_blank')")
  })

  output$imageDisplay151 <- renderUI({
    tags$img(
      src = "Pterodroma nigripennis_Black-winged Petrel",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Black-winged_petrel', '_blank')")
  })

  output$imageDisplay152 <- renderUI({
    tags$img(
      src = "Pterodroma sandwichensis_Hawaiian Petrel",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Hawaiian_petrel', '_blank')")
  })

  output$imageDisplay153 <- renderUI({
    tags$img(
      src = "Puffinus nativitatis_Christmas Shearwater",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Christmas_shearwater', '_blank')")
  })

  output$imageDisplay154 <- renderUI({
    tags$img(
      src = "Puffinus newelli_Newell's Shearwater",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Newell%27s_shearwater', '_blank')")
  })

  output$imageDisplay155 <- renderUI({
    tags$img(
      src = "Sicalis flaveola_Saffron Finch",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Saffron_finch', '_blank')")
  })

  output$imageDisplay156 <- renderUI({
    tags$img(
      src = "Spatula clypeata_Northern Shoveler",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Northern_shoveler', '_blank')")
  })

  output$imageDisplay157 <- renderUI({
    tags$img(
      src = "Spatula cyanoptera_Cinnamon Teal",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Cinnamon_teal', '_blank')")
  })

  output$imageDisplay158 <- renderUI({
    tags$img(
      src = "Spatula discors_Blue-winged Teal",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Blue-winged_teal', '_blank')")
  })

  output$imageDisplay159 <- renderUI({
    tags$img(
      src = "Stercorarius longicaudus_Long-tailed Jaeger",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Long-tailed_jaeger', '_blank')")
  })

  output$imageDisplay160 <- renderUI({
    tags$img(
      src = "Stercorarius maccormicki_South Polar Skua",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/South_Polar_skuas', '_blank')")
  })

  output$imageDisplay161 <- renderUI({
    tags$img(
      src = "Stercorarius parasiticus_Parasitic Jaeger",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Parasitic_jaeger', '_blank')")
  })

  output$imageDisplay162 <- renderUI({
    tags$img(
      src = "Stercorarius pomarinus_Pomarine Jaeger",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Pomarine_jaeger', '_blank')")
  })

  output$imageDisplay163 <- renderUI({
    tags$img(
      src = "Sterna paradisaea_Arctic Tern",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Arctic_tern', '_blank')")
  })

  output$imageDisplay164 <- renderUI({
    tags$img(
      src = "Sternula antillarum_Least Tern",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Least_tern', '_blank')")
  })

  output$imageDisplay165 <- renderUI({
    tags$img(
      src = "Streptopelia chinensis_Spotted Dove",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Spotted_dove', '_blank')")
  })

  output$imageDisplay166 <- renderUI({
    tags$img(
      src = "Sturnella neglecta_Western Meadowlark",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Western_meadowlark', '_blank')")
  })

  output$imageDisplay167 <- renderUI({
    tags$img(
      src = "Sula dactylatra_Masked Booby",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Masked_booby', '_blank')")
  })

  output$imageDisplay168 <- renderUI({
    tags$img(
      src = "Sula leucogaster_Brown Booby",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Brown_booby', '_blank')")
  })

  output$imageDisplay169 <- renderUI({
    tags$img(
      src = "Sula sula_Red-footed Booby",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Red-footed_booby', '_blank')")
  })

  output$imageDisplay170 <- renderUI({
    tags$img(
      src = "Tringa flavipes_Lesser Yellowlegs",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Lesser_yellowlegs', '_blank')")
  })

  output$imageDisplay171 <- renderUI({
    tags$img(
      src = "Tringa incana_Wandering Tattler",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Wandering_tattler', '_blank')")
  })

  output$imageDisplay172 <- renderUI({
    tags$img(
      src = "Tyto alba_Barn Owl",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Barn_owl', '_blank')")
  })

  output$imageDisplay173 <- renderUI({
    tags$img(
      src = "Zenaida macroura_Mourning Dove",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Mourning_dove', '_blank')")
  })

  output$imageDisplay174 <- renderUI({
    tags$img(
      src = "Zosterops japonicus_Warbling White-eye",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://en.wikipedia.org/wiki/Warbling_white-eye', '_blank')")
  })


}

#shinyApp(ui, server)
