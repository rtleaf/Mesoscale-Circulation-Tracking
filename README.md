# Mesoscale-Circulation-Tracking

Origniated and modified from https://github.com/grantdadams.

The project directory code contains a number of functions (and a script) that serve to extract and sytnthesize sea surface height data:

1. download.SEALEVEL_GLO_PHY_CLIMATE_L4_REP_OBSERVATIONS_008_057

Description:
This function downloads .nc files from the OPERNICUS MARINE ENVIRONMENT MONITORING SERVICE at http://marine.copernicus.eu/services-portfolio/access-to-products/. 

Usage:
The function argument mode = "wb" must be used for .nc files to be saved properly. Additionally, you will need to get a username and password [username = c(), pw = c()] from this site prior to running the code. Finally, a target directory for saving the .nc files will need to be specified. 

2. Extract.nc.2.raster.AV.1DAY
  
Description:
Function to extract daily netCDF files and write them into a subdirectory. The written files are .RData files that hold an object called "masked raster". This naming convention of the masked.raster objects is a carryover from previous remote sensing extraction and manipulation functions from R. Leaf. These are later queried for cropping, masking, and mesoscale circulation tracking. The files are extracted to a subdrictory "FULL_SA.ADT_.1DAY".

Usage: 
The function will query the user to get the daily netCDF files downloaded using the function download.SEALEVEL_GLO_PHY_CLIMATE_L4_REP_OBSERVATIONS_008_057 or downloaded using a web browser (e.g. downthemall in Firefox).

3. condense.SA.1DAY.1MON (script)

Description:
Function to condense the daily extracted raster to monthly rasters, by taking the cell-specific mean values. Creates a directory from "1DAY" to "1MON" located in the same location as the "FULL_SA.ADT_.1DAY" directory.

Usage:
The function will query the user to get the location of the "FULL_SA.ADT_.1DAY" directory.

4. stack.crop.nc.2.raster.SA (script)

Description:
Script to create a file named "ssh_stack.RData" and crop it using a shape file for the region extraction. The function stacks the masked raster in the user defined directory and crops them defined by the input shape (.shp) file. This script will need some tweaking by the user, specifically they will need to define the path for the .shp file.

Usage: 
The function will query the user to get the location of the "FULL_SA.ADT_.1DAY" or "FULL_SA.ADT_.1MON" directory.

5. Mesoscale Circulation Tracking

Description: 
The code (a script) is lightly modified from Adams' and is coded to use data from the above functions. This code does the work to determine the mescoscale features following Adams' and "identifies areas of cyclonic and anti-cyclonic regions and their respestive border regions following the methodology of Domingues et al. (2016)." The output is a rasterstack labelled "mesoscale.features.raster.stack" and a rasterstack of the geostrophic velocities labelled "geostrophic_velocity.RData". In the mesoscale feature raster stack the features are labeled as: 1 = cyclonic region, 2 = cyclonic boundary region, 3 = common waters, 4 = anti-cyclonic boundary region, 5 = anti-cyclonic region.

Usage:
The function will query the user to get the location of ssh_stack.RData.

# Example

![alt text](https://github.com/rtleaf/Mesoscale-Circulation-Tracking/blob/master/4-panel-mesocirculation-panel.png "Example")