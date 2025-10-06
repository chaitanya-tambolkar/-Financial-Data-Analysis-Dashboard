# Load required packages, and install if not already installed
required_packages <- c("shiny", "plotly", "shinythemes")
installed_packages <- rownames(installed.packages())
for (package in required_packages) {
  if (!(package %in% installed_packages)) {
    install.packages(package)
  }
  library(package, character.only = TRUE)
}

# Load data from CSV file (place the CSV file in the same directory as the Shiny app)
dataset <- read.csv("Final_dataset.csv")

# Define a function to calculate statistical insights for different chart types
calculateInsights <- function(data, chart_type) {
  if (chart_type == "scatter") {
    insights <- c(
      "Scatter Plot Insights: ",
      "Mean Value: " = mean(data),
      "Median Value: " = median(data),
      "Min Value: " = min(data),
      "Max Value: " = max(data)
    )
  } else if (chart_type == "line") {
    insights <- c(
      "Line Chart Insights: ",
      "Mean Value: " = mean(data),
      "Median Value: " = median(data),
      "Standard Deviation: " = sd(data)
    )
  } else if (chart_type == "dualAxis") {
    insights <- c(
      "Dual Axis Line Chart Insights: ",
      "Mean Value (Axis 1): " = mean(data),
      "Median Value (Axis 1): " = median(data),
      "Mean Value (Axis 2): " = mean(data),
      "Max Value (Axis 2): " = max(data)
    )
  }
  return(insights)
}

# Define UI
ui <- fluidPage(
  theme = shinytheme("flatly"),
  tags$head(
    tags$style(HTML("
      .sidebar {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.1);
      }
      .sidebar h4 {
        color: #007BFF;
      }
      .sidebar hr {
        margin-top: 10px;
        margin-bottom: 10px;
        border-top: 1px solid #007BFF;
      }
      .title-center {
        text-align: center;
        font-size: 24px; /* Adjust the font size as needed */
      }
    "))
  ),
  div(
    class = "title-center",
    h1("Financial Data Analysis Dashboard")
  ),
  sidebarLayout(
    sidebarPanel(
      width = 3,
      class = "sidebar",
      h4("Scatter Plot: "),
      selectInput(inputId = "scatter_y1", label = "Y-Axis 1", choices = setdiff(colnames(dataset), "Date")),
      selectInput(inputId = "scatter_y2", label = "Y-Axis 2", choices = setdiff(colnames(dataset), "Date")),
      hr(),
      h4("Line Chart"),
      selectInput(inputId = "line_y", label = "Y-Axis", choices = setdiff(colnames(dataset), "Date")),
      hr(),
      h4("Dual Axis Line Chart"),
      selectInput(inputId = "dual_axis_y1", label = "Y-Axis 1", choices = setdiff(colnames(dataset), "Date")),
      selectInput(inputId = "dual_axis_y2", label = "Y-Axis 2", choices = setdiff(colnames(dataset), "Date")),
    ),
    mainPanel(
      width = 9,
      textOutput("plotHeader"),
      verbatimTextOutput("statisticalInsightsScatter"),  # Add a section for statistical insights for Scatter Plot
      plotlyOutput("scatterPlot"),
      verbatimTextOutput("statisticalInsightsLine"),  # Add a section for statistical insights for Line Chart
      plotlyOutput("lineChart"),
      verbatimTextOutput("statisticalInsightsDualAxis"),  # Add a section for statistical insights for Dual Axis Line Chart
      plotlyOutput("dualAxisLineChart")
    )
  )
)

server <- function(input, output) {
  output$plotHeader <- renderText({
    if (!is.null(input$scatter_y1) && !is.null(input$scatter_y2)) {
      paste("Scatter Plot: ", input$scatter_y1, " vs ", input$scatter_y2)
    } else if (!is.null(input$line_y)) {
      paste("Line Chart: ", input$line_y)
    } else if (!is.null(input$dual_axis_y1) && !is.null(input$dual_axis_y2)) {
      paste("Dual Axis Line Chart: ", input$dual_axis_y1, " and ", input$dual_axis_y2)
    }
  })
  
  # Update the renderPrint outputs for statistical insights
  output$statisticalInsightsScatter <- renderPrint({
    insights <- character(0)  # Initialize an empty character vector
    if (!is.null(input$scatter_y1) && !is.null(input$scatter_y2)) {
      insights <- calculateInsights(dataset[[input$scatter_y1]], chart_type = "scatter")
    }
    insights
  })
  
  output$statisticalInsightsLine <- renderPrint({
    insights <- character(0)  # Initialize an empty character vector
    if (!is.null(input$line_y)) {
      insights <- calculateInsights(dataset[[input$line_y]], chart_type = "line")
    }
    insights
  })
  
  output$statisticalInsightsDualAxis <- renderPrint({
    insights <- character(0)  # Initialize an empty character vector
    if (!is.null(input$dual_axis_y1) && !is.null(input$dual_axis_y2)) {
      insights <- calculateInsights(dataset[[input$dual_axis_y1]], chart_type = "dualAxis")
    }
    insights
  })
  
  output$scatterPlot <- renderPlotly({
    title <- if (!is.null(input$scatter_y1) && !is.null(input$scatter_y2)) {
      paste("Scatter Plot: ", input$scatter_y1, " vs ", input$scatter_y2)
    } else {
      ""
    }
    
    plot_ly(dataset, x = ~dataset[[input$scatter_y1]], y = ~dataset[[input$scatter_y2]],
            type = "scatter", mode = "markers", marker = list(color = "#007BFF", size = 8, opacity = 0.8),
            text = ~paste("Year: ", dataset$Date)) %>%
      layout(title = title, xaxis = list(title = input$scatter_y1), yaxis = list(title = input$scatter_y2),
             margin = list(l = 50, r = 50, b = 50, t = 50))
  })
  
  output$lineChart <- renderPlotly({
    title <- if (!is.null(input$line_y)) {
      paste("Line Chart: ", input$line_y)
    } else {
      ""
    }
    
    plot_ly(dataset, x = ~as.Date(dataset$Date, format = "%d/%m/%Y"), y = ~dataset[[input$line_y]],
            type = "scatter", mode = "lines", line = list(color = "#DC3545", width = 2),
            text = ~paste("Year: ", format(as.Date(dataset$Date, format = "%d/%m/%Y"), format = "%Y"))) %>%
      layout(title = title, xaxis = list(title = "Year"), yaxis = list(title = input$line_y),
             margin = list(l = 50, r = 50, b = 50, t = 50))
  })
  
  output$dualAxisLineChart <- renderPlotly({
    title <- if (!is.null(input$dual_axis_y1) && !is.null(input$dual_axis_y2)) {
      paste("Dual Axis Line Chart: ", input$dual_axis_y1, " and ", input$dual_axis_y2)
    } else {
      ""
    }
    
    # Create a dual-axis line chart with two Y-axes
    plot_ly(dataset, x = ~as.Date(dataset$Date, format = "%d/%m/%Y")) %>%
      add_lines(y = ~dataset[[input$dual_axis_y1]], name = input$dual_axis_y1, line = list(color = "#DC3545", width = 2)) %>%
      add_lines(y = ~dataset[[input$dual_axis_y2]], name = input$dual_axis_y2, yaxis = "y2", line = list(color = "#28A745", width = 2)) %>%
      layout(title = title, xaxis = list(title = "Year"), yaxis = list(title = input$dual_axis_y1), yaxis2 = list(title = input$dual_axis_y2, overlaying = "y", side = "right"),
             margin = list(l = 50, r = 50, b = 50, t = 50))
  })
}

shinyApp(ui = ui, server = server)
