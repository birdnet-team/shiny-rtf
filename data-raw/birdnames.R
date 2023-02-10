## code to prepare `birdnames` dataset goes here

birdnames <-
  readr::read_delim("data-raw/BirdNET_HI_2022_Labels_and_codes.txt", delim = ",", col_names = c("names", "code")) |>
  tidyr::separate_wider_delim(cols = "names", delim = "_", names = c("scientific", "common"))

usethis::use_data(birdnames, overwrite = TRUE)
