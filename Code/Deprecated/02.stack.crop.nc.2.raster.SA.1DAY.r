# Compress the daily ADT to monthly ADT
# 6-10-2016 for questions contact grant.adams@eagles.usm.edu

require(raster)
require(rgdal)
require(chron)
require(ncdf4)
require(stringr)
require(dplyr)

# Import extracted masked raster files.
adt.raster.wd <-  choose.dir(caption = "Where is the ADT raster file to analyze?")
NCDF.vect <- list.files(adt.raster.wd, pattern = ".RData")

dir.create(stringr::str_replace(adt.raster.wd,"1DAY","1MON"))

# Extract data from the file name
year.label   <- substr(NCDF.vect,11,14)
day.label    <- 1
month.label  <- substr(NCDF.vect,16,17)
jul.code  <- julian(as.numeric(month.label), 
                    as.numeric(day.label), 
                    as.numeric(year.label), 
                    c(1,0,1800))

date.code <- paste(sprintf("%04.0f",as.numeric(year.label)),
                   sprintf("%02.0f",as.numeric(month.label)),
                   sprintf("%02.0f",as.numeric(day.label))
                   ,sep = ".")

# Insert leading zeros in julian code
jul.code <- sprintf("%09i", jul.code) 

date.mat <- data.frame(Raster.Name = NCDF.vect, 
                       Y = year.label, 
                       D = day.label, 
                       M = month.label, 
                       J = jul.code, 
                       DC = date.code,
                       Y.M = paste(month.label,year.label,sep = "."))
date.mat.2 <- data.frame(Y.M = unique(date.mat$Y.M), ind = seq(1,length(unique(date.mat$Y.M))))
date.mat <- left_join(date.mat, date.mat.2, by = "Y.M")

for (j in 1:max(date.mat$ind)) {
  for (k in which(date.mat$ind == j)) {
    
    if (k == which(date.mat$ind == j)[1]) {  
      load(paste0(adt.raster.wd,"\\",dir(adt.raster.wd, pattern = ".RData")[k]))  
      base.rast <- masked.raster  }
    
    if (k > which(date.mat$ind == j)[1]) {
      load(paste0(adt.raster.wd,"\\",dir(adt.raster.wd, pattern = ".RData")[k]))       
      base.rast <- overlay(base.rast, masked.raster, fun=function(x,y){return(x+y)})
    }
  }
  
  base.rast <- base.rast/length(which(date.mat$ind == j))
  raster.name <- stringr::str_replace(as.character(date.mat$Raster.Name[which(date.mat$ind == j)[1]]), "1DAY", "1MON")
  masked.raster <- base.rast  
  save(masked.raster, file = paste(str_replace(adt.raster.wd,"1DAY","1MON"),raster.name, sep = "\\"))
  plot(masked.raster)
}
