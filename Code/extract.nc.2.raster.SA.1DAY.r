Extract.nc.2.raster.SA.1DAY <- function() { # start function
  
  # Extract.nc.2.raster.AV.1DAY
  # 09.08.2015 Robert Leaf
  # Maintained by R.Leaf, robert.t.leaf@gmail.com
  # University of Southern Mississippi
  
  # Function to extract daily netCDF files and write them into a subdirectory. The written files are .RData files that hold
  # an object called "masked raster". This is a carryover from previous work by Leaf in remote sensing. These are later queried
  # for cropping, masking, and mesoscale circulation tracking.
  
  require(chron)
  require(ncdf4)
  require(raster)
  require(stringr)
  
  index.name.1 <- "ADT_"
  index.name.2 <- "1DAY"
  index.name.3 <- "SA"
  
  # Determine the location of the .nc files
  netCDF.wd <- choose.dir(caption = "Where are the .nc files to analyze?")
  NCDF.vect <- dir(netCDF.wd, pattern = ".nc")

  # Extract data from the file name
  year.label   <- substr(NCDF.vect,25,28)
  day.label    <- substr(NCDF.vect,31,32)
  month.label  <- substr(NCDF.vect,29,30)
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
  
  # Create sub-directory                                                                                                                # Set and create new directories
  netCDF.wd.sub <- paste(netCDF.wd,paste("FULL",paste(index.name.3,index.name.1,index.name.2,sep = "."),sep = "_"), sep = "\\")        # Name a new directory to place the saved netCDF files
  suppressWarnings(dir.create(netCDF.wd.sub))
  NC.RAST <- paste("RAST","FULL",paste(date.code,index.name.3,index.name.1,index.name.2,jul.code,"RData",sep = "."),sep = "_")
  
  if (length(NCDF.vect) > 0)      {
    for (j in 1:length(NCDF.vect))  {
      
      print(paste("Converting .nc to raster... ",NCDF.vect[j],sep = " "))
      raster.ncdf <- ncdf4::nc_open(paste(netCDF.wd, NCDF.vect[j], sep = "\\"))
      raster.full <- flip(t(t(t(raster(ncdf4::ncvar_get(raster.ncdf,varid = "adt"))))),'y')
      
      xmin(raster.full) <- 0
      xmax(raster.full) <- 360
      ymin(raster.full) <- -90
      ymax(raster.full) <- 90  
      
      # Need to change raster x-dimension: Split the raster into two halves and rearrange them
      hemi.1 <- as.matrix(raster::crop(raster.full,c(180,360,-90,90)))
      hemi.2 <- as.matrix(raster::crop(raster.full,c(0,180,-90,90)))
      raster.full <- raster(cbind(hemi.1,hemi.2))
      
      # Re-assign the extent of the raster
      raster.extent.new <- c(-180,180,-90,90)   # Set the extent of the raster and projection
      xmin(raster.full) <- raster.extent.new[1]
      xmax(raster.full) <- raster.extent.new[2]
      ymin(raster.full) <- raster.extent.new[3]
      ymax(raster.full) <- raster.extent.new[4]
      projection(raster.full) <- NA   
      
      masked.raster <- raster.full
      
      file.name.rast <- paste(netCDF.wd.sub,NC.RAST[j], sep = "\\")
      
      save(masked.raster,file = file.name.rast)
      
      nc_close(raster.ncdf)
      
    }
  }
}  