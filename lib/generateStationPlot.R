library(ggplot2)
library(dplyr)
library(leaflet)
#author: Pinren Chen

#This function is used to generate scatter plot of station use. 
#Input: citibike dataframe, stations dataframe, start of interval, end of interval
#Return: a leaflet map of stations use scatter plot

generateStationPlot=function(citibike_df,stations_info,start="2016-1-1",stop="2016-12-31"){
  
  stations=citibike_df %>% filter(starttime>start & stoptime<stop) %>% select("start station id")
  #print(stations)
  stations_count_table=table(stations)
  stations_count=data.frame(stations_count_table)
  names(stations_count)=c("id","count")
  
  stations_count=merge(x=stations_count,y=stations_info,by="id",all.x=TRUE)
  
  # adjust radius
  stations_count$radius=stations_count$count/max(stations_count$count)*10
  #print(stations_count)
  leaflet()%>%addTiles() %>%
    addCircleMarkers(
      data=stations_count,
      radius=~radius,
      lng=~lng,
      lat=~lat,
      stroke=FALSE,
      fillOpacity = 0.5
    )
}
