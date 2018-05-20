#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

montyHall <- function(games, strategy) {
    print("montyHall()")
    wins <- 0
    
    
    winnerVector <- c()
    chosenVector <- c()
    revealVector <- c()
    finalVector <- c()
    winVector <- c()
    
    print("Executing montyHall")
    
    for (i in 1:games) {
        # Create the doors vector
        doors <- 1:3
        
        # Select the winner door
        winner <- sample(1:3, 1)
        
        # Get the participant's chosen door
        chosen <- sample(1:3, 1)
        
        # The final participant's decision
        final <- 0
        
        if(chosen != winner) {
            reveal <- doors[-c(winner, chosen)]
        }
        else {
            reveal <- sample(doors[-winner], 1)
        }
        
        if(strategy == 'stay') {
            final <- chosen
            if(chosen == winner) {
                wins <- wins + 1
            }
        }
        else if(strategy == 'change') {
            final <- doors[-c(reveal, chosen)]
            if(chosen != winner) {
                wins <- wins + 1
            }
        }
        else if(strategy == 'random') {
            final <- sample(doors[-reveal], 1)
            if(final == winner) wins <- wins + 1
        }
        
        
        winnerVector <- c(winnerVector, winner)
        chosenVector <- c(chosenVector, chosen)
        revealVector <- c(revealVector, reveal)
        finalVector <- c(finalVector, final)
        winVector <- c(winVector, winner == final)
        cat(strategy, winner, chosen, reveal, final, winner == final, "\n")
    }
    history <- data.frame(winnerVector, chosenVector, revealVector, finalVector, winVector)
    names(history) <- c("winner", "chosen", "reveal", "final", "win")
    return(list("wins" = wins, "history" = history))
}
shinyServer(function(input, output) {
    
    model <- reactive({
        montyHall(as.numeric(input$games), input$strategy)
    })
    
   
    output$resultChart <- renderPlot({
        wins <- model()$wins
        #pieLabels <- c(cat(wins, " (", round((wins / input$games) * 100, 2), "%)", sep = ""), cat(input$games - wins, " (", round(((input$games - wins) / input$games) * 100, 2), "%)", sep = ""))
        pieLabels <- c(
            paste(wins, " (", round((wins / input$games) * 100, 2), "%)", sep = ""),
            paste(input$games - wins, " (", round(((input$games - wins) / input$games) * 100, 2), "%)", sep = "")
            )
        #pie(c(wins, input$games - wins), col = c("green", "red"), labels = pieLabels)
        #legend("topright", legend = c("Win", "Loose"), fill = c("green", "red"))
        df <- data.frame(group = c("Win", "Lose"), value = c(wins, input$games - wins))
        ggplot(df, aes(x="", y = value, fill = group)) + geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + scale_fill_manual(values=c("#F5B7B1", "#ABEBC6")) + theme_minimal()
  })
    
    output$resultTable <- DT::renderDataTable({
        model()$history
    })
  
})
