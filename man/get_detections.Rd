% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fcts_get_api.R
\name{get_detections}
\alias{get_detections}
\title{Retrieve detections from an API}
\usage{
get_detections(url, params = NULL)
}
\arguments{
\item{url}{The URL of the API}

\item{params}{Parameters to GET request as list. Can include Django field lookups}
}
\value{
A data frame containing the detections
}
\description{
Retrieve detections from an API
}
\examples{
params <- list(
  "recorder_id_id" = "BirdNET-HI111",
  "datetime__gte" = "2023-01-17"
)
get_detections("https://reco.birdnet.tucmi.de/reco")

}
