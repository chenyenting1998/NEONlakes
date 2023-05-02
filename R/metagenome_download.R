# Downloading Toolik Lake surface water metagenome
# 2023/04/20, Yen-Ting Chen
library(neonUtilities)
library(neonOS)
library(raster)
library(dplyr)

source("source//download_url.R")

# Download metadata for metagenome　####
# sw_metag <- loadByProduct(dpID = "DP1.20281.001",
#                           package = "expanded",  
#                           site = "TOOK")
# save(sw_metag, file = "sw_metag_testing.RData")
load(file = "sw_metag_testing.RData")

# file of interest ####
View(sw_metag$mms_swMetagenomeDnaExtraction)
View(sw_metag$mms_swMetagenomeSequencing)
View(sw_metag$mms_swRawDataFiles)

# Download sequencing files####
# extract url list from metadata
url_list <- sw_metag$mms_swRawDataFiles$rawDataFilePath

# download sequencing data from the urls
download_url(url_list,
             # )