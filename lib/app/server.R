#server
library("dplyr")
dirColors <-c("Approaching Target"="#595490", "Exceeding Target"="#527525", "Meeting Target"="#A93F35",
              "Not Meeting Target"="#BA48AA","N/A"="#eead0e")



function(input, output, session) {
  # df_selected<-reactive({
  #   if(input$Weekday==" "){
  #     s<-c(" ","Monday" ,"Tuesday" ,"Wednesday" ,"Thursday","Friday", "Saturday",  "Sunday")
  #   }
  #   
  #   if(input$Weekday=="weekend"){
  #     s<-c("Saturday",  "Sunday")
  #   }
  #   if(input$Weekday=="weekdays"){
  #     s<-c("Saturday",  "Sunday")
  #   }
  #   
  #   bike[bike$weekday%in%s]
  # })
  
  marker_opt <- markerOptions(opacity=0.8,riseOnHover=T)
  output$map2 <- renderLeaflet({
      
    ##filter the data set
      f<-which(c(input$weekday,input$gender,input$age.group,input$Time)!="ALL")
      #df<-bike
      ind=cate[(cate[,1]==input$gender) & 
                 ( cate[,2]==input$age.group ) & (cate[,3]==input$weekday) & (cate[,4]==input$Time)
               ,5]
      item.index=inter.list[[ind]]
      df<-bike[item.index,]
      routes_selected<-table(df$route.id)
      routes_selected<-routes_selected[names(routes_selected)%in%route.list1]
      routes_selected<-sort(routes_selected)[1:200]
      # names<-names(routes_selected)
      # routes_selected<-scale(routes_selected)
      # names(routes_selected)<-names
      
      routes_details<-route.list1[name(routes_selected)]
      # #f<-c(input$weekday,input$gender,input$age.group,input$Time)[f]
      # if(length(f)>0){
      #   for(i in f){
      #     if(i==1){df=df[df$weekend==input$weekday,]}
      #     if(i==2){df=df[df$gender ==input$gender,]}
      #     if(i==3){df=df[df$age.group==input$age.group,]}
      #     if(i==4){df=df[df$hour==input$Time,]}
      #   }
      # }
      ### generate map
      map=leaflet()%>%
        addTiles()%>%
        addProviderTiles("Stamen.Toner")
      #addProviderTiles("OpenStreetMap.HOT")
      #addProviderTiles("Hydda.Full")
      #for(i in df_selected$route.id2){
      for(i in names(routes_details)){
        rt<-route.list[[i]]
        if(ncol(rt)!=5){
          used.time<-paste(round(sum(rt$minutes),2),"min")
        }else{used.time=rt$time[1]}
        rt$freq<-as.numeric(cut(3,c(0,2,5,100,150,500,1000),labels=1:6))
        poptext<-paste(strsplit(i,split = "_")[[1]][-2],collapse ="-")
        map=map%>%addPolylines(data = rt, lng = ~lon, lat = ~lat,color="Turquoise",weight=~freq,popup=poptext)%>%
        addMarkers(data=rt[c(1,nrow(rt)),],lng = ~lon, lat = ~lat,icon=list(iconUrl='icon/citi.png',iconSize=c(18,18)))
      }
      map
      # map%>%addPolylines(data = rt2, lng = ~lon, lat = ~lat, group = ~leg,color="Red",weight=~freq/10)%>%
      # addCircles(data=rt2[c(1,nrow(rt2)),],lng = ~lon, lat = ~lat,color="red")
    
  })
  
} 
