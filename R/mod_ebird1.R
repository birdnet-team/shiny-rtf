#' ebird Server Functions
#'
#' @noRd
mod_ebird_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    image_paths <- c(
      "www/1_Amandava_amandava_Red_Avadavat.png",
      "www/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
      "www/3_Green-winged_Teal,_Port_Aransas,_Texas.png",
      "www/Anas platyrhynchos_Mallard.png",
      "www/Anous minutus_Black Noddy.png",
      "www/Anous stolidus_Brown Noddy.png",
      "www/Anser albifrons_Greater White-fronted Goose.png",
      "www/Anser caerulescens_Snow Goose.png",
      "www/Ardea herodias_Great Blue Heron.png",
      "www/Ardenna grisea_Sooty Shearwater.png",
      "www/Ardenna pacifica_Wedge-tailed Shearwater.png"
    )

    image_links <- c(
      "https://ebird.org/species/grnava",
      "https://ebird.org/species/norpint",
      "https://ebird.org/species/grwtea",
      "https://ebird.org/species/mallar3",
      "https://ebird.org/species/blanod",
      "https://ebird.org/species/branod",
      "https://ebird.org/species/gfwgoo",
      "https://ebird.org/species/snggoo",
      "https://ebird.org/species/grbher",
      "https://ebird.org/species/sooshe",
      "https://ebird.org/species/wgtshe"
    )

    output$images <- renderUI({
      lapply(seq_along(image_paths), function(i) {
        div(
          style = "margin-bottom: 10px; margin-top: 10px; margin-left: 10px; margin-right: 10px; display: inline-block",
          tags$a(href = image_links[i], shiny::img(src = image_paths[i], height = "200px", alt = basename(image_paths[i])), target = "_blank")
        )
      })
    })
  })
}
