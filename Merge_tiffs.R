# This script is used to mosaic tif files in a folder 
# Bowei Chen @ 2018, contact: rs.cbw@foxmail.com

if (!require("gdalUtils")) { install.packages("gdalUtils"); require("gdalUtils") }
if (!require("raster")) { install.packages("raster"); require("raster") }

# uses all tiffs in the current folder
f <- list.files(path = "WP", pattern = "_Reflectance.tif$", full.names = TRUE)
#plot(stack(f[101]))
# build a virtual raster file (vrt)
gdalbuildvrt(gdalfile = f, output.vrt = "AC.vrt")

# returns the raster as Raster*Object
dem <- gdal_translate(src_dataset = "AC.vrt", 
                      dst_dataset = "AC.tif", 
                      output_Raster = TRUE, 
                      options = c("BIGTIFF=YES"))

# assign coordinates
utmsysz51n <- "+proj=utm +zone=52 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
crs(dem) <- utmsysz51n 
writeRaster(dem, filename='Reflectance.tif', format="GTiff", overwrite=TRUE)

# check if the coordinates are correct
dem

# display in grey colour scale
plot(dem, col = grey.colors(255))

# display in colour scale
plot(dem, col = bpy.colors(255))

# write the geotiff


plot(raster("QJY_DEM.tif"))
