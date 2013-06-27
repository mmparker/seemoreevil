


gen_open_ended_results <- function(monkeydata, question, collector_name, namedict) {
  
  require(plyr)
  
  # What's the original label for this question?
  question_label <- namedict$label[namedict$name %in% question]
  
  
  # Aggregate question responses by collector
  answerfreq <- dlply(monkeydata, .var = collector_name, .fun = function(x) {
    
    # Aggregate the responses for this collector
    quest_summary <- arrange(count(x, question), desc(freq))
        
    # Label the data.frame with the collector name
    names(quest_summary) <- c(x$Title[1], "Freq")
    
    quest_summary
    
  })
  
    
  list(question_label = question_label, comments = answerfreq)
         
}
  
