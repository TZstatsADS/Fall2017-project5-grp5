library(plotly)

plot_weekday <- function(df.rdata){
  # Create weekday dataframe
  df <- load(df.rdata)
  weekday <- table(df$weekday)
  weekday.df <- as.data.frame(weekday)
  weekday.df$Var1 <- factor(weekday.df$Var1, levels= c("Sunday", "Monday", 
                                                       "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
  weekday.df <- weekday.df[order(weekday.df$Var1), ]
  # Plot
  f <- list(
    family = "sans serif",
    size = 18,
    color = "#7f7f7f"
  )
  x <- list(
    title = "",
    titlefont = f
  )
  y <- list(
    title = "",
    exponentformat = "none"
  )
  
  plot_ly(
    x = weekday.df$Var1,
    y = weekday.df$Freq,
    type = "bar", marker = list(color = c('rgb(158,202,225)', 'rgba(204,204,204,1)', 'rgba(204,204,204,1)','rgba(204,204,204,1)','rgba(204,204,204,1)','rgba(204,204,204,1)','rgb(158,202,225)')
    )) %>%
    layout(title = "Frequency of Citi Bike Use", xaxis = x, yaxis = y)
}






