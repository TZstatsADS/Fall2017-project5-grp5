

bike <- readRDS("~/Desktop/[ADS]Advanced Data Science/fall2017-project5-group5/data/citibike2016.rds")
bike1<-readRDS("~/Desktop/[ADS]Advanced Data Science/fall2017-project5-group5/data/citibike2016.rds")
### add route columns
bike$route.id<-paste0("S.",bike$`start station id`,"_to_S.",bike$`end station id`,sep="")
y<-ifelse(bike$`start station id`>bike$`end station id`,paste("S.",bike$`start station id`,"_to_S.",bike$`end station id`,sep=""),paste("S.",bike$`end station id`,"_to_S.",bike$`start station id`,sep=""))
bike$route.id2<-y

### transfer to date format
Sys.setenv(TZ='EST')
bike$starttime<-as.POSIXct(bike$starttime,format="%m/%d/%Y %H:%M")
bike$stoptime<-as.POSIXct(bike$stoptime,format="%m/%d/%Y %H:%M")

whole_bike<-bike
saveRDS(whole_bike,file = "~/Desktop/[ADS]Advanced Data Science/fall2017-project5-group5/data/whole_bike.rds")

### clean the station info
stations_info=data.frame(id=bike$`end station id`,name=bike$`end station name`,lat=bike$`end station latitude`,lng=bike$`end station longitude`)
stations_info=stations_info[!duplicated(stations_info$id), ]
save(stations_info,file = "~/Desktop/[ADS]Advanced Data Science/fall2017-project5-group5/data/station_info.RData")

### del the station name lon and lat
bike$`start station name`=c()
bike$`start station longitude`=c()
bike$`start station latitude`=c()
bike$`end station name`=c()
bike$`end station longitude`=c()
bike$`end station latitude`=c()


##### filter the data

bike$index<-1:nrow(bike)
Age.groups <- c("Younger than 20", "20-29", "30-39", "40-49", "50-59", "60-69", "70+" )
bike$age.group <- cut(2016-bike$`birth year`, breaks=c(0, 20, 30, 40, 50, 60, 70, 100), labels=Age.groups)

time.categories <- c("Before Dawn: 12am-5am", "Early Morning: 5am-7am", "Morning: 7am-10am", 
                     "Noon: 10am-2pm","Afternoon: 2pm-4pm","Dusk: 4pm-7pm", 
                     "Night: 7pm-10pm","Late Night: 10pm-12am" )

hour<-as.numeric(format(bike$starttime,'%H'))
bike$hour <- cut(hour, breaks=c(0, 5, 7, 10, 14, 16, 19, 22, 24), labels=time.categories )

bike$weekend<-ifelse(bike$weekday%in%c("Sunday","Saturday"),"Weekend","Weekdays")

age_group<-split(bike[,c("index")],bike$age.group)
hour_group<-split(bike[,c("index")],bike$hour)
weekend_group<-split(bike[,c("index")],bike$weekend)
gender_group<-split(bike[,c("index")],bike$gender)


cate2<-cate
x=648
inter.list2<-list()
for(i in c("All","1","2")){
if(i=="All"){a1=1:nrow(bike)}else{a1=gender_group[[i]]$index}
  a1=gender_group[["2"]]$index
  for(j in c("All",Age.groups)){
    if(j=="All"){a2=1:nrow(bike)}else{a2=age_group[[j]]$index}
    
    for(k in c("All","Weekend","Weekdays")){
      if(k=="All"){a3=1:nrow(bike)}else{a3=weekend_group[[k]]$index}
      
      for(m in c("All",time.categories)){
        if(m=="All"){a4=1:nrow(bike)}else{a4=hour_group[[m]]$index}
        x=x+1
        print(x)
        cate2<-rbind(cate2,c(i,j,k,m,x))
        b1=intersect(a1,a2)
        b2=intersect(a3,a4)
        inter.list[[as.character(x)]]=intersect(b1,b2)
      }
    }
  }
}
#cate[z,]<-cate2
save(inter.list,cate,file="~/Desktop/[ADS]Advanced Data Science/fall2017-project5-group5/data/intersect_list.RData")

###delete the rows from bike 
bike1<-bike[bike$route.id%in%names(all_routes),]
#bike_routes<-bike1

#### find popular station and routes
top100st<-sort(table(bike$`start station id`),decreasing = T)[1:100]
top100.df<-bike[bike$`start station id`%in%names(top100st),c("start station id","end station id")]
#top100.df<-top100.df%>%group_by(`start station id`,`end station id`)%>%summarise(Freq=n())
top100.tb<-table(top100.df$`start station id`,top100.df$`end station id`)
sum(rownames(top100.tb)%in%names(top100st))
df.pop100<-data.frame(start=NULL,end=NULL,Freq=NULL,route=NULL)
for(i in 1:100){
  start<-rownames(top100.tb)[i]
  vec=top100.tb[i,]
  top200<-order(vec,decreasing = T)[1:200]
  df.pop<-data.frame(start=rep(start,200),end=colnames(top100.tb)[top200],Freq=vec[top200])
  df.pop$route<-paste0("S.",df.pop$start,"_to_S.",df.pop$end,sep="")
  df.pop100<-rbind(df.pop100,df.pop)
}
sum(df.pop100$route%in%names(all_routes))
length(unique(df.pop100$start))
sum(df.pop100$start%in%names(top100st))

df.popular<-df.pop100
### popular stations
df.popular<-df.popular[df.popular$route%in%names(all_routes),]
popular_st<-unique(df.popular$start)
pop_stations_info<-stations_info[stations_info$id%in%popular_st,]
Freq<-table(bike$`start station id`[bike$`start station id`%in%popular_st])
sort(Freq)
pop_stations_info$Freq<-NA
for(i in 1:100){
  pop_stations_info$Freq[i]<-Freq[names(Freq)==as.character(pop_stations_info$id[i])]
}
# df.popular$route<-paste0("S.",df.popular$start,"_to_S.",df.popular$stop,sep="")
save(df.popular,pop_stations_info,file="~/Desktop/[ADS]Advanced Data Science/fall2017-project5-group5/data/popular_route.RData")




