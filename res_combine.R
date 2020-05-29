
setwd('D:/LD/terr/out')

files = list.files(pattern = ".csv")
n <- length(files)

y  <- NULL

for (i in 1:n){ 
  tmp <- read.csv(file = files[i])
  tmp <- tmp[1:nrow(tmp),]
  y <- rbind(y, tmp)
}

#header = c('ID','R', 'AGB', 'Mean DBH', 'Mean height',	'Max Height', 'stem density')
#colnames(y) = header

write.csv(y, 'Terr_summary.csv', row.names = FALSE)
