library(ggplot2)
library(dplyr)
library(leaflet)
library(readr)
require(plyr)

getRidersPositionsWithTime=function(citibike2016,all_routes,date){
  
  
  date_stop=as.character(as.Date(date)+1)
  
  # stop= "2016-01-02"
  riders=citibike2016 %>% filter(starttime>date &stoptime<date_stop) %>% select("starttime","route.id","start station id")
  
  
  riders_routes=all_routes[riders$route.id]
  
  riders_index=1:length(riders_routes)
  
  # get rid of the riders who don't have seconds
  rider_with_seconds=sapply(riders_index,function(i){
    !is.null(riders_routes[[i]]$seconds)
  })
  riders_index=riders_index[rider_with_seconds]
  
  # get length of records of every rider
  riders_length=lapply(riders_index,function(i){
    length(riders_routes[[i]]$seconds)
  })
  riders_length=unlist(riders_length)
  # get time
  riders_routes_time=lapply(riders_index,function(i){
    cumsum(c(0,riders_routes[[i]]$seconds))+riders[i,]$starttime
  })
  
  
  # get end time
  riders_end_time=sapply(riders_routes_time,function(element){
    element[length(element)-1]
  })
  riders_routes_time=unlist(riders_routes_time)
  
  
  # get lon
  riders_routes_lon=lapply(riders_index,function(i){
    riders_routes[[i]]$lon
  })
  riders_routes_lon=unlist(riders_routes_lon)
  
  # get lat
  riders_routes_lat=lapply(riders_index,function(i){
    riders_routes[[i]]$lat
  })
  riders_routes_lat=unlist(riders_routes_lat)
  
  # get rid of NA in time
  riders_routes_time=riders_routes_time[!is.na(riders_routes_time)]
  
  
  # generate dataset
  riders_routes=list(time=riders_routes_time,lon=riders_routes_lon,lat=riders_routes_lat) %>% as.data.frame()
  riders_routes$rider=rep(riders_index,riders_length)
  riders_routes$endtime=rep(riders_end_time,riders_length)
  riders_routes=riders_routes[order(riders_routes$time),]
  
  return(riders_routes) 
}