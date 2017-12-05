# Box Color
### red, yellow, aqua, blue, light-blue, green, navy, 
### teal, olive, lime, orange, fuchsia, purple, maroon, black.
#BOX TYPE:primary, success, info, warning, danger.

library(shinydashboard)
library(leaflet)
library(plotly)
library(RColorBrewer)
library(leaflet)
library("shinyBS")
library(dplyr)
library(tibble)
source("../lib/getRidersPosi.R")
bike=readRDS("../data/whole_bike.rds")
load("../data/popular_route.RData")
load("../data/intersect_list.RData")
load("../data/all_routes.RData")
load("../data/station_info.RData")
df <- readRDS("../data/citibike2016.rds")

stations_info$name<-as.character(stations_info$name)
#pop_stations_info<-stations_info[stations_info$id%in%df.popular$start,]
Age.groups <- c("Younger than 20", "20-29", "30-39", "40-49", "50-59", "60-69", "70+" )
time.categories <- c("Before Dawn: 12am-5am", "Early Morning: 5am-7am", "Morning: 7am-10am", 
                     "Noon: 10am-2pm","Afternoon: 2pm-4pm","Dusk: 4pm-7pm", 
                     "Night: 7pm-10pm","Late Night: 10pm-12am" )


marker_opt <- markerOptions(opacity=0.8,riseOnHover=T)



