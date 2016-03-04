Installing packages and R Paths:
http://cjelli.biochem.fmd.uwo.ca/users/mmacklai/weblog/0e91e/R_library_paths_for_installs.html

Customizing R startup environment (p. 406 appendix B from R in Action)
Information is in an "Rprofle" file. There is one in the R home dir that should NOT be modified. Add another in your local user home for specific options you would like in R.

e.g. I added options(width=250) to change the default like wrapping from 80 chars to 250

in ~/.Rprofile

#-------------------------------------------------
# Loading and checking package functions
#-------------------------------------------------

library("ShotgunFunctionalizeR")

List the loaded functions:
ls("package:ShotgunFunctionalizeR")

#-------------------------------------------------
# Example datasets
#-------------------------------------------------

R has example datasets if you need something to play with. See the list:
data()
