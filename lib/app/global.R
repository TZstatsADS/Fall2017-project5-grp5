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

bike<-readRDS("~/Desktop/[ADS]Advanced Data Science/fall2017-project5-group5/data/whole_bike.rds")
load("~/Desktop/[ADS]Advanced Data Science/fall2017-project5-group5/data/route.RData")
load("~/Desktop/[ADS]Advanced Data Science/fall2017-project5-group5/data/intersect_list.RData")


