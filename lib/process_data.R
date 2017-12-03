add_weekdasy_data <- function(data.rds){
  df <- readRDS(data.rds)
  df$weekday <- weekdays(as.Date(df$starttime, "%m/%d/%Y"))
  save(df, file = "2016citibike_weekday.RData")
}


