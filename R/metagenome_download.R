# Download lake metagenome raw sequences
# Date: 2023/04/20
# Author: Yen-Ting Chen
library(neonUtilities)
library(neonOS)
library(raster)
library(dplyr)

# load source code for downloading files using urls
source("source//download_metagenome.R")

# load metagenome metadata ####
load(file = "data/sw_metaG_meta.RData")

# file of interest ####
# View(sw_metaG_meta$mms_swMetagenomeDnaExtraction)
# View(sw_metaG_meta$mms_swMetagenomeSequencing)
# View(sw_metaG_meta$mms_swRawDataFiles)

#
sw_metaG_meta$mms_swMetagenomeDnaExtraction$genomicsSampleID
# What does CO, IN, and OT mean? A: CO: ; IN: inlet; OT: outlet
# What does AMC.PLANKTON.1~3 mean?

sw_metaG_meta$mms_swMetagenomeDnaExtraction$dnaPooledStatus

68*2
# Download sequencing files####
# extract url list from metadata
url_list <- sw_metaG_meta$mms_swRawDataFiles$rawDataFilePath

# download sequencing data from the urls####
# download to local client
setwd("/Users/yentingchen/Documents/NEONlakes")
download_url(url_list[1], "metagenome/")

# download to external harddrive
setwd("/Volumes/TOSHIBA EXT/")
download_url(url_list[1], "NEONlake_metagenome/")
