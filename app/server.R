#server

dirColors <-c("Approaching Target"="#595490", "Exceeding Target"="#527525", "Meeting Target"="#A93F35",
              "Not Meeting Target"="#BA48AA","N/A"="#eead0e")



function(input, output, session) {
    
  ################################################
  ######### View the lat and lon and id###########
  ################################################
    observe({
      event <- input$map2_marker_click
      isolate({
        print(event)
    
      })
    })
  
    output$map2 <- renderLeaflet({
    
    ################################################
    ################ filter the dataset ############
    ################################################
      
    ind=cate[(cate[,1]==input$gender) & 
               ( cate[,2]==input$age.group ) & (cate[,3]==input$weekday) & (cate[,4]==input$Time)
             ,5]
    ind=ind[1]
    #method2:
    routes_selected<-inter.list[[ind]]
    routes_selected$route.id<-as.character(routes_selected$route.id)
    routes_details<-all_routes[routes_selected$route.id]
    q<-unique(c(0,quantile(routes_selected$freq, c(.15,.30,.45,.60,.85)),Inf))
    routes_selected1<-cut(as.numeric(routes_selected$freq),q,labels=1:(length(q)-1))
    names(routes_selected1)<-routes_selected$route.id
    
    # #method1:
    # item.index=inter.list[[ind]]
    # df<-bike[item.index,]
    # routes_selected<-table(df$route.id)
    # routes_selected<-routes_selected[names(routes_selected)%in%names(all_routes)]
    # routes_selected<-sort(routes_selected,decreasing = T)[1:min(300,nrow(routes_selected))]
    # names<-names(routes_selected)
    # routes_selected<-scale(routes_selected)
    # names(routes_selected)<-names
    
    # routes_details<-all_routes[names(routes_selected)]
    # q<-unique(c(0,quantile(routes_selected,c(.15,.30,.45,.60,.85)),Inf))
    # routes_selected1<-cut(as.numeric(routes_selected),q,labels=1:(length(q)-1))
    # names(routes_selected1)<-names(routes_selected)
    
    ################################################
    ################ Generate Map ##################
    ################################################
    
    map=leaflet()%>%
      addTiles()%>%addProviderTiles("Hydda.Full")
    #addProviderTiles("Stamen.Toner")
    #addProviderTiles("OpenStreetMap.HOT")
    
    ################################################
    ################ Add routes into it ############
    ################################################
    
    for(i in names(routes_details)){
      rt<-all_routes[[i]]
      if(ncol(rt)!=5){
        used.time<-paste(round(sum(rt$minutes,na.rm = T),2),"mins")
      }else{used.time=rt$time[1]}
      freq<-as.numeric(routes_selected1[i])
      freq_original<-as.numeric(routes_selected$freq[routes_selected$route.id])
      rt.name<-paste(strsplit(i,split = "_")[[1]][-2],collapse =" to ")
      
      st.name<-strsplit(i,split = "_")[[1]][-2]
      start<-as.integer(strsplit(st.name,split = "S.")[[1]][2])
      end<-as.integer(strsplit(st.name,split = "S.")[[2]][2])
      st.name<-c(stations_info$name[stations_info$id==start],stations_info$name[stations_info$id==end])
      
      ##making popup
      poptext_route<-sprintf(
        "From <strong><font color=\"#00008b\" size=2>%s</font></strong></br>
        to <strong><font color=\"#4B0082\" size=2>%s</font></strong><br/>
        </n>
       <font color=\"#006400\">%s Trip Time: %s<br/>
        <font color=\"#006400\">%s Frequency: %s times riding<br/>
        ",
        st.name[1],st.name[2],icon("hourglass-o") ,used.time,icon("bicycle"),freq_original
        
      )
      
      poptext_station<-sprintf(
        "<strong><font color=\"#00008b\" size=3>%s</font></strong><br/>
        <strong>Station ID: %s</strong><br/>
        ",
        st.name, c(start,end)
      )
      start_end<-rt[c(1,nrow(rt)),]
      # start_end$text<-poptext_station
      
      
      
      map=map%>%addPolylines(data = rt, lng = ~lon, lat = ~lat,color="Teal",weight=freq/2,popup=poptext_route)%>%
      addMarkers(data=start_end,lng = ~lon, lat = ~lat,
                icon=list(iconUrl='icon/citi.png',iconSize=c(16,16)),group="Stations",
                label=c(stations_info$name[stations_info$id==start],stations_info$name[stations_info$id==end]),
                popup=poptext_station,
                options=marker_opt,
                layerId=c(start,end))%>%hideGroup("Stations")
                 
    }
    map%>%setView(-73.99181, 40.74373,zoom=13)
    # map%>%addPolylines(data = rt2, lng = ~lon, lat = ~lat, group = ~leg,color="Red",weight=~freq/10)%>%
    # addCircles(data=rt2[c(1,nrow(rt2)),],lng = ~lon, lat = ~lat,color="red")
    
  })
  
    observeEvent(input$Show_st,{
      if(input$Show_st==F){leafletProxy("map2") %>%hideGroup("Stations")}
      if(input$Show_st==T){leafletProxy("map2") %>%showGroup("Stations")}
    })
    
    
    ########################################
    ######### show 100 top stations #######
    ########################################
    observeEvent(input$Show_pop_st,{
        pop_poptext_station<-sprintf(
          "<strong><font color=\"#00008b\" size=3>%s</font></strong><br/>
          <strong>Station ID: %s</strong><br/>
          ",
          pop_stations_info$name, pop_stations_info$id
        )
        leafletProxy("map2") %>%clearMarkers()%>%clearShapes()%>%
          addCircles(data=pop_stations_info,lng = ~lng, lat = ~lat,radius=~Freq/500,
                     #icon=list(iconUrl='icon/citi.png',iconSize=c(16,16)),
                     group="pop_Stations",
                     label=~name,
                     popup=pop_poptext_station,
                     layerId=~id)
    })
    
    ###################################
    ##### Observe clicked stations routes #####
    ###################################
    observe({
    event <- input$map2_shape_click
    event.id<-event$id
    if (is.null(event.id))
        return()
     # event.id<-event$id
      
      print(event)
      output$Station_info<-renderUI({
        sprintf(
          "<strong><font color=\"#00008b\" size=3>%s</font></strong>(<strong>Station ID: %s</strong>)</br>
           <font color=\"#006400\",size=2>%s %s Ridings Start Here<br/>
          ",
          pop_stations_info$name[pop_stations_info$id==event.id], event.id,icon("bicycle") ,pop_stations_info$Freq[pop_stations_info$id==event.id]
        )%>% lapply(htmltools::HTML)
      })
      
      pop_st_route<-df.popular$route[df.popular$start==event.id]
      q<-unique(c(0,quantile(df.popular$Freq[df.popular$start==event.id],c(.15,.30,.45,.60,.85)),Inf))
      routes_selected1<-cut(df.popular$Freq[df.popular$start==event.id],q,labels=1:(length(q)-1))
      names(routes_selected1)<-df.popular$route[df.popular$start==event.id]
      
      leafletProxy("map2")%>%clearShapes()%>%
        addMarkers(data=stations_info[stations_info$id==event.id,],lng = ~lng, lat = ~lat,
                   icon=list(iconUrl='icon/citi.png',iconSize=c(22,22)),
                   label=stations_info$name[stations_info$id==event.id],options=marker_opt
                   )
      
      
      for(i in pop_st_route){
        rt<-all_routes[[i]]
        if(ncol(rt)!=5){
          used.time<-paste(round(sum(rt$minutes,na.rm = T),2),"mins")
        }else{used.time=rt$time[1]}
        freq<-as.numeric(routes_selected1[i])
        freq_original<-df.popular$Freq[df.popular$route==i]
        rt.name<-paste(strsplit(i,split = "_")[[1]][-2],collapse =" to ")
        
        st.name<-strsplit(i,split = "_")[[1]][-2]
        start<-as.integer(strsplit(st.name,split = "S.")[[1]][2])
        end<-as.integer(strsplit(st.name,split = "S.")[[2]][2])
        st.name<-c(stations_info$name[stations_info$id==start],stations_info$name[stations_info$id==end])
        
        ##making popup
        poptext_route<-sprintf(
          "From <strong><font color=\"#00008b\" size=2>%s</font></strong></br>
          to <strong><font color=\"#4B0082\" size=2>%s</font></strong><br/>
          </n>
          <font color=\"#006400\">%s Trip Time: %s<br/>
          <font color=\"#006400\">%s Frequency: %s times riding<br/>
          ",
          st.name[1],st.name[2],icon("hourglass-o") ,used.time,icon("bicycle"),freq_original
          
        )
        
        poptext_station<-sprintf(
          "<strong><font color=\"#00008b\" size=3>%s</font></strong><br/>
          <strong>Station ID: %s</strong><br/>
          ",
          st.name, c(start,end)
        )
        start_end<-rt[c(1,nrow(rt)),]
        leafletProxy("map2")%>%
          addPolylines(data = rt, lng = ~lon, lat = ~lat,
                       color="Teal",weight=freq/2,
                       popup=poptext_route)%>%
          # addMarkers(data=start_end,lng = ~lon, lat = ~lat,
          #            icon=list(iconUrl='icon/citi.png',iconSize=c(16,16)),group="Stations",
          #            label=c(stations_info$name[stations_info$id==start],stations_info$name[stations_info$id==end]),
          #            popup=poptext_station,
          #            layerId=c(start,end))%>%
          setView(event$lng, event$lat,zoom=13)
          
      }
      
      })
    
    ###################################
    ##### Simulations #####
    ###################################
    
    
    # generate map:
    output$map_simu=renderLeaflet({
      leaflet()%>%
        addTiles()%>%
         addProviderTiles("Hydda.Full")%>%
        #addProviderTiles("OpenStreetMap.HOT")%>%
       # addProviderTiles("Stamen.TonerLite")%>%
        setView(lng=-73.971035,lat=40.744559,zoom=13) %>%
        addCircleMarkers(
          data=stations_info,
          lng=~lng,
          lat=~lat,
          radius=0.1,
          opacity=0.5
          #color="grey"
        )
      
    })
    
    # load bicycle icon:
    # bike_icon= makeIcon("./www/icon/icons8-bicycle1.png")
    
    # riders for that date
    ridersPosi <- eventReactive(input$simuButton,{
      getRidersPositionsWithTime(bike,all_routes,as.character(input$SimuDate))
    })    
    
    # riders for that time
    ridersPosiLive <- reactive({
      ridersPosi() %>% filter(time<input$time & endtime>input$time)%>% group_by(rider) %>% top_n(1,time)
      
      
    })
    # show time
    observe({
      output$timeSelected=renderUI({
        sprintf("<i class=\"fa fa-cog\"><strong><font color=\"#00008b\">%s</strong>",as.character(format(input$time,tz="EST")))%>% lapply(htmltools::HTML)
        })
    })
    
    # update date input bar
    observe({
      min=as.POSIXct(paste(as.character(input$SimuDate),"00:00:00"),format="%Y-%m-%d %H:%M:%S",tz="EST")
      max=as.POSIXct(paste(as.character(input$SimuDate+1),"00:00:00"),format="%Y-%m-%d %H:%M:%S",tz="EST")
      value=as.POSIXct(paste(as.character(input$SimuDate),"06:00:00"),format="%Y-%m-%d %H:%M:%S",tz="EST")
      updateSliderInput(session,inputId = "time",value=value,min=min,max=max)
    })
    observe({
      
      leafletProxy("map_simu")%>% clearGroup("bikers") %>% 
        addMarkers(data=ridersPosiLive(),
                   lng=~lon,
                   lat=~lat,
                   group="bikers",
                   options=marker_opt,
                   icon=list(iconUrl='icon/icons8-bicycle3.png',iconSize=c(20,20))
        )
      
      
    })
    
    output$Weekdays <- renderPlotly({
        f <- list(
  family = "raleway",
  size = 13,
  color = "#7f7f7f"
)
       x <- list(
  title = "",
  titlefont = f
)
       y <- list(
  title = "",
  exponentformat = "none", titlefont = f
)

     plot_ly(
x = weekday.df$Var1,
y = weekday.df$Freq,
type = "bar", marker = list(color = c('rgb(158,202,225)', 'rgba(204,204,204,1)', 'rgba(204,204,204,1)','rgba(204,204,204,1)','rgba(204,204,204,1)','rgba(204,204,204,1)','rgb(158,202,225)')
)) %>%
layout(title = "Frequency of Citi Bike Use", xaxis = x, yaxis = y, font = f)
    })
    
    output$Age1 <- renderPlotly({
      f <- list(
  family = "raleway",
  size = 13,
  color = "#7f7f7f"
)
      
      x <- list(title = "Age", titlefont = f)
      
      y <- list(
        title = "",
        exponentformat = "none", titlefont = f
      )
      
      plot_ly() %>%
        add_histogram(x = male.age, name = "Male") %>%
        add_histogram(x = female.age, name = "Female") %>%
        layout(title = "Cititrip Bike Frequency by Age", barmode = "stack", bargap = 0.15, xaxis = x, yaxis = y, font = f)
    })
    
    output$Age2 <- renderPlotly({
      f <- list(
  family = "raleway",
  size = 13,
  color = "#7f7f7f"
)
      
      x <- list(title = "Age", showline = FALSE, showgrid = FALSE, titlefont = f)
      
      y <- list(
        title = "Miles",
        exponentformat = "none", titlefont = f
      )
      
      
      plot_ly(data = df.distance.mean.male, x = ~ age, y = ~ mean, name = "Male", type = "scatter", 
              line = list(color = 'rgb(205, 12, 24)', width = 2.5), mode="markers+lines") %>%
        add_trace(data = df.distance.mean.female, x = ~age, y = ~mean, name = "Female", mode = 'markers+lines', 
                  line = list(color = 'rgb(22, 96, 167)', width = 2.5)) %>%
        layout(title = "Cititrip Bike Average Distance by Age",  xaxis = x, yaxis = y, font = f)
    })
    
}
