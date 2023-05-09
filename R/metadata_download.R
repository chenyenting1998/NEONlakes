# Author: Yen-Ting Chen
# Last modified date: 2023/05/02
# install packages ####
# install.packages("neonUtilities")
# install.packages("neonOS")
# install.packages("raster")
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("ggplot2")
# install.packages("scales")
# install.packages("Polychrome")
# install.packages("lubridate")

# load packages
library(neonUtilities)
library(neonOS)
library(raster)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
library(Polychrome)
library(lubridate)

# load code 
source("source//download_url.R")

# define lake sites
site <- c("BARC",  # D03
          "SUGG",  # D03
          "CRAM",  # D05
          "LIRO",  # D05
          "PRLA",  # D09
          "PRPO",  # D09
          "TOOK") # D18

# sw microbe metagenome sequences ####
# DP1.20281.001
sw_metaG_meta <- loadByProduct(dpID = "DP1.20281.001",
                               package = "expanded", # expanded to get RawDataFiles
                               site = site)
save(sw_metaG_meta, file = "data/sw_metaG_meta.RData")

# print in .xlsx files
for (i in 1:length(sw_metaG_meta)){
  xlsx_path <- paste0("metagenome metadata/", names(sw_metaG_meta)[i], ".xlsx")
  writexl::write_xlsx(sw_metaG_meta[i], xlsx_path)
}

# sw microbe cell count ####
# DP1.20138.001
# check metagenome date range to prevent cell count download halting
# sw_metaG_meta$amc_fieldGenetic$collectDate %>% range
sw_cellcount <- loadByProduct(dpID = "DP1.20138.001",
                              package = "expanded", # expanded to get RawDataFiles
                              startdate = "2015-01",
                              enddate = "2020-12",
                              site = site)
save(sw_cellcount, file = "data/sw_cellcount.RData")

# sw microbe marker gene sequences ####
# DP1.20282.001