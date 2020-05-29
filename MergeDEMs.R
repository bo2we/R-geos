# This script is used to mosaic tif files in a folder 
# Bowei Chen @ 2018, contact: rs.cbw@foxmail.com

if (!require("gdalUtils")) { install.packages("gdalUtils"); require("gdalUtils") }
if (!require("raster")) { install.packages("raster"); require("raster") }

# uses all tiffs in the current folder
f <- list.files(path = "TIFF_DEM", pattern = ".tif$", full.names = TRUE)
plot(raster(f[101]))
# build a virtual raster file (vrt)
gdalbuildvrt(gdalfile = f, output.vrt = "dem.vrt")

# returns the raster as Raster*Object
dem <- gdal_translate(src_dataset = "dem.vrt", 
               dst_dataset = "dem.tif", 
               output_Raster = TRUE, 
               options = c("BIGTIFF=YES", "COMPRESSION=LZW"))

# assign coordinates
utmsysz51n <- "+proj=utm +zone=51 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
crs(dem) <- utmsysz51n 

# check if the coordinates are correct
dem

# display in grey colour scale
plot(dem, col = grey.colors(255))

# display in colour scale
plot(dem, col = bpy.colors(255))

# write the geotiff
writeRaster(dem, filename='0720_DEM.tif', format="GTiff", overwrite=TRUE)


plot(raster("QJY_DEM.tif"))
