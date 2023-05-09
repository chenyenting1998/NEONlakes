# 2022/04/21
# Yen-Ting Chen
# Download online data from a vector of urls into one file path in the client
# url: provide a data-containing urls. Can be a vector.
# folder_path: provide a path for the downloaded data
# script written by Chat-GPT

download_url <- function(url_list, folder_path) {
  # Set the URL of the file you want to download
  
  # check variable class
  if (is.character(url_list) && is.character(folder_path)){
    
    for (url in url_list) {
      # Extract the file name from the URL
      file_name <- basename(url)
      # Set the file path and name where you want to save the downloaded file
      file_path <- paste0(folder_path, file_name)
      # Use the download.file() function to download the file from the URL to your local machine
      download.file(url, destfile = file_path, mode = "wb")
    }
  } else {
    stop("Both url and folder_path should be a vector")
  }
}

