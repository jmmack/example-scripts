---
title: Using RMarkdown to make reports
date: 24-Apr-2018
author: Jean M Macklaim
---
These are my own personal summary notes from the RLadies workshop presented by Thea Knowles [here](https://github.com/rladies/meetup-presentations_london_ontario/tree/master/2018-03-06_rmarkdown)

---
### Structure of a Summary Report (single Rmd)
* Combine multiple files/data sources/scripts into one summary.md
  - e.g. Having complete R scripts incorporated in Rmd summaries. Or multiple Rmd or md “chapters” or sections of a project
* 3 ingredients
  1. Data (in a .txt or .csv)
  2. Your R code/script
  3. Your summary .md file

*Notes:*
- For 2. Make your R script as you would for normal R code. You should be able to `source()` this. Thea calls this `helper.R`
- For 3. This will be your "master document" that will show figures, describe results, and have descriptive notes. It can contain small code chunks, and `source()` larger RScripts. There are example Rmd templates to work from

#### The summary.Rmd file
Thea's example: `preliminary_results_summary.Rmd`
- Note how R code is called in **chunks**
- Chunks are **named**
  - You can call variables in chunks from your helper script or make new variables
- In your `helper.R` script, the plots and data should be pushed into **unique variable names** so you can call by name in the Rmd

### Structure of a Manuscript (multiple Rmd)
Ingredients:
1. Data in .txt or .csv
2. Your helper R scripts
3. Multiple Rmd e.g. manuscript.Rmd, results.Rmd
4. References in .bib format

*Notes:*
- In Thea's example, manuscript.Rmd has everything BUT results. So intro, methods, discussion, references
- Your results.Rmd is a *child document* to the main document


#### Referencing
* Have one .bib file with unique tags to reference
    * Note: Papers3 automatically has reference tags, and can be exported as .bib
    * OR use google scholar to export the .bib and add it to a file
* This file stays in one location, and I include the path to it in the YAML: bibliography: /Users/thea/references.bib

###### Using Papers3
* Use ctrl+m to pull up the magic citations tool
* Insert the citekey
* USE THIS IN ANY APP/SOFTWARE
* http://support.readcube.com/support/solutions/articles/30000024001-magic-citations-on-papers-3-for-mac

##### Inserting images
- Best to keep a subdirectory of files and call in main doc `![Caption](images/image1.png)`

##### Extra
- [Markdown Table generator](http://www.tablesgenerator.com/markdown_tables)
