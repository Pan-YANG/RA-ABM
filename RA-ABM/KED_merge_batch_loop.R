library(sp)
library(gstat)
library(automap)
setwd("C:/Users/hippo/Documents/research/SmartRain/manuscripts/active_management/codes")
loop_ID <- commandArgs(trailingOnly=TRUE)
data.grid=read.csv(sprintf('radar_rainfall_%s.csv',loop_ID[1]))
coordinates(data.grid)=~x+y
gridded(data.grid)=TRUE
##

data.gauge=read.csv(sprintf('gauge_rainfall_%s.csv',loop_ID[1]))
data.crowd=read.csv(sprintf('crowd_rainfall_%s.csv',loop_ID[1]))
data.gauge_crowd=read.csv(sprintf('gauge_crowd_rainfall_%s.csv',loop_ID[1]))

##
coordinates(data.gauge)=~x+y
coordinates(data.crowd)=~x+y
coordinates(data.gauge_crowd)=~x+y

## KED with radar

# gauge and crowd
KEDgauge_crowd.vgm=variogram(obs~radar,data.gauge_crowd)
KEDgauge_crowd.fit=fit.variogram(KEDgauge_crowd.vgm,model=vgm("Mat"),fit.kappa=TRUE)
KEDgauge_crowd.kriged=tryCatch({
  krige(obs~radar,data.gauge_crowd,data.grid,model=KEDgauge_crowd.fit)
}, error=function(e){
  KEDgauge_crowd.auto=autoKrige(obs~radar,data.gauge_crowd,data.grid)
  KEDgauge_crowd.auto$krige_output
})

pred_export=cbind(KEDgauge_crowd.kriged$var1.pred)

var_export=cbind(KEDgauge_crowd.kriged$var1.var)

write.csv(pred_export,sprintf('pred_export_%s.csv',loop_ID[1]))
write.csv(var_export,sprintf('pred_var_%s.csv',loop_ID[1]))





