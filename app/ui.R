
header <- dashboardHeader(
  title = "Citi Bikes in NYC",disable = TRUE
)

sidebar <- dashboardSidebar(collapsed = T,width =200,disable = TRUE,
                            sidebarMenu(
                              menuItem("None", tabName = "None", icon = icon("map"))
                            ))


body <- dashboardBody(
  
  navbarPage(strong(icon("bicycle"),"NYC Citi Bike",style="color: #FFFFFF;"), theme="styles.css",position = c("fixed-top"),

             ########################
             ##### 1.INTRO TAB ######
             ########################
             tabPanel(strong(icon("bookmark-o"),"Intro"),div(id="bg",
                                                             absolutePanel(width=1200,left=50,right=30,top=70,
                                                                           id = "intro", class = "panel panel-default", fixed = TRUE , draggable = F,
                                                                           height = 600,
                                                                           
                                                                           h2("Project 5: an RShiny app for NYC CitiBike "),
                                                                           p(" CitiBike, New York City's bike share system, is extremely popular among New Yorkers. We built an RShiny app to visualize the CitiBike's historical rent data, recommend routes for riders, simulate riding every day based on data in 2016. At the same time, we provide some insights between the weather and the number of rents per day according to CitiBike's historical rent data from 2013 to 2017. These information can provide insights about customer consumption habits for Citi Bike company and help to optimize company resources. "),
                                                                           h2("Content"),
                                                                           h4(icon("map"),"Stations"),
                                                                           p(""),
                                                                           h4(icon("balance-scale"),"Routes"),
                                                                           p(""),
                                                                           h4(icon("star"),"Analysis"),
                                                                           p(""),
                                                                           h4(icon("bar-chart"),"Summary"),
                                                                           h4(icon("area-chart"),"Summary2"),
                                                                           p("")
                                                                           
                                                             )
             )),
             
             
             ##############################
             ###### 2. Route Tab ########
             ##############################
             tabPanel(strong(icon("map"),"Bike Route"),
                      hr(),
                      div(leafletOutput("map2", height = 700)),
                      absolutePanel( id = "controls", class = "panel panel-default", fixed = TRUE
                                     , draggable = T,top = 90, left = 60, right = "auto", bottom = "auto", width = 300,
                                     height = 'auto',
                                     
                                     h4(strong("Explore the Popular Routes",style="color:grey;")),
                                     h5("Change the Features to Find Popular Routes",style="color:grey;"),
                                     p(""),
                                     p(""),
                                     selectInput("weekday", strong(icon("calendar"),"Weekdays or Weekend",style="color:DarkCyan"),
                                                 choices = c("All","Weekdays","Weekend"), 
                                                 selected = "Weekend",
                                                 width = 250),
                                     
                                     selectInput("gender", strong(icon("female"),"Gender",style="color:DarkRed"),
                                                 choices = c("All","Female"="2","Male"="1"), 
                                                 selected = "Female",
                                                 width = 250),
                                     
                                     # selectInput("snow", strong(icon("hand-o-right"),"Snow or Not",style="color:LightSeaGreen"),
                                     #             choices = c(" ","snow","no snow"), selected = " ",width = 330),
                                     
                                     selectInput("age.group", 
                                                 strong(icon("line-chart"),"Age Group",style="color:DarkSlateGray"),
                                                 choices = c("All",Age.groups), 
                                                 selected = "20-29",
                                                 width = 250),
                                     
                                     selectInput("Time", strong(icon("clock-o"),"Time",style="color:DarkSlateBlue"),
                                                 choices =c("All",time.categories), 
                                                 selected = "Early Morning: 5am-7am",
                                                 width = 250),
                                     checkboxInput("Show_st", "Show Stations",F),
                                     p("Click The Routes" ,style="color:grey;"),
                                     p("It will show your the related information ",style="color:grey;")
                                     
                                     
                      ),
                      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE
                                    , draggable = T,top = 120, left = "auto", right = 50, bottom = "auto", width = 350,
                                    height = 'auto',
                                    #column(width=6,
                                    h4(strong("Popular Routes for ",style="color:grey;")),
                                    h4(strong("     Popular Start Stations",style="color:grey;")),
                                    actionButton("Show_pop_st", "Show Top 100 Popular Stations"),
                                    h5("Click The Station You Want To Know ",style="color:grey;"),
                                    uiOutput("Station_info")
                                    #plotlyOutput("plot_radar",height = 400)
                                    
                                    #)
                      )
                      
             ),
             
             ##############################
             ###### 3. Simulation Tab #######
             ##############################
             tabPanel(id="simuTab",strong(icon("search"),"Where are riders?",style="margin-right:0px"),
                      hr(),
                      div(leafletOutput("map_simu", height = 700)),
                      absolutePanel( id = "controls", class = "panel panel-default", fixed = TRUE
                                     , draggable = T,top = 100, left = 50, right = "auto", bottom = "auto", width = 230,
                                     height = 'auto',style="padding-left:2px;padding-right:0",
                                     p(),
                                     tags$h4("Bikers Positions Every Minute"),
                                     column(width=10,dateInput(inputId="SimuDate",label=strong(icon("calendar"),"Choose Date",style="color:DarkSlateGray"), value = "2016-01-01", min = "2016-01-01", max ="2016-12-31",
                                                               format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                                                               language = "en", width = NULL),
                                            style="margin-right:0px;padding-right:0px"),
                                     
                                     column(width=2,
                                            style = "margin-top: 30px;display:inline-block;margin-right: 0px;margin-left: 0px;left:0px;bottom:5px;padding-left:0px",
                                            actionButton("simuButton",label="Go",
                                                         style="padding-left:0px;")
                                            #,style="padding:12px; font-size:100%;color: #fff; background-color: #337ab7; border-color: #2e6da4")
                                     ),
                                     column(width = 12, 
                                            sliderInput("time",label=strong(icon("clock-o"),"Time range",style="color:DarkSlateBlue"),
                                                        min = as.POSIXct("2016-01-01 00:00:00",tz="EST"),
                                                        max = as.POSIXct("2016-01-02 00:00:00",tz="EST"),
                                                        value =as.POSIXct("2016-01-01 06:00:00",tz="EST"),
                                                        step=60,
                                                        animate = animationOptions(interval =100, loop = FALSE, playButton = icon("play"),
                                                                                   pauseButton = icon("pause"))
                                            )
                                            
                                     )
                                     
                      ),
                      
                     
                      
                      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE
                                    , draggable = T,top = 100, right = 30, bottom = "auto", width = 200,
                                    height = 'auto',
                                    uiOutput("timeSelected")
                                    
                      )
                      
                      
                      
             ),
             
             ##############################
             ###### 4. Analysis Tab #######
             ##############################
             tabPanel(strong(icon("star"),"Analysis"),
                      mainPanel(width=12,
                                img(src="./img/LR_predicted.png",height=400,width=860),
                                img(src="./img/RF-predicted.png",height=400,width=860),
                                img(src="./img/GBM_predicted.png",height=400,width=860),
                                img(src="./img/RF_importance.png",height=400,width=860),
                                img(src="./img/GBM_influence.png",height=400,width=860),
                                img(src="./img/Tree_1.png",height=400,width=860),
                                img(src="./img/Tree_2.png",height=400,width=860)
                      )),
             
             ##############################
             ###### 5. Summary1 Tab ########
             ##############################
             tabPanel(strong(icon("bar-chart"), "Summary1"), 
                      mainPanel(
                        plotlyOutput("Weekdays")
                      )
             ),
             ##############################
             ###### 6. Summary2 Tab ########
             ##############################
             tabPanel(strong(icon("area-chart"), "Summary2"), 
                      mainPanel(
                        plotlyOutput("Age1"), 
                        plotlyOutput("Age2")
                      ))
             
  )
)







dashboardPage(
  header,
  sidebar,
  body
)
