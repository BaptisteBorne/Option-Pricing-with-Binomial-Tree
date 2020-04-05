
# MC pour Option Europ??enne

# payoff pr call
fcall<-function(S,K)
{
  return((pmax(S-K,0)))
}

#payoff pr put
fput<-function(S,K)
{
  return(pmax(K-S,0))
}

#fonction dans l'esp??rance
g<-function(So,r,s,Tm,x,typeopt,K)
{
  if (typeopt=="call")
  {
    return (exp(-r*Tm)*fcall(So*exp((r-0.5*s*s)*Tm+s*sqrt(Tm)*x),K))
  }
  else
  {
    return (exp(-r*Tm)*fput(So*exp((r-0.5*s*s)*Tm+s*sqrt(Tm)*x),K))
  }
}


#set.seed(123)
price<-function(So,K,r,s,Tm,typeopt,n)
{
  somme=0
  for (i in 1:n)
  {
    x=rnorm(1,0,1)
    print(g(So,r,s,Tm,x,typeopt,K))
    somme=somme+g(So,r,s,Tm,x,typeopt,K)
    #print(g(So,r,s,Tm,x, typeopt,K))
    #print(somme/n)
    #cat("g: ",g(So,r,s,Tm,x, typeopt,K)," et moy. : ", somme/i, "\n")
    
  }
  return(somme/n)
}


#on calcule le prix d'une option

price(50,52,0.05,0.7,2,"call",10000000)
price(50,52,0.05,0.7,2,"put",10000000)

price(30,29,0.05,0.2,1,"call",10)

price(30,29,0.05,0.3,1,"call",1000000)


# on plot un graphe pour observer la convergence qd n->+ifnty
m=300
# k=1:m
k=seq(0,30000,length=m)
l=1:m

for(i in 1:m)
{
  l[i]=price(50,52,0.05,0.7,2,"call",k[i])
}

df<-data.frame(k,l)
#plot(k,l, type="l")
ggplot(df, aes(k,l))+geom_line(size=0.3)
ggplot(df, aes(k,l))+geom_line(size=0.3,colour="darkblue")+geom_hline(yintercept = 19.9, linetype="dashed", colour="red")


#Reduction de variance

# variables antithetiques


priceAV<-function(So,K,r,s,Tm,typeopt,n)
{
  somme=0
  for (i in 1:n)
  {
    x=rnorm(1,0,1)
    somme=somme+(g(So,r,s,Tm,x,typeopt,K)+g(So,r,s,Tm,-x,typeopt,K))/2
    #print(g(So,r,s,Tm,x, typeopt,K))
    #print(somme/n)
    #cat("g: ",g(So,r,s,Tm,x, typeopt,K)," et moy. : ", somme/i, "\n")
    
  }
  return(somme/n)
}

priceAV(50,52,0.05,0.7,2,"call",10000)
priceAV(50,52,0.05,0.7,2,"put",10000)

# on plot un graphe pour observer la convergence qd n->+ifnty
m=300
# k=1:m
k=seq(0,30000,length=m)
l=1:m

for(i in 1:m)
{
  l[i]=priceAV(50,52,0.05,0.7,2,"call",k[i])
}

df<-data.frame(k,l)
#plot(k,l, type="l")
ggplot(df, aes(k,l))+geom_line(size=0.3)
ggplot(df, aes(k,l))+geom_line(size=0.3,colour="darkblue")+geom_hline(yintercept = 19.9, linetype="dashed", colour="red")


#on compare les variances

#variance avec la m??thode naive

varianceNaive<-function(So,r,s,Tm,typeopt,K,n)
{
  somme=0
  for(i in 1:n)
  {
    x=rnorm(1,0,1)
    y=rnorm(1,0,1)
    #print(g(So,r,s,Tm,x,typeopt,K))
    #print(g(So,r,s,Tm,y,typeopt,K))
    somme=somme+(g(So,r,s,Tm,x,typeopt,K)-g(So,r,s,Tm,y,typeopt,K))^2
    #print(somme)
  }
  return(sqrt(somme/(2*n)))
}

#variance avec la methode des var antithetiques

varianceAV<-function(So,r,s,Tm,typeopt,K,n)
{
  somme=0
  for (i in 1:n)
  {
    x=rnorm(1,0,1)
    y=rnorm(1,0,1)
    somme=somme+((g(So,r,s,Tm,x,typeopt,K)+g(So,r,s,Tm,-x,typeopt,K))/2-(g(So,r,s,Tm,y,typeopt,K)+g(So,r,s,Tm,-y,typeopt,K))/2)^2
  }
  return(somme/(2*n))
}


