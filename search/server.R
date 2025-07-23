library(shiny)
library(shinyjs)
library(DT)
library(rcdk)
library(dplyr)
library(ChemmineR)
library(ChemmineOB)

server <- function(input, output, session) {
  compoundsList <- reactiveValues(data = NULL)
  selectedCompound <- reactiveValues(data = NULL)
  selectedCompoundDetails <- reactiveValues(data = NULL)
  mol_descriptors <- reactiveValues(data = NULL)
  filters_choices <- reactiveValues(data = NULL)
    
  updateSelectizeInput(session, 'ddlBioProperty', choices = c("Any", biological_property$property_name), selected = 'Any', server = TRUE)
  updateSelectizeInput(session, 'ddlSpecies', choices = c("Any", species$species_name), selected = 'Any', server = TRUE)
  
  descriptors <- c('org.openscience.cdk.qsar.descriptors.molecular.TPSADescriptor',
    'org.openscience.cdk.qsar.descriptors.molecular.RuleOfFiveDescriptor',
    'org.openscience.cdk.qsar.descriptors.molecular.HBondAcceptorCountDescriptor',
    'org.openscience.cdk.qsar.descriptors.molecular.HBondDonorCountDescriptor',
    'org.openscience.cdk.qsar.descriptors.molecular.RotatableBondsCountDescriptor'
  )
  
  observeEvent(input$ddlSampleLocation, {
    selectedLocation <- city[which(city$state == input$ddlSampleLocation),2]
    updateSelectizeInput(session, 'ddlSampleCity', choices = c("All", selectedLocation), selected = 'All', server = TRUE)
  })
  
  observeEvent(input$btnSearch, {
    hide("searchResults")
    filters_choices <- analysis_brnpdb
    
    if(input$ddlClass != "Any")
      filters_choices <- filter(filters_choices, pathway == input$ddlClass)
    
    if(input$ddlBioProperty != "Any")
      filters_choices <- filter(filters_choices, property_name == input$ddlBioProperty)
    
    if(input$ddlSpecies != "Any")
      filters_choices <- filter(filters_choices, species_name == input$ddlSpecies)
    
    if(input$ddlSampleLocation != "Brasil"){
      filters_choices <- filter(filters_choices, state == input$ddlSampleLocation)
      
      if(input$ddlSampleCity != "All")
        filters_choices <- filter(filters_choices, city == input$ddlSampleCity)
    }
      
    if(input$ddlSource != "All")
      filters_choices <- filter(filters_choices, natural_resource == input$ddlSource)
    
    filters_choices <- compound %>% filter(smiles %in% unique(filters_choices$smiles))
    
    if(input$txtCommonName != "")
      filters_choices <- filter(filters_choices, grepl(input$txtCommonName, filters_choices$common_name, ignore.case = TRUE))
    
    compoundsList$data <- filters_choices
    
    toggle("searchResults")
  })
  
  observeEvent(input$btnClear, {
    compoundsList$data <- NULL
    selectedCompound$data <- NULL
    selectedCompoundDetails$data <- NULL
    mol_descriptors$data <- NULL
    
    output$imageCompound <- NULL
    output$genInfoCompound <- NULL
    output$chemInfoCompound <- NULL
    
    hide("searchResults")
    
    shinyjs::reset("form")
  })
  
  output$analysis <- renderDT({
    if (is.null(compoundsList$data)) return()
    
    DT::datatable(compoundsList$data,
                  extensions = c('Responsive'),
                  selection = 'single',
                  options=list(
                    dom = 'lfrtip',
                    pageLength = 100,
                    columnDefs = list(list(visible=FALSE, targets=c(0))))
                  )
  })
  
  output$btnCSV <- downloadHandler(
    filename = function() {
      paste0("brnpdb", ".csv")
    },
    content = function(file) {
      write.csv(compoundsList$data, file)
    }
  )
  
  output$btnSDF <- downloadHandler(
    filename = function() {
      paste0("brnpdb", ".sdf")
    },
    content = function(file) {
      smiles <- (compoundsList$data[,3])[[1]]
      mols <- parse.smiles(smiles)
      write.molecules(mols, file)
    }
  )
  
  output$btnMol2 <- downloadHandler(
    filename = function() {
      paste0("brnpdb", ".mol2")
    },
    content = function(file) {
      smiles_sel <- (compoundsList$data[,3])[[1]]
      mols <- filter(compounds_molfile, smiles %in% smiles_sel)
      molfiles <- paste0("# brnpdb_id: ", mols[,1][[1]], 
                        "\n# pubchem_cid: ", mols[,6][[1]],  
                        "\n# Iupac Name: ", mols[,5][[1]], "\n\n",
                        gsub("[\r]+", "",(mols[,7])[[1]]))
      write(molfiles, file)
    }
  )
  
  observeEvent(input$analysis_rows_selected, {
    # Sys.sleep(3)
    if (is.null(input$analysis_rows_selected)) return()
    
    selectedSmiles <-(compoundsList$data[req(input$analysis_rows_selected), 3])[[1]]
    selectedCompound$data <- analysis_brnpdb[which(analysis_brnpdb$smiles == selectedSmiles), 3:11] 
    selectedCompoundDetails$data <- compounds[which(compounds$smiles == selectedSmiles), 3:6] 
    
    mol <- parse.smiles(selectedSmiles)
    mol_descriptors$data <- eval.desc(mol, descriptors)
    
    showModal(
      modalDialog(
        title = "Details",
        footer = modalButton("Close"),
        size = "l",
        tabBox(
          side = "right",
          width = 12,
          tabPanel("General Info", DT::dataTableOutput("genInfoCompound")),
          tabPanel("Chemical Info", 
                   DT::dataTableOutput("chemInfoCompoundDetails"), 
                   DT::dataTableOutput("chemInfoCompound")),
          tabPanel("2D", imageOutput("imageCompound")),
          tabPanel("Downloads", 
                   downloadButton("downloadSDF", "SDF (R-CDK)"),
                   downloadButton("downloadSDF2", "SDF (ChemmineR)"),
                   downloadButton("downloadMol2", ".mol2"),
                   downloadButton("downloadReportHtml", "Details (Html)"),
                   downloadButton("downloadReportPDF", "Details (PDF)")
          )
        )
      )
    )
    
    output$genInfoCompound <- renderDataTable({
      DT::datatable(selectedCompound$data,
                    extensions='Responsive',
                    selection='none'
      )
    })
    
    output$imageCompound <- renderPlot({
      img <- view.image.2d(parse.smiles(selectedSmiles)[[1]])
      plot(1:10, 1:10, type = 'n')
      rasterImage(img, 1, 10, 10, 1)
    })
    
    output$chemInfoCompoundDetails <- renderDataTable({
      DT::datatable(selectedCompoundDetails$data,
                    extensions='Responsive',
                    selection='none',
                    options=list(
                      dom = 't',
                      columnDefs = list(list(visible=FALSE, targets=c(0,4)))
                    )
      )
    })
    
    output$chemInfoCompound <- renderDataTable({
      DT::datatable(mol_descriptors$data,
                    extensions='Responsive',
                    selection='none',
                    options=list(
                      dom = 't'
                    )
      )
    })
    
    output$downloadSDF <- downloadHandler(
      filename = function() {
        paste0("brnpdb_", (compoundsList$data[req(input$analysis_rows_selected), 1])[[1]], ".sdf")
      },
      content = function(file) {
        write.molecules(mol, file)
      }
    )
    
    output$downloadSDF2 <- downloadHandler(
      filename = function() {
        paste0("brnpdb_", (compoundsList$data[req(input$analysis_rows_selected), 1])[[1]], ".sdf")
      },
      content = function(file) {
        sdf_set <- smiles2sdf(selectedSmiles)
        write.SDF(sdf_set, file)
      }
    )
  })
}