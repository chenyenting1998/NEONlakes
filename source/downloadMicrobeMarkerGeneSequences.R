# NEXT FUNCTION CREATED BY LEE F STANISH. TESTING USE ONLY FOR NOW #
#### FUNCTION downloadSequenceMetadataRev2.0 ####
downloadSequenceMetadataRev <- function(sites='all', startYrMo, endYrMo, 
                                        targetGene= "", dpID = "DP1.10108.001", dir="") {
  # author: Lee Stanish
  # date: 2020-06-26
  # function loads soil marker gene sequencing metadata for target gene, site(s) and date(s)
  # option to download output by providing a valid output directory
  # sites: character vector of valid site ID's, or 'all' for all sites
  # targetGene: '16S' or 'ITS'
  # startYrMo: start date, format YYYY-MM
  # endYrMo: end date, format YYYY-MM
  # dpID: NEON data product of interest. Default is soil marker gene sequences
  # dir (optional): If a local copy of the filtered metadata is desired, provide path to output dir [REQUIRED for downloading sequence data]
  
  library(neonUtilities)
  library(plyr)
  library(dplyr)
  
  # check valid data values entered
  ## validate dpID ##
  if(!grepl("DP1", dpID) | !grepl('\\.001', dpID) | !grepl('10108|20280|20282', dpID)) {
    print("Invalid Data Product ID: must follow convention 'DP1.[5-digit value].001' and must be a marker genes data product ID")
    return(NULL)
  } else {
    dpID <- dpID
  }
  
  # validate target gene
  if(!grepl("16S|ITS", targetGene)) {
    print("Invalid targetGene: must be either '16S' or 'ITS'")
    return(NULL)
  } else {
    targetGene <- targetGene
  }
  
  # validate site(s)
  siteList <- c("all","HARV","SCBI","OSBS","GUAN","UNDE","KONZ","ORNL","TALL","WOOD","CPER","CLBJ","YELL","NIWO",
                    "SRER","ONAQ","WREF","SJER","TOOL","BONA","PUUM","BART","BLAN","SERC","SCBI","DSNY","JERC","LAJA",
                    "TREE","STEI","KONA","UKFS","MLBS","GRSM","LENO","DELA","NOGP","DCFS","STER","RMNP","OAES","MOAB",
                    "JORN","ABBY","TEAK","SOAP","BARR","DEJU","HEAL", "HOPB", "POSE", "SUGG", "BARC", "CUPE", "CRAM",
                    "KING", "WALK", "MAYF", "PRPO", "ARIK", "PRIN", "BLDE", "COMO", "SYCA", "REDB", "MART", "TECR",
                    "OKSR", "CARI", "LEWI", "FLNT", "GUIL", "LIRO", "MCDI", "LECO", "TOMB", "BLWA", "PRLA", "BLUE",
                    "WLOU", "MCRA", "BIGC", "TOOK")
  if(any(sites %in% siteList)==FALSE){
    print("Invalid site(s): must be a valid NEON site or 'all'")
    return(NULL)
  } else {
    sites <- sites
  }
  
  print("loading metadata...")
  mmgL1 <- loadByProduct(dpID, sites, package = 'expanded', check.size = F, startdate = startYrMo, enddate = endYrMo) # output is a list of each metadata file
  
  
  # for target data product and targetGene: extract lists into data.frames
  if(grepl("10108", dpID)) {
    if(targetGene=="16S") {
      print("filtering to 16S data")
      seq <- mmgL1$mmg_soilMarkerGeneSequencing_16S
      raw <- mmgL1$mmg_soilRawDataFiles
      
    } else {
      print("filtering to ITS data")
      seq <- mmgL1$mmg_soilMarkerGeneSequencing_ITS
      raw <- mmgL1$mmg_soilRawDataFiles
    }
  }
  
  if(grepl("20280", dpID)) {
    if(targetGene=="16S") {
      print("filtering to 16S data")
      seq <- mmgL1$mmg_benthicMarkerGeneSequencing_16S
      raw <- mmgL1$mmg_benthicRawDataFiles
    } else {
      print("filtering to ITS data")
      seq <- mmgL1$mmg_benthicMarkerGeneSequencing_ITS
      raw <- mmgL1$mmg_benthicRawDataFiles
    }
  }
  
  if(grepl("20282", dpID)) {
    if(targetGene=="16S") {
      print("filtering to 16S data")
      seq <- mmgL1$mmg_swMarkerGeneSequencing_16S
      raw <- mmgL1$mmg_swRawDataFiles
    } else {
      print("filtering to ITS data")
      seq <- mmgL1$mmg_swMarkerGeneSequencing_ITS
      raw <- mmgL1$mmg_swRawDataFiles
    }
  } 
  
  # convert factors to characters (bug in output of loadByProduct)
  i <- sapply(seq, is.factor)
  seq[i] <- lapply(seq[i], as.character)
  j <- sapply(raw, is.factor)
  raw[j] <- lapply(raw[j], as.character)
  
  
  # Join sequencing metadata with raw data files metadata
  if(targetGene=="16S") {
    if(any(grepl("ITS", raw$rawDataFileName))) {
      rawCleaned <- raw[-grep("ITS", raw$rawDataFileName), ]  
    } else {
      rawCleaned <- raw
    }
    joinedTarget <- left_join(rawCleaned, seq, by=c('dnaSampleID', 'sequencerRunID', 'internalLabID'))
    out <- joinedTarget[!is.na(joinedTarget$uid.y), ]
  } else if(targetGene=="ITS") {
    if(any(grepl("16S", raw$rawDataFileName))) {
      rawCleaned <- raw[-grep("16S", raw$rawDataFileName), ]  
    } else {
      rawCleaned <- raw
    }
    joinedTarget <- left_join(rawCleaned, seq, by=c('dnaSampleID', 'sequencerRunID', 'internalLabID'))
    out <- joinedTarget[!is.na(joinedTarget$uid.y), ]
  }
  
  # download local copy if user provided output dir path
  if(dir != "") {
    if(!dir.exists(dir)) {
      dir.create(dir)
    }
    if(grepl("10108", dpID)) {
    	write.csv(out, paste0(dir, "/mmg_soilRawDataFiles.csv"),
              row.names=F)
    	varsFile <- mmgL1$variables
    	write.csv(varsFile, paste0(dir, "/variables", ".csv"),
              row.names=F)
	    print(paste0("metadata and variables file downloaded to: ", dir, "/mmg_soilRawDataFiles.csv") )
    	}
    if(grepl("20280", dpID)) {
    	write.csv(out, paste0(dir, "/mmg_benthicRawDataFiles.csv"),
              row.names=F)
    	varsFile <- mmgL1$variables
    	write.csv(varsFile, paste0(dir, "/variables", ".csv"),
              row.names=F)
	    print(paste0("metadata and variables file downloaded to: ", dir, "/mmg_benthicRawDataFiles.csv") )
    	}
    
    if(grepl("20282", dpID)) {
    	write.csv(out, paste0(dir, "/mmg_swRawDataFiles.csv"),
              row.names=F)
    	varsFile <- mmgL1$variables
    	write.csv(varsFile, paste0(dir, "/variables", ".csv"),
              row.names=F)
	    print(paste0("metadata and variables file downloaded to: ", dir, "/mmg_swRawDataFiles.csv") )
    	}    
  }
  return(out)
  
  ### END FUNCTION ###
}