varianceNaive(50,0.05,0.7,2,"call",52,1000) 
varianceAV(50,0.05,0.7,2,"call",52,1000) 
varianceNaive(30,0.05,0.2,1,"call",29,100000)
varianceAV(30,0.05,0.2,1,"call",29,100000)


#Fonction d importance

priceFI<-function(So,K,r,s,Tm,typeopt,n)
{
  somme=0
  for (i in 1:n)
  {
    y=rnorm(1,s*sqrt(Tm),1)
    #somme=somme+(g(So,r,s,Tm,x,typeopt,K)+g(So,r,s,Tm,-x,typeopt,K))/2
    somme=somme+g(So,r,s,Tm,y,typeopt,K)*exp(-y^2/2)/exp(-(y-s*sqrt(Tm))^2/2)
  }
  return(somme/n)
}

#je plot la fct et on compare avec le produit
# on prend l'ex d 'un call
#
f_fois_g<-function(x){g(29,0.05,0.2,1,x,"call",30)*1/sqrt(2*pi)*exp(-x*x/2+0.2*sqrt(1)*x)}
fct_proche<-function(x){(g(29,0.05,0.2,1,x,"call",30)+30*exp(-0.05*1))*1/sqrt(2*pi)*exp(-x*x/2+0.2*sqrt(1)*x)}

f_fois_ggg<-function(x){g(29,0.05,0.2,1,x,"call",30)*1/sqrt(2*pi)*exp(-x*x/2)}
fct_proche_test<-function(x){g(29,0.05,0.2,1,x,"call",0)}*1/sqrt(2*pi)*exp(-x*x/2)

g(29,0.05,0.2,1,-2,"call",30)*1/sqrt(2*pi)*exp(-2*2/2)
f_fois_ggg(0.1)

ppp<- ggplot(data.frame(x = c(-10, 10)), aes(x = x)) + stat_function(fun =f_fois_ggg, colour="blue")+
  stat_function(fun =fct_proche_test, colour="red")
ppp

fonctiontest<-function(x)
  {
    if(2*x+1>0){
      return(2*x+1)
    }  
    else{
      return(0)
    }
  }
ggplot(data.frame(x = c(-10, 10)), aes(x = x)) + stat_function(fun =fonctiontest, colour="blue")

l=seq(-2,4,length=100)
l2=f_fois_ggg(l)
l2
f_fois_ggg(0)
f_fois_ggg(-2)
f_fois_ggg(1)
f_fois_ggg(2)

l=seq(-2,4,length=100)
l2=pmax(l,0)
l2
?max

df<-data.frame(l,l2)
#ggplot(df, aes(l,l2))+geom_line(size=0.3,colour="darkblue")
plot(df)
#ggplot(data.frame(l,l2),aes(l,l2))


priceFI(50,52,0.05,0.7,2,"call",100000)
priceFI(50,52,0.05,0.7,2,"put",100000)

priceFI(30,29,0.05,0.2,1,"call",100000)


#on compare les variances

#variance avec la m??thode naive

varianceNaive<-function(So,r,s,Tm,typeopt,K)
{
  n=500
  somme=0
  for(i in 1:n)
  {
    x=rnorm(1,0,1)
    y=rnorm(1,0,1)
    somme=somme+(g(So,r,s,Tm,x,typeopt,K)-g(So,r,s,Tm,y,typeopt,K))^2
  }
  return(somme/(2*n))
}


#variance avec la methode de la fct d importance
varianceFI<-function(So,r,s,Tm,typeopt,K,n)
{
  somme=0
  for (i in 1:n)
  {
    x=rnorm(1,s*sqrt(Tm),1)
    y=rnorm(1,s*sqrt(Tm),1)
    somme=somme+(g(So,r,s,Tm,x,typeopt,K)*exp(-x^2/2)/exp(-(x-s*sqrt(Tm))^2/2)-g(So,r,s,Tm,y,typeopt,K)*exp(-y^2/2)/exp(-(y-s*sqrt(Tm))^2/2))^2
  }
  return(sqrt(somme/(2*n)))
}

varianceFI(50,0.05,0.7,2,"call",52) 

varianceNaive(30,0.05,0.2,1,"call",29,100000)
varianceFI(30,0.05,0.2,1,"call",29,100000)



