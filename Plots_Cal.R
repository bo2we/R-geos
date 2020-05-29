library(stringi)
library(openxlsx)

# read the plot files
setwd('D:/LD/AGB')


df <- matrix(nrow = 24, ncol = 6)


for(i in 1 : 24){
  
  dat <- read.xlsx("2012MJG.xlsx", sheet = i)
  
  idx <- which(dat[c('状态')] == '死')
  
  dat <- dat[-idx,]
  
  dat$Height <-as.numeric(dat$Height)
  
  area = dat$size[1]

  # get height and DBH
  h = dat$Height
  dbh = dat$DBH
  Height2base = dat$Height2base
  
  # calculate mean DBH
  mean.dbh = mean(dbh, na.rm = T)
  mean.dbh = round(mean.dbh, 1)
  
  # calculate mean height
  mean.h = mean(h, na.rm = T)
  mean.h = round(mean.h, 1)
  
  # calculate max height
  max.h = max(h, na.rm = T)
  max.h = round(max.h, 1)
  
  # calcuate stem density (/ha)
  stem.density = length(dat$ID)/area
  stem.density = round(stem.density, 1)
  
  # calcuate height to base crown
  #Height2bc = max(Height2base, na.rm = T)
  #Height2bc = round(Height2bc, 1)
  
  ##################### calcuate biomass #####################
  
  # 1st - 落叶松
  idx1 = grep(pattern = "落叶松", dat$Species)
  b1 = dat[idx1,]
  agb1 =  0.0277*b1$DBH^2.793
  
  # 2nd - 白桦
  idx2 = grep(pattern = "白桦", dat$Species)
  b2 = dat[idx2,]
  agb2 = 0.1905*b2$DBH^2.262
  
  # 3rd - 山杨
  idx3 = grep(pattern = "山杨", dat$Species)
  b3 = dat[idx3,]
  agb3 = 0.5053*b3$DBH^1.961
  
  # 4th - 银柴
  # http://www.ixueshu.com/document/3951708ac0a6a36d318947a18e7f9386.html
  idx4 = grep(pattern = "银柴", dat$Species)
  b4 = dat[idx4,]
  agb4 = 0.5137*((b4$DBH^2)*b4$Height)^0.8827
  
  # 5th - 木荷
  # https://wenku.baidu.com/view/c94c3330eefdc8d376ee326b.html
  idx5 = grep(pattern = "木荷", dat$Species)
  b5 = dat[idx5,]
  agb5 = 0.3349*b5$DBH^2.3151
  
  # 6th - 乌饭
  idx6 = grep(pattern = "乌饭", dat$Species)
  b6 = dat[idx6,]
  agb6 = 0.4429*b6$DBH^2.2079
  
  # 7th - 黄檀类
  # http://www.ixueshu.com/document/ddd4be123c77e99b318947a18e7f9386.html
  idx7 = grep(pattern = "檀", dat$Species)
  b7 = dat[idx7,]
  agb7 = -190.668+23.631*b7$DBH-0.208*b7$DBH^2
  
  # 8th - 毛枝青冈
  # https://wenku.baidu.com/view/c94c3330eefdc8d376ee326b.html
  idx8 = grep(pattern = "青冈", dat$Species)
  b8 = dat[idx8,]
  agb8 = 0.0617*((b8$DBH^2)*b8$Height)+2.9528
  
  # 9th - 云南蜜花树
  idx9 = grep(pattern = "蜜花树", dat$Species)
  b9 = dat[idx9,]
  agb9 = 0.4429*b9$DBH^2.2079
  
  # 10th - 楠木
  # http://www.ixueshu.com/document/a521ee7b0b359554318947a18e7f9386.html
  idx10 = grep(pattern = "楠", dat$Species)
  b10 = dat[idx10,]
  agb10 = 10^(0.9599*log10((b10$DBH^2)*b10$Height)-1.3695)
  
  # remaining species as general broadleaf
  idx = list(idx1, idx2, idx3, idx4, idx5)
  idx = unique(Reduce(c, idx))
  br = dat[-idx,]
  agbr = 0.3349*br$DBH^2.3151
  
  # add altogether
  agb = sum(agb1, agb2, agb3, agb4, agb5, agb6, agb7, agb8, agb9, agb10, agbr, na.rm = T)/1000
  agb = agb/area
  agb = round(agb, 2)
  
  
  df[i,1] = i
  df[i,2] = agb
  df[i,3] = mean.dbh
  df[i,4] = mean.h
  df[i,5] = max.h
  df[i,6] = stem.density
  
  }


colnames(df) = c('ID', 'AGB', 'Mean DBH', 'Mean height',	'Max Height', 'stem density')

write.csv(df, '2014_cal.csv', row.names = FALSE)

