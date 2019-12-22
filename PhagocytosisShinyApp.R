require(shiny)
require(reshape2)
require(ggplot2)
require(psych)

ui <- fluidPage(
    titlePanel("Two Sample Multimodal Data Analysis"),
  
    
    sidebarLayout(
    sidebarPanel(
      p("Select you file for upload. For an example file format, see our example files"),
      fileInput("file", "Choose File",
                accept = c("text", ".txt")),
      br(),
      
      p("To visually inspect the data, adjust the binning of the histogram. 
        (Note: this does not change the data or subsequent calculations) " ),
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 50,
                  max = 200,
                  value = 100),
      
      p("If the data appears 'skewed' by high values, be sure to check for outliers" ),
      
      br(),
      
      p("Select the varibale to be used as the control for KS test" ),
      selectInput(
        inputId = "variableselected",
        label = "Select Control Variable for KS test",
        ""
      ),
      
      p("The KS test computes the absolute maximum distance between the ECDFs, D, 
        and compares them to a critical value, set at confidence level p = 0.05"),
      
      br(),
      
      h4("ECDF Curves"),
      p("If there are many variables, consider uploading selected variables only necessary for direct comparisons" )
      
    ),
  
    
    
    
    mainPanel(
      h3("Histogram"),
      plotOutput('histogram'),
      h3("Density Plot"),
      plotOutput('density'),
      h3("Descriptive Statistics"),
      tableOutput('basic.stats'),
      h3("Kolmogorov-Smirnov Two-Sample Test"),
      verbatimTextOutput("ks.out"),
      plotOutput('CDF')
      
    )
  )
)



server <- function(input, output, session) {
 
  inFile <- reactive({
    if (is.null(input$file)) {
      return(NULL)
    } else {
      input$file
    }
  })
  
  myData <- reactive({
    if (is.null(inFile())) {
      return(NULL)
    } else {
      read.csv(inFile()$datapath, header = TRUE, sep = '\t')
    }
  })
  
  observe({
    updateSelectInput(
      session,
      "variableselected",
      choices=colnames(myData()))
    
  })  
  
  

  kstest <- reactive({
    
    res <- sapply(myData(), function(y) {
      ks <- ks.test(myData()[input$variableselected], y)
      c(statistic=ks$statistic, p.value=ks$p.value)
      setNames(c(ks$statistic, ks$p.value), c("statistic (D)", "p.value"))
    })
    
    res
    
    })
           

  output$ks.out <- renderPrint({
    if (is.null(inFile()))
      return(NULL)
    kstest()
  })
   
  
  bs <- reactive({ #basic statistics table
    
   
  out<-data.frame()
  
  for (i in myData()){
    
    d <- describe(i) 
    out <- rbind(out, d)
    
  }
    row.names(out)<-colnames(myData())
    out
    
  })
  
  
  output$basic.stats <- renderTable(rownames = TRUE, striped = TRUE, bordered = TRUE, spacing = c("xs"), {
    if (is.null(inFile()))
      return(NULL)
    bs()
  })
  
  
  output$histogram <- 
    
    renderPlot({
      
      if (is.null(inFile()))
        return(NULL)
      
     
      ggplot(melt(myData()), aes(x=value)) +
        geom_histogram(aes(fill = variable), bins = input$bins, show.legend = FALSE) +
        facet_wrap(~variable, nrow= ncol(myData()) , ncol=1) 
        
      
    })
  
  
  output$density<-
    
    renderPlot({
      
      if (is.null(inFile()))
        return(NULL)
      
      ggplot(melt(myData()), aes(x=value)) +
        geom_density(aes(fill = variable), show.legend = FALSE)+
        facet_wrap(~variable, nrow=2, ncol=1)
      
    })
  
  
    output$CDF <- 
    
    renderPlot({
      
      if (is.null(inFile()))
        return(NULL)
    
    #CDF with Rug
    ggplot(melt(myData()), aes(x=value, group = variable, color = variable)) +
      stat_ecdf(size = 1) +
      ggtitle("ECDF Curves") +
      ylab("Cumulative Probability") +
      xlab("value") + 
      geom_rug() +
      geom_hline(yintercept = c(0,1), linetype = "dashed", alpha = 0.4)+
     
      theme_classic() +
      theme(      axis.title.y = element_text(colour="grey20",size=14,face="bold", margin = margin(t = 0, r = 20, b = 0, l = 0)),
                  axis.title.x = element_text(colour="grey20",size=14,face="bold", margin = margin(t = 15, r = 0, b = 0, l = 0)),
                  axis.text.x = element_text(colour="grey20",size=12,face="bold", margin = margin(5,0,0,0)),
                  axis.text.y = element_text(colour="grey20",size=12,face="bold"),
                  legend.title=element_blank(),
                  legend.text = element_text(colour="grey20",size=10,face="bold"),
                  plot.title = element_text(colour="grey20",size=16,face="bold", margin = margin(0,0,10,0), hjust = 0.5))
    
  
  })
  
}



shinyApp(ui, server)
