


# Strings ain't factors
options(stringsAsFactors = FALSE)


# Load knitr to generate the report
library(knitr)


# Knit it - even though the .rmd file is located elsewhere, it will
# run with the data in this folder
knit2html(input = "qi_survey_report.rmd")
     
