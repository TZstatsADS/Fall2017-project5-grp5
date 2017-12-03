add_weekdasy_data <- function(data.rds){
  df <- readRDS(data.rds)
  df$weekday <- weekdays(as.Date(df$starttime, "%m/%d/%Y"))
  save(df, file = "2016citibike_weekday.RData")
}


# n: the most n popular start station id
find_most_popular_start_station_id <- function(rds.data = "whole_bike.rds", n = 100){
  df <- readRDS(rds.data)
  df.start.station.id <- as.data.frame(table(df$`start station id`))
  colnames(df.start.station.id) <- c('start station id', 'frequency')
  
  df.start.station.id <- df.start.station.id[order(df.start.station.id$frequency, decreasing = TRUE), ]
  start.station.id.set <- df.start.station.id$`start station id`[1:n]
  
  df2 <- table(df$`start station id`, df$`end station id`)
  df2 <- as.data.frame(df2)
  
  return(list(df2=df2, start=start.station.id.set))
}


# m: the most m popular stop station id to a specific start station id
find_most_popular_stop_station_id <- function(start.station.id, m = 200, data = df2){
  
  index <- which(data$Var1 == start.station.id)
  all.frequency <- data$Freq[index]
  all.stop.station.id <- data$Var2[index]
  
  stop.station.id.index <- order(all.frequency, decreasing = TRUE)[1:m]
  
  stop.station.id <- all.stop.station.id[stop.station.id.index]
  frequency <- all.frequency[stop.station.id.index]
  
  return(list(stop=stop.station.id, freq=frequency))
}

create_popular_route_df <- function(start.station.id.set = start.station.id.set){
  x <- c()
  y <- c()
  z <- c()
  
  for (i in start.station.id.set){
    l <- find_most_popular_stop_station_id(i)
    stop.station.id <- l$stop
    frequency <- l$freq
    
    y <- c(y, stop.station.id)
    x <- c(x, rep(as.numeric(i), length(stop.station.id)))
    z <- c(z, frequency)
  }
  
  df.popular <- data.frame(start = x, stop = y, count = z)
  save(df.popular, file="popular_route.RData")
}