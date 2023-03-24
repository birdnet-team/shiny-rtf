install.packages("soundgen")
library(soundgen)

s = soundgen(
  sylLen = 230,               # duration of voiced part, ms
  pitch = c(305, 280),        # pitch, Hz (goes down from 305 to 380 Hz)
  ampl = c(0, -20),           # amplitude, dB (gradual fade-out by 20 dB)
  rolloff = -30,              # strong f0, weak harmonics
  temperature = 0.05,         # some stochasticity in generation
  formants = c(260, 960, 1500, 2200,  # F1-F8 formant frequencies, Hz
               2600, 3600, 4200, 4500),
  noise = data.frame(
    time = c(-50, 120, 700),  # time of noise anchors
    value = c(-15, -5, -50)   # noise amplitude, dB
  ),
  rolloffNoise = 0,           # flat noise spectrum before adding formants
  addSilence = 0, samplingRate = 44100, pitchSamplingRate = 44100,
  play = TRUE, plot = TRUE, osc = TRUE, ylim = c(0, 6)
)
