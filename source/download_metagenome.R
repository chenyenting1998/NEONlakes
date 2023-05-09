# 2022/05/03
# Yen-Ting Chen
# Download NEON metagenome data from a vector of urls into one file path in the client
# mms_swRawDataFiles: The metadata downloaded by neonUtilities::loadByProduct() 
# folder_path: provide a path for the downloaded data
# script partially written by Chat-GPT

download_metagenome <- function(RawDataFiles, folder_path) {
  
  # check variable class
  if (is.data.frame(RawDataFiles) && is.character(folder_path)){
    cat("Start downloading NEON metagenome", sep = "\n")
 
    # extract variables
    url_list <- RawDataFiles$rawDataFilePath
    dnaSampleID <- RawDataFiles$dnaSampleID
    
    if(length(url_list) != length(unique(url_list))){
      cat(
        paste0(length(unique(url_list)), " out of ", length(url_list), " is unique.", sep = "\n")
        )
    }else{
      cat("All URL paths are unique.", sep = "\n")
    }
    
    for (url in unique(url_list)) {
      current_num <- match(url, unique(url_list))
      # show progress
      cat(paste0("Progress: ", current_num, "/", length(unique(url_list))), sep = "\n")
      
      # Extract the file name from the URL
      file_name <- basename(url)
      
      # # create unique filenames by concatenating dnaSampleID with the filename
      # file_name_unique <- paste0(dnaSampleID[current_num], "-", file_name)
      
      # Set the file path and name where you want to save the downloaded file
      # file_path <- paste0(folder_path, file_name_unique)
      file_path <- paste0(folder_path, file_name)
      
      # Use the download.file() function to download the file from the URL to your local machine
      download.file(url, destfile = file_path, mode = "wb")
    }
    cat("Finish downloading", sep = "\n")
  } else {
    stop("Check variable class()")
  }
}

