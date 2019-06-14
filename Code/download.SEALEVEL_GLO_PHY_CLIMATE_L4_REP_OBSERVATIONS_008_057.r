download.SEALEVEL_GLO_PHY_CLIMATE_L4_REP_OBSERVATIONS_008_057 = 
  function(target.dir = c(),
           username = c(),    # Use your Copernicus user name
           pw = c()) {        # Use your Copernicus password  
  
  # Function to download SEALEVEL_GLO_PHY_CLIMATE_L4_REP_OBSERVATIONS_008_057
  # Written by R.Leaf
  # Maintained by R.Leaf, robert.t.leaf@gmail.com
  # University of Southern Mississippi, Gulf Coast Research Lab
  # May 19, 2019
  
  # Note, when using download.file, the function argument mode = "wb" must be used for .nc files to be saved properly.
    
  # Download files from:
  # COPERNICUS MARINE ENVIRONMENT MONITORING SERVICE
  # http://marine.copernicus.eu/services-portfolio/access-to-products/
    
  require(lubridate)
  
  if (is.null(target.dir)) {
    target.dir <- choose.dir(default = "", caption = "Where would you like to download the files?")
  }  
    
  # 1. Determine all candidate files available in OISST directory
  st <- as.Date("1993-01-01")
  en <- Sys.Date()
  day.seq <- seq(st, en, by = "1 day")
  rm(st,en)
  
  directory.date <- format(day.seq,"%Y")
  
  cand.files <- paste0("dt_global_twosat_phy_l4_",
                      format(day.seq,"%Y"),
                      format(day.seq,"%m"),
                      format(day.seq,"%d"),
                      "_vDT2018.nc")
  
  # 2. Determine files in the target directory
  comp.files <- list.files(path = target.dir, pattern = ".nc")
  ind.rem <- which(cand.files %in% comp.files)
  if (length(ind.rem) > 0) { 
    cand.files <- cand.files[-ind.rem] 
    directory.date <- directory.date[-ind.rem] }
  
  file.string.start = paste0("ftp://", paste(username,pw, sep = ":"), "@my.cmems-du.eu/Core/SEALEVEL_GLO_PHY_CLIMATE_L4_REP_OBSERVATIONS_008_057/dataset-duacs-rep-global-merged-twosat-phy-l4/",directory.date,"/")

  for (j in 1:length(cand.files)) {
    url.add <- paste(file.string.start, cand.files, sep = "")[j]
    targ.file <- paste(target.dir, "/", cand.files, sep = "")[j]
    download.file(url.add, targ.file, mode = "wb") }
}