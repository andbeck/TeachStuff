# Introduction to R for BioDaphnoInformutications# 2016# Andrew B.# ----------------------------------------------------------------------# CLEAR THE DECKS# ----------------------------------------------------------------------rm(list = ls)# ----------------------------------------------------------------------# BASIC PRACTICAL# ----------------------------------------------------------------------# Maths and Functions1+12*7/8-9log(exp(1))log10(1000)log(1000)sin(2*pi)2^10sqrt(81)

# Sequences, Vectorisation1:10seq(from = 1, to = 10, by = 1) # note the three arguments, from, to and byseq(from = 1, to = 10, length = 12) # note the three arguments, from, to and length

# assignmentsx <- 1:10

# look at itx

# use it to make another variabley <- x^2

# work with bothx+y x*y

# create random variablesx <- rnorm(n = 1000, mean = 10, sd = 2)

# look at itx

# sort itsort(x)

# A UNIX LIKE VIEW OF WHAT YOU'VE MADE - remember ls in unix is listing what is in the directory

# ls() lists the objects in your workspacels()

# Your first plotx <- 1:10y <- x^2

# FORMULA INTERFACEplot(y ~ x, type = "b", xlab = "BEER", ylab = "GOGGLES")

# ----------------------------------------------------------------------
# Installing packages
# ----------------------------------------------------------------------

# R-CRAN
install.packages(c('ggplot2', 'dplyr'))

# R - bioconductor
source("https://bioconductor.org/biocLite.R")
biocLite("edgeR")

# ----------------------------------------------------------------------# read some data using read.csv()# ----------------------------------------------------------------------

# this is a path to data on the web
UrlAddress<-'https://raw.githubusercontent.com/andbeck/RDatas/master/myDF.csv'

# # you will often use a path on your computer
# compAddress<-'C:/Documents/RStuff/myDF.csv' # windows
# compAddress<-'~/Documents/RStuff/myDF.csv' # linux/unix/osx

# get the data
myDF <- read.csv(UrlAddress)
str(myDF)

# # with comp
# myDF <- read.csv(compAddress)

# # also directly
# myDF <- read.csv('~/Documents/Rstuff')

# ----------------------------
# make a list (also common)
myList <- list(x = 1:10,
   y = LETTERS[1:5],
   w = matrix(rnorm(100,0,1), nrow = 10, ncol = 10, byrow = TRUE))

# ----------------------------------------------------------------------# Explore the data with important functions in R# [ ] and $ and ==# REMEMBER: ROWS THEN COLUMNS
# ----------------------------------------------------------------------
# NOTE - lots of people are using the package dplyr now with
# verbs select(), slice(), filter()
# VERY good tutorials online# ----------------------------------------------------------------------

# BASE BASICS
myDF[5,2] # 5th row, 2nd columnmyDF$expression # expression columnmyDF[,1] # column 1myList[[3]] # 3rd piece of the list => w

# MORE harder
myList[["w"]][2,] # get the ninth row from the matrix w that is the third element in myList
myList$w[2,] # get the ninth row from the matrix w that is the third element in myList

# More Harder
myDF[51:100,] # rows 51:100 are labeled "B"myDF[myDF$category=="B",] # rows 51:100, but access functionally by definition in category column.

# ----------------------------------------------------------------------# learn how to use subset# ----------------------------------------------------------------------
subset(myDF, category=="B") # rows
subset(myDF, select = "expression") # columns
subset(myDF, category=="B", select = "expression") # both

# ----------------------------------------------------------------------# Summarize the data using tapply and aggregate# ----------------------------------------------------------------------with(myDF, 
	aggregate(x = expression, by = list(category), FUN = mean))

# OR
aggregate(numbers ~ category, data = myDF, FUN = mean)

#
with(myDF, 
	tapply(X = expression, INDEX = list(category), FUN = mean))
	# YOU CAN assign the values returned by subset, aggregate and tapply to objectsmean.nums <- tapply(X = myDF$numbers, INDEX = list(myDF$category), FUN = mean)

# ----------------------------------------------------------------------# make some different types of plots# plot, barplot, histograms, heatmaps# reinforce function and arguments# ----------------------------------------------------------------------

# plot, using the formula method - the bestplot(expression ~ size, data = myDF, pch = 21, bg = "red",   xlab="Size", ylab = "Expression")

# alter the color, and use alpha transparencyplot(expression ~ size, data = myDF, pch = 19, cex = 3, col = rgb(0,0,1,alpha = 0.5))

# specifying categories of colours on the points based on a categorical column# note the special use of [ ]'splot(expression ~ size, data = myDF, 
	pch = 19, col = c("green","blue")[category])

# lattice graphics - super fun explorationlibrary(lattice) # loads a special graphics library into R's brain

xyplot(expression ~ size | category, data = myDF) # panelsxyplot(expression ~ size, groups = category, data = myDF) # groups

# ggplot graphics - very popular now too
library(ggplot2)
ggplot(myDF, aes(x = size, y = expression))+
	geom_point(col = "red")+
	facet_wrap(~category)

# heatmaps - very common in molecular data?heatmapheatmap(myList[[3]])heatmap(myList$w)