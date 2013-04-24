




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
  # freqlevels <- c("Daily", "Twice a week", "Weekly", "Monthly", "Occasionally", "First time")
  freqlevels <- c("Strongly Disagree", "Disagree", "Agree", "Strongly Agree", "No long wait")
  
  
  # Reorder the responses accordingly
  #answerfreq[ , question] <- factor(answerfreq[ , question],
  #                                  levels = freqlevels)
  
  
  
  # Generate the plot
  answerplot <- ggplot(answerfreq,
                       aes_string(x = collector_name,
                                 weight = 'prop',
                                 group = question,
                                 fill = question)) +
                    geom_bar() +
                    scale_fill_discrete("Response") +
                    labs(x = "Survey round",
                    y = "Proportion of respondents",
                    title = question_label)
  
  
  # Is there a corresponding comments section?
  comments <- NA
  #comments <- arrange(
  #                 count(monkeydata,
  #                       var = namedict$name[namedict$label %in% 
  #                                           paste(question_label, 
  #                                                 " - Comments:", 
  #                                                 sep = "")]),
  #                  desc(freq)
  #)
  
  #names(comments) <- c("Comment", "freq")
  
  
  # Return a list of the elements
  list(question_label = question_label,
       answerplot = answerplot, 
       comments = comments)
  
  
}
