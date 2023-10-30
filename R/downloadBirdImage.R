library(httr)
library(rvest)
library(magick)


bird_data <- data.frame(
  bird_name = c("Fulica alai", "Gallinula galeata", "Gallus gallus"),  # Hier ein Beispiel für drei Vogelarten
  wikipedia_url = c(
    "https://en.wikipedia.org/wiki/Hawaiian_Coot",
    "https://en.wikipedia.org/wiki/Common_Gallinule",
    "https://en.wikipedia.org/wiki/Red_Junglefowl"
  )
)

# Ordner für den Download erstellen, wenn er nicht vorhanden ist
download_folder <- "downloads"
if (!dir.exists(download_folder)) {
  dir.create(download_folder)
}

# Funktion, um ein Bild von Wikipedia herunterzuladen
download_wikipedia_image <- function(url) {
  page <- read_html(url)
  image_url <- page %>% html_node("table.infobox a.image img") %>% html_attr("src")

  if (!is.null(image_url)) {
    # Konvertieren Sie den relativen Bild-URL in einen absoluten URL
    image_url <- url_absolute(url, image_url)

    # Dateiname aus der URL extrahieren
    filename <- basename(image_url)

    # Den Dateipfad zum Download-Ordner hinzufügen
    filepath <- file.path(download_folder, filename)

    # Das Bild herunterladen und als PNG speichern
    response <- GET(image_url)
    content_type <- httr::headers(response)$`content-type`
    if (grepl("image/png", content_type, ignore.case = TRUE)) {
      writeBin(content(response), filepath)
      return(filepath)
    } else {
      cat(sprintf("Das Bild für %s ist kein PNG-Bild.\n", bird_name))
      return(NULL)
    }
  } else {
    return(NULL)
  }
}

# Durchlaufen Sie Ihre Vogelarten und laden Sie die Bilder herunter
for (i in 1:nrow(bird_data)) {
  bird_name <- bird_data$bird_name[i]
  wikipedia_url <- bird_data$wikipedia_url[i]

  image_filepath <- download_wikipedia_image(wikipedia_url)

  if (!is.null(image_filepath)) {
    cat(sprintf("Bild für %s heruntergeladen und gespeichert unter %s\n", bird_name, image_filepath))
  } else {
    cat(sprintf("Kein Bild für %s gefunden.\n", bird_name))
  }
}
