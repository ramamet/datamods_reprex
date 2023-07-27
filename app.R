# load packages
library(shiny)
library(datamods)
library(DT)

# read data
dat <- readRDS('dat.rds')

# ui
ui <- fluidPage(
  tags$h3("Import data"),
  fluidRow(
    column(
      width = 4,
      filter_data_ui("filtering", max_height = "500px")
    ),
    column(
      width = 8,
      tags$b("Imported data:"),
      DT::dataTableOutput("mytable")
    )
  )
)


# server side
server <- function(input, output, session) {

  res_filter <- filter_data_server(
    id = "filtering",
    data = reactive(dat),
    name = reactive("dat"),
    vars = reactive(names(dat))
    , widget_char = c("select")
    , widget_num = c("slider")
    , widget_date = c("range")
    , label_na = "empty_cell"
  )

  output$mytable = DT::renderDataTable({
    res_filter$filtered()
  })

}

# run app
shinyApp(ui, server)  