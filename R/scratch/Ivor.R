# Ivor's Data
# 4-Mar-2016

# Read in table with row and column names maintained
d<-read.table("~/Downloads/patient data.txt", sep="\t", quote="", check.names=F, header=T, row.names=1, fill=T)

#summarize a column
table(d$"History of IV drug use")
 no yes
 28  19

summary(d$WBC)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
   2.90    8.25   12.10   18.47   17.70  148.00


# Summarize one data variable (column) against another
table(d$"History of IV drug use", d$Endocarditis)

      No Yes-Aortic Valve Yes-Mitral Valve Yes-Multiple valves Yes-Tricuspid Valve
  no  21                2                3                   1                   1
  yes  5                1                2                   0                  11


# Subset the data based on cutoffs
# e.g. get patients over 30 with history of IV drug use
d2<-d[ which(d$"History of IV drug use"=='yes' & d$Age > 30), ]
#(This outputs the rows that match into a new table called d2)

# How many rows in d2
nrow(d2)
	[1] 35
# So therefore 35 people are >30 and have a history of IV drug use

# Get the difference in days between 2 dates

#Convert to date format
x<-as.Date(d$"Date of Hospital Admission", format="%d-%b-%y")
y<-as.Date(d$"Date of Hospital Discharge", format="%d-%b-%y")

#Calc difference in days
diff<-difftime(y, x)

# Add this as a column to the table
d$days_in_hospital<-as.numeric(diff)
