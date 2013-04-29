This is an R-knitr template for generating reports on longitudinal
SurveyMonkey data.

SurveyMonkey's built-in reports are great, but they aren't really set up to
provide longitudinal comparisons of survey results. This template produces
auto-generated reports that provide those comparisons.

I use collectors to organize longitudinal data. Collectors are given a
descriptive, easy-to-parse name - for example, the most recent round of my
clinic's survey is "TB 2013-04 Paper". This report template depends on that
collector structure in ways I haven't fully evaluated, so you'll have to 
tailor it to accommodate your practices.

To run this template, download whatever data you'd like to evaluate from
SurveyMonkey using their "advanced statistical software" format. Clone this
repository, and then drag the .zip file from SurveyMonkey into it (no need
to extract). Next, just run `Rscript generate_report.r` from your terminal.
The report will be created and automatically placed in a `reports` subdirectory;
the .zip file will be moved to an `archived_data` subdir.

Warnings:
 - This is primarily for reference. It works for me, but no guarantee for you.
 - Only place one .zip file in the directory at a time.
 - If your collector names don't match the general "Descriptor YYYY-MM" format,
   this will probably not work.
