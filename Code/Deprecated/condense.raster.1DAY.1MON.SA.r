condense.raster.1DAY.1MON.SA <- function() { # start function
  
  # condense.raster.1DAY.1MON.SA
  # Updated May 19, 2019
  # Maintained by R.Leaf, robert.t.leaf@gmail.com
  # University of Southern Mississippi, Gulf Coast Research Lab
  
  # This function 
  
  require(chron)
  require(ncdf4)
  require(raster)
  require(stringr)
  require(dplyr)
  
  index.name.1 <- "ADT_"
  index.name.2 <- "1MON"
  index.name.3 <- "SA"
  
  # Determine the location of the .nc files
  RAST.wd <- choose.dir(caption = "Where are the .RData files to analyze?")
  RAST.vect <- dir(RAST.wd, pattern = ".RData")
  
  # Extract data from the file name
  year.label   <- substr(RAST.vect,11,14)
  day.label    <- 1
  month.label  <- substr(RAST.vect,16,17)
  
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
  
  date.mat <- data.frame(Year = as.numeric(year.label), 
                         Day = as.numeric(day.label), 
                         Month = as.numeric(month.label), 
                         M.Y = paste(month.label,year.label, sep = "."),
                         Jul. = jul.code,
                         Date = date.code,
                         RAST.vect)
  
  M.Y <- paste(month.label,year.label, sep = ".")
  date.merge <- data.frame(M.Y = unique(M.Y), ind.j = seq(1,length(unique(M.Y))))
  date.mat <- left_join(date.mat,date.merge, by = "M.Y")
  
  # Create sub-directory                                                                                                                # Set and create new directories
  RAST.wd.new <- stringr::str_replace(RAST.wd, "1DAY", "1MON")
  suppressWarnings(dir.create(RAST.wd.new))
  
  for (j in 1:length(unique(date.mat$ind.j))) {
    
    ind <- which(date.mat$ind.j == j)
    file.string <- paste(RAST.wd.new,as.character(date.mat$RAST.vect[1]), sep = "\\")
    
    rast.stack <- stack()
    for (k in 1:length(paste(RAST.wd,as.character(date.mat$RAST.vect[ind]),sep = "\\"))) {
      in.rast <- paste(RAST.wd,as.character(date.mat$RAST.vect[ind]),sep = "\\")[k]
      in.rast <- paste0("file:///",gsub("\\", "/", in.rast, fixed=TRUE))
      
      load(in.rast)
      rast.stack <- stack()
      
    }
  }
}
  