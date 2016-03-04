# Find and replace:

/Volumes/rhamnosus/Solid_Dec2010/transcriptome_mapping/meta/ALDEx_1.0.3_May2012/bin/stripchart.R

# Replace COG letters with the category names
named.groups<-as.vector(groups)
named.groups[named.groups == "J"] <- "Translation, ribosomal structure and biogenesis [J]"
named.groups[named.groups == "K"] <- "Transcription [K]"
named.groups[named.groups == "L"] <- "DNA replication, recombination and repair [L]"

# Get rows (or columns) in data frame matching a character string
bv<-td[grep("bbv", rownames(td)),]

# using OR
bv<-td[grep('(bbv|bvvc)', rownames(td)),]
