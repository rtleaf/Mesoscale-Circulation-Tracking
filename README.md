# Mesoscale-Circulation-Tracking

Origniated and modified from https://github.com/grantdadams.

The project directory code contains a number of functions (and a script) that serve to extract and sytnthesize sea surface height data:

1. download.SEALEVEL_GLO_PHY_CLIMATE_L4_REP_OBSERVATIONS_008_057

This function downloads .nc files from the OPERNICUS MARINE ENVIRONMENT MONITORING SERVICE at http://marine.copernicus.eu/services-portfolio/access-to-products/. The function argument mode = "wb" must be used for .nc files to be saved properly. You will need to get a username and password from this site and specify a target directory for saving the .nc files.

2. Extract.nc.2.raster.AV.1DAY
  
Function to extract daily netCDF files and write them into a subdirectory. The written files are .RData files that hold an object called "masked raster". This naming convention is a carryover from previous remote sensing effort. These are later queried for cropping, masking, and mesoscale circulation tracking. The files are extracted to a subdrictory "FULL_SA.ADT_.1DAY"

3. condense.SA.1DAY.1MON (script)

Function to condense the daily extracted raster to monthly rasters, by taking the cell-specific mean values. Creates a directory from "1DAY" to "1MON".

4. stack.crop.nc.2.raster.SA (script)

Function to create a file named "ssh_stack.RData" and crop it using a shape file for the region extraction.

5. Mesoscale Circulation Tracking (lightly modified from Adams' to use data from the above sripts and functions)

From Adams': "This code takes geotiff SSH data in the form of a RData rasterstack and identifies areas of cyclonic and anti-cyclonic regions and their respestive border regions following the methodology of Domingues et al. (2016)." The output is a rasterstack labelled "mesoscale.features.raster.stack" and a rasterstack of the geostrophic velocities labelled "geostrophic_velocity.RData". "

The features are labeled as: 1 = cyclonic region, 2 = cyclonic boundary region, 3 = common waters, 4 = anti-cyclonic boundary region, 5 = anti-cyclonic region.

1MON.geostrophic_velocity.RData

1MON.mesoscale_features_raster_stack.RData

# Example

![alt text](https://github.com/rtleaf/Mesoscale-Circulation-Tracking/blob/master/4-panel-mesocirculation-panel.png "Example")