
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
                                                                           h4(icon("map"),"Bike Route"),
                                                                           p(""),
                                                                           h4(icon("search"),"Where are riders?"),
                                                                           p(""),
                                                                           h4(icon("star"),"Amount of riders"),
                                                                           p(""),
                                                                           h4(icon("area-chart"), "Other analysis"),
                                                                           h4(icon("fa fa-id-card"), "About us"),
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
                                    p("Bigger circle means more ridings start here",style="color:grey;"),
                                    h5(strong("Click The Station You Want To Know ",style="color:grey;")),
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
                      tags$style(type="text/css", "
                              #loadmessage {
                                 bottom: auto;
                                 right: auto;
                                 width: 100%;
                                 padding: 5px 0px 5px 0px;
                                 text-align: center;
                                 font-weight: bold;
                                 font-size: 100%;
                                 color: #000000;
                                 z-index: 105;
                                }"),
                      conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                                       tags$div("Loading... Please Wait",id="loadmessage")
                      ),
                      div(leafletOutput("map_simu", height = 700)),
                      absolutePanel( id = "controls", class = "panel panel-default", fixed = TRUE
                                     , draggable = T,top = 100, left = 50, right = "auto", bottom = "auto", width = 280,
                                     height = 'auto',style="padding-left:2px;padding-right:0",
                                     p(),
                                     tags$h4("Riders Positions Every Minute"),
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
                                                        step=60
                                                        
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
             tabPanel(strong(icon("star"),"Amount of riders"),
                      mainPanel(width=15,
                                
                       
                        hr(),
                        hr(),
                        
                        h3(strong(icon("star"),"Amount of Riders in New York City")),
                    
                        tabsetPanel(
                          tabPanel("Monthly", 
                                   h3("The average daily amount of riders in each month (from July-2013 to June-2017):"),
                                   h4("Forecast from ARIMA(1,1,0)*(1,1,0)[12] model."),
                                   
                                   img(src="./img/Monthly_plot.png",height = 500, width = 750)),
                          tabPanel("Weekly",
                                   h3("The total amount of riders in each day of a week (2016):"),
                                   plotlyOutput("Weekdays")),
                          tabPanel("Daily",
                                   h3("The average amount of riders in each hour of one day (2016):"),
                                   h4(icon("fa fa-user-circle"),"Records of Subscribers"),
                                   img(src="./img/24h_Records_Subscribers.pdf",height = 500, width = 750),
                                   hr(),
                                   h4(icon("fa fa-user-circle-o"),"Records of Customers"),
                                   img(src="./img/24h_Records_Customers.pdf",height = 500, width = 750))),
                        
                        
                       
                        hr(),
                        
                        h3(strong(icon("star"),"Explore the Influence of Weather on the Amount of Riders")),
                        tabsetPanel(
                            tabPanel("Step 1", 
                                     h3("Question 1: Is there any relationship between the the weather and the amount of riders?"),
                                     h4(icon("fa fa-check-circle-o"),"Linear Regression: adjusted R-square: 0.55"),
                                     img(src="./img/LR_predicted.png",height=400,width=860),
                                     h4(icon("fa fa-check-circle-o"),"Random Forest"),
                                     img(src="./img/RF-predicted.png",height=400,width=860),
                                     h4(icon("fa fa-check-circle-o"),"Gradient Boosting Machine"),
                                     img(src="./img/GBM_predicted.png",height=400,width=860),
                                     h4("We can basically conclude that there is a relationship between the #rents per day and the weather of that day")),
                            tabPanel("Step 2",
                                     h3("Question 2: Which factor in the weather data has the biggest influence on the amount of riders that day?"),
                                     h4(icon("fa fa-check-circle-o"),"Random Forest Importance Table"),
                                     img(src="./img/RF_importance.png",height=400,width=860),
                                     h4(icon("fa fa-check-circle-o"),"GBM Influence Table"),
                                     img(src="./img/GBM_influence.png",height=400,width=860),
                                     h4("TMAX-maximum temperature of that day is the most important weather factor")),
                            tabPanel("Step 3",
                                     h3("Question 3: How strong this factor influence the amount of riders?"),
                                     h4(icon("fa fa-check-circle-o"),"Regression Tree"),
                                     img(src="./img/Tree_1.png",height=400,width=860),
                                     h4(icon("fa fa-check-circle-o"),"Regression Tree with CV"),
                                     img(src="./img/Tree_2.png",height=400,width=860),
                                     h4("When the temperature is below 60 degree F, the number of rents start to decrease significantly")))
                            
                                   
                      
                     )),
             ##############################
             ###### 5. Other analysis Tab ########
             ##############################
             tabPanel(strong(icon("area-chart"), "Other analysis"), 
                      mainPanel(width=15,
                        hr(),
                        hr(),
                        
                        h3(strong(icon("area-chart"),"Analysis of Trip Duration")),
                        tabsetPanel(
                          
                          tabPanel("Subscribers", 
                                   h3("Subscribers' Trip Duration Distribution of Each Month (2016):"),
                                   img(src="./img/tripduration_Subscribers.pdf",height = 500, width = 750)),
                          tabPanel("Customers",
                                   h3("Customers' Trip Duration Distribution of Each Month (2016):"),
                                   img(src="./img/tripduration_Customers.pdf",height = 500, width = 750))),
                          
                        hr(),
                        
                        h3(strong(icon("area-chart"),"Analysis of Users by Gender and Age")),
                        tabsetPanel(
                          
                          tabPanel("Average Trip Distance", 
                                   h3("Users' Trip Distance by gender and age (2016):"),
                                   plotlyOutput("Age2",height = 500, width = 750)),
                          tabPanel("Amount of riders",
                                   h3("Amount of riders by gender and age(2016):"),
                                   plotlyOutput("Age1",height = 500, width = 750)))
                        
                      )),
             
             ##############################
             ###### 6. About us Tab ########
             ##############################
             tabPanel(strong(icon("fa fa-id-card"), "About us"), 
                      div(id="bg",
                          absolutePanel(width=1200,left=50,right=30,top=70,
                                        id = "intro", class = "panel panel-default", fixed = TRUE , draggable = F,
                                        height = 600,
                                        
                                        h2("Project 5: an RShiny app for NYC CitiBike "),
                                        p(" CitiBike, New York City's bike share system, is extremely popular among New Yorkers. We built an RShiny app to visualize the CitiBike's historical rent data, recommend routes for riders, simulate riding every day based on data in 2016. At the same time, we provide some insights between the weather and the number of rents per day according to CitiBike's historical rent data from 2013 to 2017. These information can provide insights about customer consumption habits for Citi Bike company and help to optimize company resources. "),
                                        h2("Group members:"),
                            
                                        p(""),
                                        h4(icon("fa fa-address-book"),"Hongyang Yang (hy2500)"),
                                        p(""),
                                        h4(icon("fa fa-address-book"),"Pinren Chen (pc2751)"),
                                        p(""),
                                        h4(icon("fa fa-address-book"),"Siyi Tao (st3036)"),
                                        p(""),
                                        h4(icon("fa fa-address-book"),"Xin Gao (xg2249)"),
                                        p(""),
                                        h4(icon("fa fa-address-book"),"Xin Luo (xl2614)"),
                                        p("")
                                      
                                        
                          )
                      ))
             
  )
)







dashboardPage(
  header,
  sidebar,
  body
)
