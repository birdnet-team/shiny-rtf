library(shiny)

ui <- fluidPage(
 titlePanel("Hawaiianisches BirdWiki"),
 mainPanel(
   uiOutput("imageDisplay1"),
   uiOutput("imageDisplay2"),
   uiOutput("imageDisplay3"),
   uiOutput("imageDisplay4"),
   uiOutput("imageDisplay5"),
   uiOutput("imageDisplay6"),
   uiOutput("imageDisplay7"),
   uiOutput("imageDisplay8"),
   uiOutput("imageDisplay9"),
   uiOutput("imageDisplay10"),
   uiOutput("imageDisplay11"),
   uiOutput("imageDisplay12"),
   uiOutput("imageDisplay13"),
   uiOutput("imageDisplay14"),
   uiOutput("imageDisplay15"),
   uiOutput("imageDisplay16"),
   uiOutput("imageDisplay17"),
   uiOutput("imageDisplay18"),
   uiOutput("imageDisplay19"),
   uiOutput("imageDisplay20"),
   uiOutput("imageDisplay21"),
   uiOutput("imageDisplay22"),
   uiOutput("imageDisplay23"),
   uiOutput("imageDisplay24"),
   uiOutput("imageDisplay25"),
   uiOutput("imageDisplay26"),
   uiOutput("imageDisplay27"),
   uiOutput("imageDisplay28"),
   uiOutput("imageDisplay29"),
   uiOutput("imageDisplay30"),
   uiOutput("imageDisplay31"),
   uiOutput("imageDisplay32"),
   uiOutput("imageDisplay33"),
   uiOutput("imageDisplay34"),
   uiOutput("imageDisplay35"),
   uiOutput("imageDisplay36"),
   uiOutput("imageDisplay37"),
   uiOutput("imageDisplay38"),
   uiOutput("imageDisplay39"),
   uiOutput("imageDisplay40"),
   uiOutput("imageDisplay41"),
   uiOutput("imageDisplay42"),
   uiOutput("imageDisplay43"),
   uiOutput("imageDisplay44"),
   uiOutput("imageDisplay45"),
   uiOutput("imageDisplay46"),
   uiOutput("imageDisplay47"),
   uiOutput("imageDisplay48"),
   uiOutput("imageDisplay49"),
   uiOutput("imageDisplay50"),
   uiOutput("imageDisplay51"),
   uiOutput("imageDisplay52"),
   uiOutput("imageDisplay53"),
   uiOutput("imageDisplay54"),
   uiOutput("imageDisplay55"),
   uiOutput("imageDisplay56"),
   uiOutput("imageDisplay57"),
   uiOutput("imageDisplay58"),
   uiOutput("imageDisplay59"),
   uiOutput("imageDisplay60"),
   uiOutput("imageDisplay61"),
   uiOutput("imageDisplay62"),
   uiOutput("imageDisplay63"),
   uiOutput("imageDisplay64"),
   uiOutput("imageDisplay65"),
   uiOutput("imageDisplay66"),
   uiOutput("imageDisplay67"),
   uiOutput("imageDisplay68"),
   uiOutput("imageDisplay69"),
   uiOutput("imageDisplay70"),
   uiOutput("imageDisplay71"),
   uiOutput("imageDisplay72"),
   uiOutput("imageDisplay73"),
   uiOutput("imageDisplay74"),
   uiOutput("imageDisplay75"),
   uiOutput("imageDisplay76"),
   uiOutput("imageDisplay77"),
   uiOutput("imageDisplay78"),
   uiOutput("imageDisplay79"),
   uiOutput("imageDisplay80"),
   uiOutput("imageDisplay81"),
   uiOutput("imageDisplay82"),
   uiOutput("imageDisplay83"),
   uiOutput("imageDisplay84"),
   uiOutput("imageDisplay85"),
   uiOutput("imageDisplay86"),
   uiOutput("imageDisplay87"),
   uiOutput("imageDisplay88"),
   uiOutput("imageDisplay89"),
   uiOutput("imageDisplay90"),
   uiOutput("imageDisplay91"),
   uiOutput("imageDisplay92"),
   uiOutput("imageDisplay93"),
   uiOutput("imageDisplay94"),
   uiOutput("imageDisplay95"),
   uiOutput("imageDisplay96"),
   uiOutput("imageDisplay97"),
   uiOutput("imageDisplay98"),
   uiOutput("imageDisplay99"),
   uiOutput("imageDisplay100")



  )
)

server <- function(input, output, session) {
  output$imageDisplay1 <- renderUI({
    tags$img(
      src = "Amandava_amandava_Red_Avadavat.png",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
    )
  })

  output$imageDisplay2 <- renderUI({
    tags$img(
      src = "Anas_acuta_Northern_Pintail",
      width = "300px",
      height = "300px",
      onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
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


}

shinyApp(ui, server)
