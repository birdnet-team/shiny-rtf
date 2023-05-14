# # Laden Sie das tuneR-Paket herunter, wenn es nicht bereits installiert ist
# if (!require("tuneR")) {
#   install.packages("tuneR")
#   library("tuneR")
# }
#
# # URL der Audio-Datei
# audio_url <- "https://reco.birdnet.tucmi.de/reco/det/437d8325-7df9-47d6-a858-48a74aef4f86/audio"
#
# # Dateiname, unter dem die Audio-Datei gespeichert werden soll
# audio_file <- "audio.wav"
#
# # Herunterladen der Audio-Datei mit der download.file-Funktion
# download.file(audio_url, audio_file, mode = "wb")
#
# # Lesen Sie die Audio-Datei mit der readWave-Funktion des tuneR-Pakets
# audio <- readWave(audio_file)
#
# # Abspielen der Audio-Datei
# play(audio)
