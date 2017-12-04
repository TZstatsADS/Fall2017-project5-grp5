#citibike_2016=read.csv("2016-citibike-tripdata.csv")

#load('2016citibike_weekday.RData')

#weather_data=read.csv("weather_data_nyc_2016.csv")
#weather_data=data.frame(weather_data[,c(1:8)])
#weather_data$DATE=as.POSIXct(weather_data$DATE,format="%m/%d/%Y")
#weather_data$DATE=format(weather_data$DATE,format="%m/%d/%Y")

#test
#format(weather_data$DATE[1],format="%m/%d/%Y")==format(bike_test$starttime[1:100],format="%m/%d/%Y")

########2013
citibike_2013=read.csv("2013-citibike-tripdata.csv")
citibike_2013=citibike_2013[,1:2]
citibike_2013$DATE=as.POSIXct(citibike_2013$starttime)
citibike_2013$DATE=format(citibike_2013$DATE,format="%m/%d/%Y")
citibike_2013$RENT=1

citibike_2013_daily=aggregate(cbind(RENT,tripduration)~DATE, data = citibike_2013, FUN = sum)
write.csv(citibike_2013_daily,"citibike_2013_daily.csv")


########2014
citibike_2014=read.csv("2014-citibike-tripdata.csv")
citibike_2014=citibike_2014[,1:2]
citibike_2014$DATE=as.Date((citibike_2014$starttime),format='%m/%d/%Y')
citibike_2014$DATE=format(citibike_2014$DATE,format="%m/%d/%Y")

citibike_2014$RENT=1

citibike_2014_daily=aggregate(cbind(RENT,tripduration)~DATE, data = citibike_2014, FUN = sum)
write.csv(citibike_2014_daily,"citibike_2014_daily.csv")

########2015
citibike_2015=read.csv("2015-citibike-tripdata.csv")
citibike_2015=citibike_2015[,1:2]
citibike_2015$DATE=as.Date((citibike_2015$starttime),format='%m/%d/%Y')
citibike_2015$DATE=format(citibike_2015$DATE,format="%m/%d/%Y")

citibike_2015$RENT=1

citibike_2015_daily=aggregate(cbind(RENT,tripduration)~DATE, data = citibike_2015, FUN = sum)
write.csv(citibike_2015_daily,"citibike_2015_daily.csv")

########2016
citibike_2016 <- readRDS("whole_bike.rds")
citibike_2016=citibike_2016[,1:2]

citibike_2016$DATE=format(citibike_2016$starttime,format="%m/%d/%Y")
citibike_2016=citibike_2016[,1:2]
citibike_2016$DATE=as.POSIXct(citibike_2016$starttime)
citibike_2016$DATE=format(citibike_2016$DATE,format="%m/%d/%Y")
citibike_2016$RENT=1

citibike_2016_daily=aggregate(cbind(RENT,tripduration)~DATE, data = citibike_2016, FUN = sum)
write.csv(citibike_2016_daily,"citibike_2016_daily.csv")

########2017

citibike_2017=read.csv("2017-citibike-tripdata.csv")
citibike_2017=citibike_2017[,1:2]


citibike_2017$DATE=as.POSIXct(citibike_2017$starttime)
citibike_2017$DATE=format(citibike_2017$DATE,format="%m/%d/%Y")
citibike_2017$RENT=1
colnames(citibike_2017)=colnames(citibike_2016)

citibike_2017_daily=aggregate(cbind(RENT,tripduration)~DATE, data = citibike_2017, FUN = sum)
write.csv(citibike_2017_daily,"citibike_2017_daily.csv")


###########daily

citibike_daily=rbind(citibike_2013_daily,
                     citibike_2014_daily,
                     citibike_2015_daily,
                     citibike_2016_daily,
                     citibike_2017_daily)


weather_data=read.csv("weather_2011_2017.csv")
#weather_data=data.frame(weather_data[,c(1:8)])
weather_data$DATE=as.POSIXct(weather_data$DATE,format="%m/%d/%Y")
weather_data$DATE=format(weather_data$DATE,format="%m/%d/%Y")

citibike_daily$id  <- 1:nrow(citibike_daily)
citibike_daily_weather=merge(x = citibike_daily, y = weather_data, by = "DATE", all.x = TRUE)
citibike_daily_weather=citibike_daily_weather[order(citibike_daily_weather$id), ]

save(citibike_daily_weather,file="citibike_daily_weather.RData")
write.csv(citibike_daily_weather,"citibike_daily_weather.csv")
