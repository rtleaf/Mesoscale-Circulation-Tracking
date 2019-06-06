# Function subset either daily or monthly .RData using a shape file.
# The shapefile is used to extract only those cells inside the shapefile.
# Because this subset is small it is able to be stacked. 
# The raster stack is saved as 'ssh_stack.Rdata'
# These data are used in G. Adams code 'Mesoscale Circulation Tracking.R'

# The default shapefile is the Gulf of Mexico

# 05.24.2019 Robert Leaf
# Maintained by R.Leaf, robert.t.leaf@gmail.com
# University of Southern Mississippi

require(raster)
require(rgdal)

# Define the study area
extent.shape <- readOGR("C:/Users/w906282/Dropbox/SHP files/LME-Gulf_of_Mexico.shp")

# Select the folder where the raster SSHA data are  
# ssha.raster.wd <- choose.dir(, caption = "Where are the SSHA raster files to analyze?")
# Select the folder where the raster MDT data are  
# mdt.raster.wd <- choose.dir(, caption = "Where is the MDT raster file to analyze?")

adt.raster.wd <-  choose.dir(caption = "Where is the ADT raster file to analyze?")

adt.raster.stack <- raster::stack()
nrow.val <- length(dir(adt.raster.wd, pattern = ".RData"))
catalog.df <- data.frame(D = rep(NA, nrow.val),
                M = rep(NA, nrow.val),
                Y = rep(NA, nrow.val),
                J = rep(NA, nrow.val))

for (j in 1:length(dir(adt.raster.wd, pattern = ".RData"))) {
  
  load(paste0(adt.raster.wd,"\\",dir(adt.raster.wd, pattern = ".RData")[j]))
  
  masked.raster <- crop(masked.raster, extent.shape)
  masked.raster <- mask(masked.raster, extent.shape)
  plot(masked.raster, main = dir(adt.raster.wd, pattern = ".RData")[j])
  adt.raster.stack <- stack(adt.raster.stack, masked.raster)
  print(paste(j,"of",length(dir(adt.raster.wd, pattern = ".RData"))))
  
  catalog.df$D[j] <- substr(dir(adt.raster.wd, pattern = ".RData")[j],19,20)
  catalog.df$M[j] <- substr(dir(adt.raster.wd, pattern = ".RData")[j],16,17)
  catalog.df$Y[j] <- substr(dir(adt.raster.wd, pattern = ".RData")[j],11,14)
  catalog.df$J[j] <- substr(dir(adt.raster.wd, pattern = ".RData")[j],35,43)
  
}

# Save
ssh.stack <- adt.raster.stack

save.stack.1 <- substr(adt.raster.wd, nchar(adt.raster.wd) - 3, nchar(adt.raster.wd))
save.stack <- paste0("Data/",save.stack.1,".ssh_stack.RData")
save(ssh.stack, file = save.stack)
write.csv(catalog.df, paste0("Data/",save.stack.1,".ssh_stack.csv"))
