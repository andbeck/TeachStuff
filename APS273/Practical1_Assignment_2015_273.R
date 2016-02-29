library(popbio)

# Example in Class

# INPUTS for the Life Table
pop_size = c(500,400,200,50,0)
mx = c(0,2,3,1,0)

# LIFE TABLE
lt<-data.frame(
	age=c(0,1,2,3,4),
	pop_size = pop_size,
	mx=mx)

# MAKE the OTHER COLUMNS
lt<-transform(lt, lx = pop_size/lt$pop_size[1])
lt<-transform(lt, pi = c(NA,lx[2:5]/lx[1:4]))
lt<-transform(lt, Fi = pi*mx)
lt

# we make the matrix 4 x 4; 
# again it is the PRE-BREEDING CENSUS

m<-rbind(
	lt$Fi[-1]*lt$pi[-1],
	c(lt$pi[2],0,0,0),
	c(0,lt$pi[3],0,0),
	c(0,0,lt$pi[4],0))

nits<-20
n<-matrix(NA, nits,4)
n[1,]<-c(50,50,50,50) 

for(i in 2:nits){
	n[i,]<-t(m %*% n[(i-1),])
}

par(mfrow = c(1,1))
matplot(log(n), type = "l", ylab = "log Pop Size", xlab = 'Time')

lambda(m)
m2<-m
m2[m2==0]<-NA
image2(m2, border=TRUE)


### ------------------------------------------------------------
### ------------------------------------------------------------

# assignment 2015

# Life Table
# INPUTS
pop_size = c(1000, 13, 10.4, 8.21, 5.7)
mx = c(0,0,0.407, 6.35, 57.1)

# LIFE TABLE
lt<-data.frame(
	age=c(0,1,2,3,4),
	pop_size = pop_size,
	mx=mx)

lt<-transform(lt, lx=pop_size/lt$pop_size[1])
lt<-transform(lt, lxmx = lx * mx)
lt<-transform(lt, pi = c(NA,lx[2:5]/lx[1:4]))
lt<-transform(lt, Fi_PreB = pi*mx)
lt<-transform(lt, Fi_BPul = pi[2]*mx) # fec * P0 or S0
lt<-lt[,c(1,2,4,3,5,6,7,8)]
names(lt)[2]<-"Sx"
lt
sum(lt$lx*lt$mx)

# Projection

nP<-matrix(NA, 101,5)
nP[1,]<-c(10,10,10,10,10)

m<-rbind(
c(0,	0,	0,	4.665,	61.896),c(0.675,	0.703,	0,	0,	0),c(0,	0.047,	0.657,	0,	0),c(0,	0,	0.019,	0.682,	0),c(0,	0,	0,	0.061,	0.8091))

for(i in 2:101){
	nP[i,]<-t(m %*% nP[(i-1),])
}

matplot(log(nP), xlab="Time", ylab = "log Population Size");abline(h=1, col="grey")
eigen(m)

tot<-apply(nP,1,sum)
nP/tot

m2<-m
m3<-m
m4<-m
m5<-m

# by %
m4[1,]<-m[1,]*1.8
m5[5,]<-m[5,]*1.2

eigen(m)$value[1]
eigen(m4)$value[1]
eigen(m5)$value[1]






### ------------------------------------------------------------
### 123 lecture
pop_size = c(1000, 13, 10, 8, 5)
mx = c(0,0,0.407, 6.35, 57.1)
# LIFE TABLE
lt<-data.frame(
	age=c(0,1,2,3,4),
	pop_size = pop_size,
	mx=mx)

lt<-transform(lt, lx=pop_size/lt$pop_size[1])
lt<-transform(lt, lxmx = lx * mx)

plot(log10(pop_size)~ age, data =lt, type="b", ylab = "log Population Size", xlab = "Age",
	pch=21, bg="cornflowerblue", cex=2)

### ------------------------------------------------------------


# Assignment 2014

# INPUTS
pop_size = c(1000, 13, 10.4, 8.21, 5.7)
mx = c(0,0,0.407, 6.35, 57.1)

# LIFE TABLE
lt<-data.frame(
	age=c(0,1,2,3,4),
	a_class=c(NA,1,2,3,4),
	pop_size = pop_size,
	mx=mx)

lt<-transform(lt, lx=pop_size/lt$pop_size[1])
lt<-transform(lt, lxmx = lx * mx)
lt<-transform(lt, pi = c(NA,lx[2:5]/lx[1:4]))
lt<-transform(lt, Fi = pi*mx)
lt

sum(lt$lx*lt$mx)

# because THERE IS survival to age 4, we need an absorbing
# boundary to collect the counting of 4's
# Thus the matrix is 5 x 5

m<-rbind(
	c(lt$Fi[-1],0),
	c(lt$pi[2],0,0,0,0),
	c(0,lt$pi[3],0,0,0),
	c(0,0,lt$pi[4],0,0),
	c(0,0,0,lt$pi[5],0))

m
elasticity(m)
lambda(m)

n<-matrix(NA, 101,5)
n[1,]<-c(10,10,10,10,10) #n0, n1, n2, n3, n4

for(i in 2:101){
	n[i,]<-t(m %*% n[(i-1),])
}

matplot(log(n), type = "l")

mm2<-m
mm2[2,1]<-mm2[2,1]*2.8
mm3<-m
mm3[1,4]<-mm3[1,4]*2.8

lambda(m);lambda(mm2);lambda(mm3)


nP<-matrix(NA, 101,5)
nP[1,]<-c(10,10,10,10,10)

for(i in 2:101){
	nP[i,]<-t(mm2 %*% nP[(i-1),])
}

nF<-matrix(NA, 101,5)
nF[1,]<-c(10,10,10,10,10)

for(i in 2:101){
	nF[i,]<-t(mm3 %*% nF[(i-1),])
}

par(mfrow = c(1,3))

matplot(log(n), type = "l")
matplot(log(nP), type = "l", main = 'Surv Adj')
matplot(log(nF), type = "l", main = 'Fec Adj')
