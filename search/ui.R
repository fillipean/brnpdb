library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)
library(DT)
library(reactR)
library(htmltools)

ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "BrNPDB"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Search", tabName = "search", icon = icon("search")),
      menuItem("Statistics", tabName = "statistics", icon = icon("bar-chart"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "search",
          chooseSliderSkin(skin = "Modern"),
          shinyjs::useShinyjs(),
          div(
            id="form",
            fluidPage(
              box(
                title = span(tagList(icon("bar-chart"), "General Information")),
                collapsible = TRUE,
                status = "success",
                solidHeader = TRUE,
                
                textInput("txtCommonName", "Common Name"),
                selectizeInput("ddlClass", "Metabolic Class", choices = c("Any", 'Alkaloids', 'Amino acids and Peptides', 'Carbohydrates', 'Fatty acids', 'Polyketides', 'Shikimates and Phenylpropanoids', 'Terpenoids'), multiple = FALSE, options = NULL),
                textInput("txtMolecularFormula", "Molecular Formula")
                ),
              box(
                title = span(tagList(icon("seedling"), "Species")),
                collapsible = TRUE,
                status = "success",
                solidHeader = TRUE,
                
                selectizeInput("ddlSpecies", "Species", choices = c("Any"), multiple = FALSE),
              ),
              box(
                title = span(tagList(icon("globe"), "Species Location")),
                collapsible = TRUE,
                status = "success",
                solidHeader = TRUE,
                
                selectInput("ddlSampleLocation", "Sample Location", choices = c("Brasil", sort(unique(city$state))), selected = 'Brasil'),
                conditionalPanel(
                  condition = "input.ddlSampleLocation != 'Brasil'",
                
                  selectizeInput("ddlSampleCity", "Location City", choices = c("All"), multiple = FALSE, options = NULL),
                )
              ),
              box(
                title = span(tagList(icon("microscope"), "Biological Properties")),
                collapsible = TRUE,
                status = "success",
                solidHeader = TRUE,
                
                selectInput("ddlBioProperty", "Biological Propertys", choices = c("Any"), multiple = FALSE),
              ),
              box(
                title = span(tagList(icon("virus"), "Source")),
                collapsible = TRUE,
                status = "success",
                solidHeader = TRUE,
                
                selectizeInput('ddlSource', 'Source', choices = c("All", 'Natural', 'Semisynthesis', 'Biotransformation'), multiple = FALSE),
              ),
              box(
                title = span(tagList(icon("bar-chart"), "Reference")),
                collapsible = TRUE,
                collapsed = TRUE,
                status = "success",
                solidHeader = TRUE,
                
                textInput("txtReference", "Reference")
              ),
              box(
                title = span(tagList(icon("flask"), "Chemical Information")),
                collapsible = TRUE,
                collapsed = TRUE,
                status = "success",
                solidHeader = TRUE,
                
                sliderInput("slMolarMass", "Molar Mass (g/mol)",
                          min = 0, max = 1200, value = c(10, 1100)),
                sliderInput("slMonoMass", "Monoisotopic Mass (g/mol)",
                          min = 0, max = 1000, value = c(10, 990)),
                sliderInput("slClogp", "cLogP", 
                            min = -8, max = 14, value = c(-4,10)),
                sliderInput("slTpsa", "TPSA", 
                            min = 0, max = 500, value = c(0, 400)),
                sliderInput("slLipinskiV", "Lipinski Violations", 
                            min = 0, max = 5, value = c(0, 3)),
                sliderInput("slHBondA", "H-Bond Acceptors", 
                            min = 0, max = 30, value = c(0, 25)),
                sliderInput("slHBondD", "H-Bond Donors", 
                            min = 0, max = 30, value = c(0, 12)),
                sliderInput("slRotBonds", "Rotatable Bonds", 
                            min = 0, max = 30, value = c(0, 20))
              ),
              
              fluidRow(
                column(12, align="center",
                  actionButton("btnSearch", "Search Compound(s)", icon("search"), 
                               style="color: #fff; background-color: #00a65a"),
                  actionButton("btnClear", "Clear")
                )
              ),
              
              hidden(
                div(
                  id = "searchResults",
                  
                  br(),
                  
                  fluidRow(
                    box(
                      title = "Download",
                      status = "success",
                      collapsible = TRUE,
                      width = 12,
                      align = "center",
                      downloadButton("btnCSV","CSV"),
                      downloadButton("btnSDF","SDF (R-CDK)"),
                      downloadButton("btnMol2",".mol2")
                    ),
                    
                    box(
                      title = "Results",
                      status = "success",
                      collapsible = TRUE,
                      width = 12,
                      DT::dataTableOutput("analysis")
                    )
                  )
                )
              )
            )
          )
      ),
      tabItem(tabName = "statistics",
          fluidRow(
            valueBox(value = "9.962", subtitle = "Compounds", icon = icon("asterisk", lib="glyphicon"), color = "light-blue", width = 6),
            valueBox(value = "2.998", subtitle = "References", icon = icon("education", lib="glyphicon"), color = "yellow", width = 6),
            valueBox(value = "2.229", subtitle = "Species", icon = icon("leaf"), color = "green", width = 6),
            valueBox(value = "270", subtitle = "Biological Propertys", icon = icon("grain", lib="glyphicon"), color = "red", width = 6),
            valueBox(value = "787", subtitle = "Locations", icon = icon("picture", lib="glyphicon"), color = "orange", width = 6),
            valueBox(value = "47.543", subtitle = "Analysis", icon = icon("list-alt"), color = "purple", width = 6)
          )
      )
    )
  )
)