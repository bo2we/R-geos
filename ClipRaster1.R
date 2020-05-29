# This R script is used to clip a very large raster using shapefiles
# Bowei Chen @ 2019, contact: rs.cbw@foxmail.com

library(raster)
library(rgdal)
library(viridis)
library(stringr)

path = "data/viirs/"
pathout = "output/csv/"

# raster file
f <- list.files(path = path, pattern = ".tif$", full.names = F)

# shapefile
c <- readOGR("data/bgd_admbnda_adm2_bbs_20180410/bgd_admbnda_adm2_bbs_20180410.shp",
             layer = "bgd_admbnda_adm2_bbs_20180410")

#selects a single polygon
pcode <- c$ADM2_EN

for (i in 1:length(f)) {
  
  for (j in pcode) {
  
  print(c(i, j))
    
  s <- raster(paste0(path, f[i]))
  
  nname <- str_sub(f[i], 1, str_length(f[i])-4)
  
  single <- c[c$ADM2_EN == j,]
  
  clip1 <- crop(s, extent(single))
  clip2 <- mask(clip1, single)
  
  # png(paste0('figs/NTL/', nname, '_', single@data$ADM2_EN, '.png'), height = 7, width = 7, units = 'in',  res = 300)
  # plot(clip2, col = magma(255), xlab = 'Latitude (deg.)', ylab = 'Longtitude (deg.)')
  # dev.off()
  
  # get regional values
  v <- as.data.frame(matrix(-999, nrow = 3, ncol = 4))
  names(v) <- c("district", "date", "value", "stas")
  v$district <- single@data$ADM2_EN
  v$date <- paste0(str_sub(f[i], 11, str_length(f[i])-6), "-", str_sub(f[i], 15, str_length(f[i])-4))
  v$stas <- c("sum", "max", "mean")
  v$value <- c(cellStats(clip2, 'sum'), cellStats(clip2, 'max'), cellStats(clip2, 'mean'))
  
  write.csv(v, paste0(pathout, nname, '_', single@data$ADM2_EN, '.csv'), row.names = F)
  
  # writeRaster(clip2, filename = paste0(pathout, nname, '_', single@data$ADM2_EN, '.tif'), 
  #             format = "GTiff", overwrite = TRUE)
  
  print('------------------Processed-----------------------')
  
  }
}
