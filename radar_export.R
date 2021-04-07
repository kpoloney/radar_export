library(dplyr)
library(jsonlite)
library(httr)
library(readr)

#read in the csv metadata export
isl <- read.csv("radar_metadata.csv", stringsAsFactors = F)


# remove collections going to summit or digital collections
sound <- isl %>% 
  filter(PID == "islandora:9880" | 
        RELS_EXT_isMemberOfCollection_uri_ms == "info:fedora/islandora:9880")
herring <- isl %>% 
  filter(PID == "islandora:262" | 
           RELS_EXT_isMemberOfCollection_uri_ms == "info:fedora/islandora:262")

other <- rbind(herring, sound)

rel <- anti_join(isl, other, by = "PID")

rm(sound, herring, other)

# remove any that are collectionCModel
rel <- rel %>%
  filter(rel$RELS_EXT_hasModel_uri_s != "info:fedora/islandora:collectionCModel")

# have the pids as a list
pid <- as.list(rel$PID)

# url for islandora
base_url <- "https://researchdata.sfu.ca"

# download objects 
for (i in 1:length(pid)) {
  
  url <- paste0(base_url, "/islandora/object/", pid[i], 
                "/datastream/OBJ/download")
  
  r <- GET(url)
  
  content_disp <- as.character(headers(r)['content-disposition'])
  filename <- gsub('"', '', regmatches(content_disp, gregexpr('"[^"]*"', content_disp))[[1]])
  #remove any unwanted characters
  filename <- gsub('/|:|#|&|"|\\s|[*]', "", filename)
  filename <- gsub("^SFU-", "", filename)
  
  id <- gsub(":", "", pid[i])
  
  content_path <- paste0(id, "_", filename)
  
  if (grepl("csv$", filename)) {
    write.csv(content(r), content_path, row.names = F)
  } else
  writeBin(content(r), content_path)

  
}
