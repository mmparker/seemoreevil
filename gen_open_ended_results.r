


gen_multiple_choice_results <- function(monkeydata, question, collector_name, namedict) {
  
  require(plyr)
  
  # What's the original label for this question?
  question_label <- namedict$label[namedict$name %in% question]
  
  
  # Aggregate question responses by collector
  answerfreq <- dlply(monkeydata, .var = collector_name, .fun = function(x) {
    
    # Aggregate the responses for this collector
    quest_summary <- arrange(count(x, question), desc(freq))
    
    # Add percentage of respondents giving each response
    quest_summary$prop <- quest_summary$freq / nrow(x) * 100
    
    # Label the data.frame with the collector name
    names(quest_summary) <- c(x$Title[1], "freq", "prop")
    
    quest_summary
    
  })
  
    
  list(question_label = question_label, comments = answerfreq)
         
}
  