testZipsByURI <- function (filepath, savepath = paste0(filepath, "/ECS_zipFiles"), 
    pick.files = FALSE, check.size = TRUE, unzip = TRUE, saveZippedFiles = FALSE) 
{
    files <- list.files(filepath, pattern = "variables")
    if (length(files) == 0) {
        stop("Variables file is not present in specified filepath.")
    }
    variablesFile <- utils::read.csv(paste(filepath, "variables.csv", 
        sep = "/"), stringsAsFactors = FALSE)
    URLs <- variablesFile[variablesFile$dataType == "uri", ]
    allTables <- unique(URLs$table)
    URLsToDownload <- NA
    URLsNotToDownload <- NA
    if (pick.files == TRUE) {
        for (i in seq(along = allTables)) {
            suppressWarnings(tableData <- try(utils::read.csv(paste(filepath, 
                "/", allTables[i], ".csv", sep = ""), stringsAsFactors = FALSE), 
                silent = TRUE))
            if (!is.null(attr(tableData, "class")) && attr(tableData, 
                "class") == "try-error") {
                cat("Unable to find data for table:", allTables[i], 
                  "\n")
                next
            }
            URLsPerTable <- names(tableData)[names(tableData) %in% 
                URLs$fieldName]
            for (j in URLsPerTable) {
                if (j %in% URLsToDownload | j %in% URLsNotToDownload) {
                  next
                }
                resp <- readline(paste("Continuing will download", 
                  length(tableData[, j]), "files for", j, "in", 
                  allTables[i], "table. Do you want to include y/n: ", 
                  sep = " "))
                if (resp %in% c("y", "Y")) {
                  URLsToDownload <- c(URLsToDownload, tableData[, 
                    j])
                }
                else {
                  URLsNotToDownload <- c(URLsNotToDownload, tableData[, 
                    j])
                }
            }
        }
    }
    else {
        for (i in seq(along = allTables)) {
            suppressWarnings(tableData <- try(utils::read.csv(paste(filepath, 
                "/", allTables[i], ".csv", sep = ""), stringsAsFactors = FALSE), 
                silent = TRUE))
            if (!is.null(attr(tableData, "class")) && attr(tableData, 
                "class") == "try-error") {
                cat("Unable to find data for table:", allTables[i], 
                  "\n")
                next
            }
            URLsPerTable <- which(names(tableData) %in% URLs$fieldName)
            URLsToDownload <- c(URLsToDownload, unlist(tableData[, 
                URLsPerTable]))
        }
        URLsToDownload <- unique(URLsToDownload)
    }
    URLsToDownload <- URLsToDownload[!is.na(URLsToDownload)]
    if (length(URLsToDownload) == 0) {
        stop("There are no URLs other than NA for the stacked data.")
    }
    if (!dir.exists(savepath)) {
        dir.create(savepath)
    }
    cat("checking file sizes...\n")
    fileSize <- rep(NA, length(URLsToDownload))
    idx <- 0
    for (i in URLsToDownload) {
        idx <- idx + 1
        response <- httr::HEAD(i)
        fileSize[idx] <- round(as.numeric(httr::headers(response)[["Content-Length"]])/1048576, 
            1)
    }
    totalFileSize <- sum(fileSize, na.rm = TRUE)
    if (check.size == TRUE) {
        resp <- readline(paste("Continuing will download", length(URLsToDownload), 
            "files totaling approximately", totalFileSize, "MB. Do you want to proceed y/n: ", 
            sep = " "))
        if (!(resp %in% c("y", "Y"))) 
            stop()
    }
    else {
        cat("Continuing will download", length(URLsToDownload), 
            "files totaling approximately", totalFileSize, "MB.\n")
    }
    numDownloads <- 0
    pb <- utils::txtProgressBar(style = 3)
    utils::setTxtProgressBar(pb, 1/(length(URLsToDownload) - 
        1))
    for (i in URLsToDownload) {
        dl <- try(downloader::download(i, paste(savepath, gsub("^.*\\/", 
            "", i), sep = "/"), quiet = TRUE, mode = "wb"))
        if (!is.null(attr(dl, "class")) && attr(dl, "class") == 
            "try-error") {
            cat("Unable to download data for URL:", i, "\n")
            next
        }
        numDownloads <- numDownloads + 1
        utils::setTxtProgressBar(pb, numDownloads/(length(URLsToDownload) - 
            1))
        if (unzip == TRUE && grepl("\\.zip|\\.ZIP", i)) {
            utils::unzip(paste(savepath, gsub("^.*\\/", "", i), 
                sep = "/"), exdir = paste(savepath, gsub("^.*\\/|\\..*$", 
                "", i), sep = "/"), overwrite = TRUE)
            if (!saveZippedFiles) {
                unlink(paste(savepath, gsub("^.*\\/", "", i), 
                  sep = "/"), recursive = FALSE)
            }
        }
        else if (unzip == TRUE && (grepl("\\.tar\\.gz", i)) ) {
            utils::untar(paste(savepath, gsub("^.*\\/", "", i), 
                sep = "/"), exdir = paste(savepath, gsub("^.*\\/|\\..*$", 
                "", i), sep = "/"))
            if (!saveZippedFiles) {
                unlink(paste(savepath, gsub("^.*\\/", "", i), 
                  sep = "/"), recursive = FALSE)
            }
        }
        else if (unzip == TRUE && (grepl("\\.fastq\\.gz", i)) ) {
            R.utils::gunzip(paste(savepath, gsub("^.*\\/", "", i), 
                sep = "/"), remove=FALSE)
            if (!saveZippedFiles) {
                unlink(paste(savepath, gsub("^.*\\/", "", i), 
                  sep = "/"), recursive = FALSE)
            }
        }
        else if (grepl("\\.csv|\\.CSV", i)) {
            next
        }
        else if (unzip == TRUE && !(grepl("\\.zip|\\.ZIP", i) | 
            grepl("\\.tar\\.gz", i))) {
            cat("Unable to unzip data for URL:", i, "\n")
        }
    }
    utils::setTxtProgressBar(pb, 1)
    close(pb)
    cat(numDownloads, "file(s) successfully downloaded to", savepath, 
        "\n", sep = " ")
}

