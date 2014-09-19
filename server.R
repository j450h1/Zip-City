library(shiny)
library(zipcode)
library(ggmap)
data(zipcode)

# Define server logic required to summarize and view the selected
shinyServer(function(input, output) {
  output$citymap <- renderPlot({
    #INPUTS
    name.city <- paste(input$city,", ",input$state) 
    url <- as.character(input$url)
    #FINDING AND MATCHING THE ZIPCODES
    webpage <- readLines(url)
    ziplist <- list(); US <-  "\\d{5}([- ]*\\d{4})?" ##Got this regex from a google search
    for (i in seq(1:length(webpage))) {
      if (grepl(US,webpage[i]) == TRUE){
        temp <- regmatches(webpage[i], gregexpr(US, webpage[i], perl = TRUE)) 
        ziplist <- c(ziplist,temp) 
      }
    }
    zips <- list()
    #Looked at the first item in the nested list.
    for (i in seq(1:length(ziplist))) {
      if (length(zipcode[zipcode$zip == ziplist[i][1],1])==1){
        temp <- ziplist[i][1]
        zips <- c(zips,temp)
      }
    }
    df <- data.frame(zipcodes = unlist(zips))
    df <- data.frame(zipcodes = df[!duplicated(df$zipcodes),])
    df$lat <- zipcode$latitude[match(df$zipcodes,zipcode$zip)]
    df$lon <- zipcode$longitude[match(df$zipcodes,zipcode$zip)]
    
    #MAPPING
    gc.city <- geocode(name.city, output = 'latlona')
    address.city <- get_map(location = c(lon = gc.city$lon, lat = gc.city$lat),
                            color = "color", source = "google", maptype = "roadmap",
                            zoom = 13)
    #Plot the city map
    map <- ggmap(address.city, extent = "device"); 
    map
    #Plot the zipcodes
    map + geom_point(data = df, aes(x = lon, y = lat, colour = "red"), 
                     size = 8) + geom_text(data = df,
                                           aes(label = zipcodes, x = lon+.002, y = lat), hjust = 0, size = 5) +
      theme(legend.position="none")    
#       rm(list=ls())
  }) 
#   output$summary <- renderText({
#     ` paste0(gc.city$lon," , ",gc.city$lat)
# #     name.city <- paste(input$city,", ",input$state) 
# #     url <- input$url
# #     paste0(as.character(length(input$city)),as.character(length(input$state)))
# #     paste0('City,State is ', name.city,"Website is: ", url)
#   })
})
