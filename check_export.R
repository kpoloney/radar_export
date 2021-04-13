
#Purpose: check filenames against metadata list. Identify any missing files.

#Change this to path of files to be checked. getwd will set it to be the same as your working directory.
filepath <- getwd()

#Get vector of filenames. Recursive = T means that it includes files in directory folders.
dir <- list.files(filepath, recursive = T)

#select the PIDs from the file names
file_pids <- stringr::str_extract(dir, "^[[:alpha:]]{3,}[[:digit:]]{2,}_")
file_pids <- gsub("_", "", file_pids) %>% as.data.frame()
names(file_pids) <- "PID"

#Get metadata csv
metadata <- read.csv("metadata.csv", stringsAsFactors = F)
md_pids <- metadata %>% 
  filter(RELS_EXT_hasModel_uri_s != "info:fedora/islandora:collectionCModel") %>% 
  select(PID) 

md_pids$PID <- gsub(":", "", md_pids$PID)

#Join to id which are in the metadata but not the files
missing <- anti_join(md_pids, file_pids, by = "PID")


