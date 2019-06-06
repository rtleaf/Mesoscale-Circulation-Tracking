# Mesoscale-Circulation-Tracking

Origniated and modified from https://github.com/grantdadams.

This code:

1. 

This code takes geotiff SSH data in the form of a RData rasterstack and identifies areas of cyclonic and anti-cyclonic regions and their respestive border regions following the methodology of Domingues et al. (2016). The output is a rasterstack labelled "mesoscale.features.raster.stack" and a rasterstack of the geostrophic velocities labelled "geostrophic_velocity.RData". 

The features are labeled as: 1 = cyclonic region, 2 = cyclonic boundary region, 3 = common waters, 4 = anti-cyclonic boundary region, 5 = anti-cyclonic region.

Domingues R, Goni G, Bringas F, et al (2016) Variability of preferred environmental conditions for Atlantic bluefin tuna (Thunnus thynnus) larvae in the Gulf of Mexico during 1993-2011. Fish Oceanogr 25:320–336. doi: 10.1111/fog.12152

# Example

![alt text](https://github.com/rtleaf/Mesoscale-Circulation-Tracking/blob/master/4-panel-mesocirculation-panel.png "Example")