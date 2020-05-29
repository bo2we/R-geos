
# This script is used to batch projecton for shapefiles
# Bowei Chen @ 2018, contact: rs.cbw@foxmail.com

if (!require("stringi")) { install.packages("stringi"); require("stringi") }
if (!require("rgdal")) { install.packages("rgdal"); require("rgdal") }


path = "data/bounds/"
outpath = "data/out/"

files <- list.files(path, pattern = ".shp")

for (i in 1: length(files)) {

  shapefile <- files[i]
  print(shapefile)
  
  shpname <- stri_sub(shapefile, 1, stri_length(shapefile)-4)
  
  shp <- readOGR(paste0(path, shpname, ".shp"), layer = shpname)
  
  proj4string(shp) <- CRS("+proj=utm +zone=52 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
  
  writeOGR(shp, ".", paste0(outpath, shpname, "_projected"), driver="ESRI Shapefile")

}
