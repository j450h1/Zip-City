library(shiny) 
library(zipcode) 
#data(zipcode)
#city <- unique(zipcode[order(zipcode$city),"city"])
#state <- unique(zipcode[order(zipcode$state),"state"])
# Define UI for dataset viewer application
shinyUI(fluidPage(
  # Application title
  titlePanel("Zip City. One map, many zipcodes!"),
  # Sidebar with controls to select a dataset and specify the
  # number of observations to view
  sidebarLayout(
    sidebarPanel(
      h6("Enter the US city and state of the zipcodes:"),
      textInput("city", label = h6("City"), value = "Portland"),
      textInput("state", label = h6("State"), value = "OR"),
#       selectInput("city", "Choose a city:", 
#                   choices = zipcode$city, selected = "Portland"),
#       selectInput("state", "Choose a state:", 
#                   choices = zipcode$state, selected = "OR"),
      h6("Paste the URL of any website which contains zipcodes from one city:  (must be http not https):"),  
      textInput("url", label = h6("URL"), value = "http://www.yelp.ca/search?find_desc=Pizza+Places&find_loc=Portland%2C+OR"),
      submitButton("Submit")
      
    ),
    
    # Show a summary of the dataset and an HTML table with the 
    # requested number of observations
    mainPanel(
      #textOutput("summary"),
      plotOutput("citymap")
      #img(src="bigorb.png", height = 50, width = 50)
    )
  )
))
rm(list=ls())