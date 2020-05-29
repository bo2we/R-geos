# This R script is used to clip a very large raster using shapefiles
# Bowei Chen @ 2018, contact: rs.cbw@foxmail.com

library(raster)
library(rgeos)
library(rgdal)
library(caTools)

# raster file
#ccd1 <- stack("F:/ccd/ccd/XL-1DOM.tif")
ccd1 <- stack("D:/clip_ccd1.tif")
ccd1 <- ccd1[[1:3]]

# shapefile
c <- readOGR("data/shp/top.shp", layer = "top")
c1 <- readOGR("data/shp/top-_641000_5140000.shp", layer = "top-_641000_5140000")
#c2 <- readOGR("data/shp/botm.shp", layer = "botm")

# have a look at the shape
plot(c)
plot(c1, add = T)

#selects a single polygon
single <- c1

# using built-in parallelization
beginCluster()

# crops the raster to the extent of the polygon, I do this first because it speeds the mask up
system.time(
  clip1 <- crop(ccd1, extent(single))
)


# crops the raster to the polygon boundary
system.time(
  clip2 <- mask(clip1,single)
)

# display the result
plotRGB(clip2)

# write 8-bit format tiff file
writeRaster(clip2,filename='D:/clip_ccd_641000_5140000.tif', format="GTiff", datatype = "INT1U", overwrite=TRUE)

endCluster()


library(data.table)

tt <- fread("data/lidar2.txt")
tt[,4:6]=round(tt[,4:6]/255)

names(ttt) <- c("x", "y", "z", "R", "G", "B")

fwrite(tt, "lidar_color2.txt")
