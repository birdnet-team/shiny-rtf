# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

pkgload::load_all(export_all = FALSE,helpers = FALSE,attach_testthat = FALSE)
#options( "golem.app.prod" = TRUE)
BirdNETmonitor::run_app() # add parameters here (if any)

##XXExport all backEnd-Data into an excel-file
if (!require(writexl)) install.packages("writexl")
if (!require (readxl)) install.packages("readxl")
if (!require(tidyverse)) install.packages("tidyverse")

library(writexl)
library(readxl)
library(tidyverse)

##XXWrite Excel-File
dir.create("7777")
source("http://rfunction.com/code/1203/120312.R") ##should be "data"
list.files("7777")


write::write_xlsx(data, path = "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/logs/dataBEXX.xlsx")
