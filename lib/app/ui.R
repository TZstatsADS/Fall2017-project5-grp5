
header <- dashboardHeader(
  title = "Citi Bikes in NYC",disable = TRUE
)

sidebar <- dashboardSidebar(collapsed = T,width =200,disable = TRUE,
                            sidebarMenu(
                              menuItem("None", tabName = "None", icon = icon("map"))
                            ))
                            

body <- dashboardBody(

  navbarPage(strong(icon("university"),"NYC Citi Bike",style="color: #253494;"), theme="styles.css",
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
                                                   #strong(icon("university"),"hahhhha",size=10),
                                                   fluidRow(hr())
                                                   )
                              )),
             
             
             ##############################
             ###### 3. Route Tab ########
             ##############################
             tabPanel(strong(icon("balance-scale"),"Bike Route"),
                      div(leafletOutput("map2", height = 700)),
                      absolutePanel( id = "controls", class = "panel panel-default", fixed = TRUE
                                     , draggable = T,top = 90, left = 60, right = "auto", bottom = "auto", width = 330,
                                     height = 'auto',
                                     
                                     #h4("Compare 2 Schools"), 
                                     p(""),
                                     selectInput("weekday", strong(icon("hand-o-right"),"Weekdays or Weekend",style="color:LightSeaGreen"),
                                                 choices = c("ALL","Weekdays","Weekend"), 
                                                 selected = " ",
                                                 width = 330),
                                     
                                     selectInput("gender", strong(icon("hand-o-right"),"Gender",style="color:LightSeaGreen"),
                                                 choices = c("All","female"=2,"male"=1), 
                                                 selected = "ALL",
                                                 width = 330),
                                     
                                     # selectInput("snow", strong(icon("hand-o-right"),"Snow or Not",style="color:LightSeaGreen"),
                                     #             choices = c(" ","snow","no snow"), selected = " ",width = 330),
                                     
                                     selectInput("age.group", 
                                                 strong(icon("hand-o-right"),"Age Group",style="color:LightSeaGreen"),
                                                 choices = c("ALL",Age.groups), 
                                                 selected = "ALL",
                                                 width = 330),
                                     
                                     selectInput("Time", strong(icon("hand-o-right"),"Time",style="color:LightSeaGreen"),
                                                 
                                                 choices =c("ALL",time.categories), selected = "ALL",width = 330)
                                     
                                     
                                     
                                     
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
