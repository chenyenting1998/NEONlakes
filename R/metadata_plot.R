# Date: 2023/05/02
# Author: Yen-Ting Chen
# Objective: plot metadata

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

# load metadata
load(file = "data/sw_metag_meta.RData")

# check metagenome basic information ####
sw_metag_meta$amc_fieldGenetic %>% View
sw_metag_meta$mms_swMetagenomeSequencing %>% View
sw_metag_meta$mms_swMetagenomeSequencing$qaqcStatus # one fail

# check year
range(sw_metag_meta$amc_fieldGenetic$collectDate)

# extract metagenome sequencing data.frame ####
metag_seq <- sw_metag_meta$mms_swMetagenomeSequencing
# factorize siteID
metag_seq$siteID <- factor(metag_seq$siteID, levels = site) 
# pivot longer read numbers
metag_seq <- metag_seq %>%
  pivot_longer(cols = c("sampleTotalReadNumber","sampleFilteredReadNumber"),
               names_to = "Total_vs_Filtered",
               values_to = "Number of Reads")
# add 'year' column
metag_seq$year <- as.character(year(metag_seq$collectDate)) 
# assign years with distinct colors
year_color <- kelly.colors(7)[-1]
names(year_color) <- unique(metag_seq$year)

# reads variability ####
reads_var <-
  ggplot(metag_seq) +
  geom_point(aes(x = siteID, y = `Number of Reads`, color = year), 
             stat = "identity",
             shape = 1,
             stroke = 1.5,
             size = 5) +
  facet_grid(~Total_vs_Filtered, scales = "free_y", space = "free_y") +
  scale_y_continuous(labels = comma) +
  scale_color_manual(values = year_color) +
  theme_bw()# +
theme(legend.position = c(0.7,0.1))

ggsave(filename = "figure/reads variability.png",
       plot = reads_var,
       height = 8,
       width = 10,
       scale = 1)

# total reads vs filtered reads ####
reads_TvF <- 
  ggplot(metag_seq) +
  geom_bar(aes(x = `Number of Reads`, y = dnaSampleID, fill = Total_vs_Filtered), stat = "identity") +
  facet_grid(siteID~., scales = "free_y", space = "free_y") +
  scale_x_continuous(labels = comma) +
  theme_bw() +
  theme(legend.position = c(0.7,0.1))

ggsave(filename = "figure/total and filtered sample reads.png",
       plot = reads_TvF,
       height = 8,
       width = 10,
       scale = 1.4)
