# INPUTS for the Life Table
pop_size = c(500,400,200,50,0)
ma = c(0,2,3,1,0)

# LIFE TABLE
lt<-data.frame(
	age=c(0,1,2,3,4),
	pop_size = pop_size,
	ma=ma)

lt[1,]
lt[,2]
lt[3,2]
lt$ma[2] # look carefully at this.... using $ and [ ]


lt[2:5,2] # rows 2:5 in column 2
lt[2:5,2]/lt[1:4,2] # divide rows 2:5 by 1:4 in column 2

# MAKE the OTHER COLUMNS
lt<-mutate(lt, la = pop_size/lt$pop_size[1])
lt<-mutate(lt, pa = c(NA,la[2:5]/la[1:4]))
lt


lt<-mutate(lt, Fa = pa[2]*ma)
lt

BP <- matrix(NA, nrow = 4, ncol = 4)
BP

# dump Fa column into BP row 1. 
# (note we left out the first element)
BP[1,] <- lt$Fa[2:5] 
BP

BP[2,1]<-lt$pa[2]
BP[3,2]<-lt$pa[3]
BP[4,3]<-lt$pa[4]
BP

is.na(BP) # shows you where the NA's are
BP[is.na(BP)]<-0 # replaces the NA's with 0
BP # see the result

Ro <- summarise(lt, Ro = sum(la*ma))
Ro


eigen(BP)
eigen(BP)$values[1]
log(eigen(BP)$values[1])

N0 <- c(2,2,2,2) # 4 values for 4 ages we are counting.
BP %*% N0

nits <- 25 # how many years will we project
tmp <- matrix(NA, nrow = nits, ncol = 4)
collect <- data.frame(tmp)
names(collect)<-c("Age1", "Age2","Age3", "Age4")
head(collect) # just look at the first six rows

collect[1,] <- N0
head(collect)

for (a in 2:nits){
  collect[a,] <- BP %*% t(collect[(a-1),])
  }

head(collect)
tail(collect)

Total<-mutate(collect, 
  TotalPop = Age1+Age2+Age3+Age4,
  Time = 1:nits)

ggplot(Total, aes(x = Time,  y = log(TotalPop)))+
  geom_line()+
  theme_classic(base_size = 15)

library(reshape2)
long<-melt(Total, 
          # this is the fixed variable
          id.vars = c("Time"),
          # these are what we want to stack up
          measure.vars=c("Age1","Age2","Age3","Age4"),
          # this is what we will called the stacked labels
          variable.name = "Age",
          # this is what we call the stacked values
          value.name = "Abund")

# now use ggplot!
ggplot(long, aes(x =Time, y = log(Abund), group = Age, col = Age))+
  geom_line()+
  theme_classic()

summarise(group_by(Total, Time),
          Age1_Prop = Age1/TotalPop,
          Age2_Prop = Age2/TotalPop,
          Age3_Prop = Age3/TotalPop,
          Age4_Prop = Age4/TotalPop)

v1 <- eigen(BP)$vectors[,1]
v1_Sum <- sum(eigen(BP)$vectors[,1])
# Stable Age
v1 / v1_Sum


BP
# create a copy of BP
BP_change<-BP

# decrease row 1, col 3 by 50% and make sure it is in the BP_change
BP_change[1,3] <- BP[1,3]*0.5

# compare row 1, col 3
BP
BP_change

# Now check growth rate of both to compare
round(eigen(BP)$value[1],2)
round(eigen(BP_change)$value[1],2)
