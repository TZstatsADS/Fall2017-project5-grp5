
header <- dashboardHeader(
  title = "Citi Bikes in NYC",disable = TRUE
)

sidebar <- dashboardSidebar(collapsed = T,width =200,disable = TRUE,
                            sidebarMenu(
                              menuItem("None", tabName = "None", icon = icon("map"))
                            ))
                            

body <- dashboardBody(

  navbarPage(strong(icon("bicycle"),"NYC Citi Bike",style="color: #253494;"), theme="styles.css",
             ########################
             ##### 1.INTRO TAB ######
             ########################
             tabPanel(strong(icon("bookmark-o"),"Intro"),div(id="bg",
                                                             absolutePanel(width=1200,left=50,right=30,
                                                                       h1("Project 5: an RShiny app for Citi Bike NYC"),
                                                                       h2("Summary"),
                                                                       p(" We developed this app using R Shiny to "),
                                                                       h2("Content"),
                                                                       h4(strong(icon("map"),"Stations")),
                                                                       p(""),
                                                                       h4(strong(icon("balance-scale"),"Routes")),
                                                                       p(""),
                                                                       h4(strong(icon("star"),"Analysis")),
                                                                       p(""),
                                                                       h4(strong(icon("calculator"),"About Us")),
                                                                       p("")
                                                                      
                                                             )
                                                             )),
             ##############################
             ###### 2. Station Tab ########
             ##############################
             tabPanel(strong(icon("map"), "Station Map"),
                      tabItem(tabName =strong(icon("map"), "Station Map")
                              
                              ),
                      
                              #########################################
                              #### Second Row of the first Page ####
                              ###### Charts for Each Stations ######
                              ##########################################
                              tabsetPanel(id="SummaryTabSet",
                                          tabPanel(p(icon("home"),"Main",style="color: grey;"),value="MapSetting",
                                                   
                                                   fluidRow(hr())
                                                   )
                              )),
             
             
             ##############################
             ###### 3. Route Tab ########
             ##############################
             tabPanel(strong(icon("balance-scale"),"Bike Route"),
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
                                                 selected = "All",
                                                 width = 250),
                                     
                                     selectInput("gender", strong(icon("female"),"Gender",style="color:DarkRed"),
                                                 choices = c("All","Female"="2","Male"="1"), 
                                                 selected = "All",
                                                 width = 250),
                                     
                                     # selectInput("snow", strong(icon("hand-o-right"),"Snow or Not",style="color:LightSeaGreen"),
                                     #             choices = c(" ","snow","no snow"), selected = " ",width = 330),
                                     
                                     selectInput("age.group", 
                                                 strong(icon("line-chart"),"Age Group",style="color:DarkSlateGray"),
                                                 choices = c("All",Age.groups), 
                                                 selected = "All",
                                                 width = 250),
                                     
                                     selectInput("Time", strong(icon("clock-o"),"Time",style="color:DarkSlateBlue"),
                                                 choices =c("All",time.categories), 
                                                 selected = "All",
                                                 width = 250),
                                     checkboxInput("Show_st", "Show Stations",F)
                                 
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
             ###### 4. Analysis Tab #######
             ##############################
             tabPanel(strong(icon("star"),"Analysis")
                      
             ),
             ##############################
             ###### 2. About Us Tab ########
             ##############################
             tabPanel(strong(icon("user"), "About Us"),div(id="bg"
                    )
                    )
      
  ))







dashboardPage(
  header,
  sidebar,
  body
)
