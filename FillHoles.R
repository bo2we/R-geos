library(raster)

list.files(pattern = ".tif")

tif = raster("summer_6_9_ProjectRast_33_kgha.tif")

tif = raster("spring_4_5_ProjectRast_33_kgha.tif")


plot(tif)

# tif info
tif
tif@file@nodatavalue 


tt = tif[1:tif@nrows,1:tif@ncols]
summary(tt)

tt[is.na(tt)] <- 0
tt[is.infinite(tt)] <- 0

test <-tif
test[1:test@nrows,1:test@ncols] <- tt

writeRaster(test, filename='summer_6_9_ProjectRast_33_kgha_out.tif', format="GTiff", overwrite=TRUE)
