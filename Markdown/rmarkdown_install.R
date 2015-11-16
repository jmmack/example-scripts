#Markdown for R

```{r}
#This is R code. It's contained between 3 back ticks
#It will be evaluated (run) as R code

```
#------------------------------------------
# Some resources:
http://kbroman.org/knitr_knutshell/pages/Rmarkdown.html
	#this explains installing pandoc
http://shiny.rstudio.com/articles/rmarkdown.html

https://github.com/rstudio/rmarkdown#installation
	#install rmarkdown
https://github.com/rstudio/rmarkdown/blob/master/PANDOC.md
http://pandoc.org/installing.html
	#install pandoc

#------------------------------------------
# Installation (for commandline R on Mac):
#In R
install.packages("knitr")
install.packages("rmarkdown")

#But you need pandoc to convert it. This comes with RStudio, but has to be installed separately for commandline
#And you need LaTeX to convert to a PDF document

http://www.tug.org/mactex/morepackages.html
#Get BasicTeX

http://pandoc.org/installing.html
#Get pandoc

#------------------------------------------
# Making a PDF from Markdown

#outside R
# you can use build.sh to make PDFs from markdown (.Rmd)
build.sh Outline

# OR, inside R

library("rmarkdown")
# render a single format
render("Outline.Rmd", "pdf_document")
# render multiple formats
render("input.Rmd", c("html_document", "pdf_document"))
