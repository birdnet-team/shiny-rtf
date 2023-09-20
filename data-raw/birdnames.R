## code to prepare `birdnames` dataset goes here

birdnames <-
  readr::read_delim("data-raw/BirdNET_HI_2022_Labels_and_codes.txt", delim = ",", col_names = c("names", "code")) |>
  tidyr::separate_wider_delim(cols = "names", delim = "_", names = c("scientific", "common"))

usethis::use_data(birdnames, overwrite = TRUE)

other_categories <-
  tibble::tribble(
    ~common, ~code,
    "Dog",     "dogdog",
    "Engine",     "engine",
    "Environmental",     "envrnm",
    "Fireworks",     "frwrks",
    "Gun",     "gungun",
    "Human non-vocal",     "humnov",
    "Human vocal",     "humvoc",
    "Human whistle",     "humwhi",
    "Noise",     "nocall",
    "Power tools",     "powtoo",
    "Siren",     "siren1"
  )

usethis::use_data(other_categories, overwrite = TRUE)


all_categories <-
  other_categories |>
  dplyr::mutate(scientific = common) |>
  dplyr::bind_rows(birdnames)


usethis::use_data(all_categories, overwrite = TRUE)
