# install packages ####
# install.packages("neonUtilities")
# install.packages("neonOS")
# install.packages("raster")

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

# sw microbe cell count ####
# DP1.20138.001
sw_cellcount <- loadByProduct(dpID = "DP1.20138.001",
                               package = "expanded", # expanded to get RawDataFiles
                               site = site)

# sw microbe marker gene sequences ####
# DP1.20282.001

# sw microbe metagenome sequences ####
# DP1.20281.001
sw_metaG_meta <- loadByProduct(dpID = "DP1.20281.001",
                               package = "expanded", # expanded to get RawDataFiles
                               site = site)

save(sw_metaG_meta, file = "data/sw_metaG_meta.RData")
