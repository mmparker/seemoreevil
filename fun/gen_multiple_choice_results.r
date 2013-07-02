




gen_multiple_choice_results <- function(monkeydata, question, collector_name, namedict) {
  
  require(plyr)
  require(ggplot2)
  require(RColorBrewer)
  
  # What's the original label for this question?
  question_label <- namedict$label[namedict$name %in% question]
  
  
  # Aggregate question responses by collector
  answerfreq <- ddply(monkeydata, .var = collector_name, .fun = function(x) {
    
    # Aggregate the responses for this collector
    quest_summary <- count(x, question)
    
    # Add percentage of respondents giving each response
    quest_summary$prop <- quest_summary$freq / nrow(x) * 100
    
    quest_summary
    
  })
  
  
  
  # Identify the appropriate answer set
  # A list of all possible answer sets
  response_sets <- list(freq = c("Daily", "Twice a week", "Weekly", 
                                 "Monthly", "Occasionally", "First time", NA),
                        
                        agree = c("Strongly Agree", "Agree",
                                  "Disagree", "Strongly Disagree",
                                  "Does not apply", NA),
                        
                        agree_wait = c("No long wait", "Strongly Agree", "Agree",
                                       "Disagree", "Strongly Disagree",
                                       "Does not apply", NA),
                        
                        wait_minutes = c("< 5 minutes", "10-15 minutes", "15-20 minutes", 
                                         "> 20 minutes", NA),
                        
                        yesno = c("Yes", "No", NA),
                        
                        satisfied = c("Strongly Satisfied", "Satisfied",
                                      "Dissatisfied", "Strongly Dissatisfied",
                                      "Does not apply", NA)
  )
  
  # Which ones contain all of the responses in this question?  Use the first
  matching_sets <- ldply(response_sets, .fun = function(x) {
    
      all(unique(answerfreq[ , question]) %in% x)
  
  })
  
  response_set <- matching_sets$.id[matching_sets$V1][1]
  
  
  # Reorder the responses accordingly
  answerfreq$response <- factor(answerfreq[ , question],
                                 levels = response_sets[[response_set]])
  
  
  # Set up colors for each response set
  mypal <- c(brewer.pal(n = 6, "PiYG"), "gray78")
  
  color_sets <- list(
      
      freq = mypal[c(1:7)],
       
       agree = mypal[c(6, 5, 2, 1, 7, 7)],
       
       agree_wait = mypal[c(6, 5, 4, 2, 1, 7, 7)],
      
       wait_minutes = mypal[c(6, 5, 2, 1, 7)],
      
       yesno = mypal[c(6, 1, 7)],
       
       satisfied = mypal[c(6, 5, 2, 1, 7, 7)]
                         
  )
  
  names(color_sets$freq) <- response_sets$freq
  names(color_sets$agree) <- response_sets$agree
  names(color_sets$agree_wait) <- response_sets$agree_wait
  names(color_sets$wait_minutes) <- response_sets$wait_minutes
  names(color_sets$yesno) <- response_sets$yesno
  names(color_sets$satisfied) <- response_sets$satisfied
    
  
  # Generate the plot
  answerplot <- ggplot(answerfreq,
                       aes_string(x = collector_name,
                                  weight = 'prop',
                                  group = 'response',
                                  fill = 'response')) +
                       geom_bar(color = "black") +
                       scale_fill_manual("Response", values = color_sets[[response_set]]) +
                       labs(x = "Survey round",
                            y = "Proportion of respondents") +
                       guides(fill = guide_legend(reverse = TRUE)) +
                       theme_bw() +
                       theme(axis.text.x = element_text(angle = 45, hjust = 1.05, vjust = 1.1))
  
  
  
  # Return a list of the elements
  list(question_label = question_label,
       answerplot = answerplot)
  
  
}
