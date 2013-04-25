




gen_multiple_choice_results <- function(monkeydata, question, collector_name, namedict) {
  
  require(plyr)
  
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
                        agree = c("Strongly Disagree", "Disagree",
                                  "Agree", "Strongly Agree", "Does not apply", NA),
                        agree_wait = c("Strongly Disagree", "Disagree", 
                                       "Agree", "Strongly Agree", 
                                       "No long wait", NA)
  )
  
  # Which ones contain all of the responses in this question?  Use the first
  matching_sets <- ldply(response_sets, .fun = function(x) {
    
      all(unique(answerfreq[ , question]) %in% x)
  
  })
  
  response_set <- matching_sets$.id[matching_sets$V1][1]
  
  
  # Reorder the responses accordingly
  answerfreq$response <- factor(answerfreq[ , question],
                                 levels = response_sets[[response_set]])
  
  
  
  # Generate the plot
  answerplot <- ggplot(answerfreq,
                       aes_string(x = collector_name,
                                 weight = 'prop',
                                 group = 'response',
                                 fill = 'response')) +
                    geom_bar(color = "black") +
                    scale_fill_brewer("Response", palette = "PiYG") +
                    labs(x = "Survey round",
                         y = "Proportion of respondents") +
                    guides(fill = guide_legend(reverse = TRUE)) +
                    theme_bw() +
                    theme(axis.text.x = element_text(angle = 45, hjust = 1.05, vjust = 1.1))
  
  
  
  # Is there a corresponding comments section?
  comment_vec <- make.names(paste(question_label," - Comments:", sep = ""))
  
  # If so, aggregate and return
  commentfreq <- NA

  # Aggregate comments by collector
  if(comment_vec %in% names(monkeydata)) {
    commentfreq <- dlply(monkeydata, .var = collector_name, .fun = function(x) {
    
      # Aggregate the responses for this collector
      quest_summary <- arrange(count(x, comment_vec), desc(freq))
         
      # Label the data.frame with the collector name
      names(quest_summary) <- c(x$Title[1], "Freq")
    
      quest_summary
    
    })
  }
  
  
  # Return a list of the elements
  list(question_label = question_label,
       answerplot = answerplot, 
       comments = commentfreq)
  
  
}
