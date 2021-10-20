# libraries
suppressMessages(library(tidyverse))
suppressMessages(library(lubridate))
suppressMessages(library(tsibble))
suppressMessages(library(fable))
suppressMessages(library(RPostgreSQL))
suppressMessages(library(RcppRoll))
suppressMessages(library(stringr))
suppressMessages(library(gridExtra))
suppressMessages(library(repr))
suppressMessages(library(clipr))
suppressMessages(library(MarketMatching))
suppressMessages(library(config))
suppressMessages(library(shiny))

# setting wd
if ( grepl("june-14-pricing-impacts", getwd(), fixed = TRUE) ) {
} else {
  setwd("./projects/pricing/june-14-pricing-impacts/")
}

# load functions
source("functions.R")

# get data
dw <- config::get(file="./redshift_credentials.yml")
con <- DBI::dbConnect(RPostgreSQL::PostgreSQL(),
                      dbname = dw$dbname,
                      host = dw$host,
                      port = dw$port,
                      user = dw$user,
                      password = dw$password)
print("pulling data for sales, ad spend, and traffic")
options(warn=-1)
query_sales   <- getSQL("sql/data_pull__sales.sql")
query_spend   <- getSQL("sql/data_pull__spend.sql")
query_traffic <- getSQL("sql/data_pull__traffic.sql")
df_sales   <- dbGetQuery(con, query_sales) %>% as_tibble()
df_spend   <- dbGetQuery(con, query_spend) %>% as_tibble()
df_traffic <- dbGetQuery(con, query_traffic) %>% as_tibble()
options(warn=0)

# Define UI for app
ui <- fluidPage(
  titlePanel("Incremental Impact Measurement"),
  sidebarLayout(
    sidebarPanel(
      helpText("Measure incremental impacts after a price change or product launch"),
      fluidRow(
        selectInput("size", 
                      label = "Choose the size of interest",
                      choices = c("2x3", 
                                  "3x5",
                                  "5x7", 
                                  "6x9",
                                  "8x10",
                                  "9x12",
                                  "2.5x7",
                                  "2.5x10",
                                  "6' Round",
                                  "8' Round")),
        selectInput("product_sub_type", 
                    label = "Choose the system type of interest",
                    choices = c("Classic System", 
                                "Cushioned System")),
        selectInput("collection", 
                    label = "Choose the collection type of interest",
                    choices = c("non-licensed", 
                                "licensed")),
        selectInput("product_function", 
                    label = "Choose the function of interest",
                    choices = c("Indoor", 
                                "Outdoor")),
        dateInput("measurement_start_date", 
                  h3("Date input")),
        checkboxGroupInput("checkGroup", 
                           h3("Select Time Series Controls"), 
                           label = "helper text here",
                           choices = list("Choice 1" = 1, 
                                          "Choice 2" = 2, 
                                          "Choice 3" = 3))
        )
      ),
    
    mainPanel(textOutput("selected_var")
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  measurement_start_date <- input$measurement_start_date
  
  target_function <- input$product_function
  
  target_category <- paste0(input$size, 
                            "_", 
                            input$product_sub_type, 
                            "_",
                            input$collection)
  
  group_by_fields <- c("size", "product_sub_type", "rug_collection")
  
  df_sales_grouped <- groupData(df_sales %>%
                                  filter(`function`==target_function) %>%
                                  unite(group_by_col, all_of(group_by_fields)),
                                c("date","group_by_col"))
  
  output$selected_var <- renderText({
    head(df_sales_grouped)
  })
}

shinyApp(ui = ui, server = server)
