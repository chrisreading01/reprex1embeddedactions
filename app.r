library(shiny)
library(DT)

ui <- fluidPage(
    titlePanel("reprex1")
    ,fluidRow(
        dataTableOutput("dt1")
    )
)

server <- function(input, output) {
    output$dt1 <- renderDataTable({
        mtlocal <- mtcars
        for(n in 1:nrow(mtlocal)){
            mtlocal$actionbutton[[n]] <- as.character(
                actionButton(
                    paste0("buttonpress",n), label = paste0("buttonpress",n)
                )
            )
        }
        datatable(
            mtlocal
            ,escape = FALSE
            ,selection = "none"
            ,callback = JS("table.rows().every(function(i, tab, row) {
        var $this = $(this.node());
        $this.attr('id', this.data()[0]);
        $this.addClass('shiny-input-container');
      });
      Shiny.unbindAll(table.table().node());
      Shiny.bindAll(table.table().node());")
        )
    }, server = FALSE)

    lapply(
        1:nrow(mtcars),function(x){
            observeEvent(
                input[[paste0("buttonpress",x)]],{
                    showModal(
                        modalDialog(
                            h2(paste0("You clicked on button ",x,"!"))
                        )
                    )
                }
            )       
        }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
