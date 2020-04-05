# MC pour digital option


# payoff pr call
fcall<-function(S,K)
{
  if (S-K>=0)
    {
      return (1)
    }
  else
    {
      return(0)
    }
}

#payoff pr put
fput<-function(S,K)
{
  if (K-S>=0)
  {
    return (1)
  }
  else
  {
    return(0)
  }  
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


somme=0
#set.seed(123)
price<-function(So,K,r,s,Tm,typeopt,n)
{
  for (i in 1:n)
  {
    x=rnorm(1,0,1)
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

price(100,100,0.05,0.2,1,"put",10000000)
price(100,100,0.05,0.2,1,"call",10000000)



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
ggplot(df, aes(k,l))+geom_line(size=0.3,colour="darkblue")+geom_hline(yintercept = 0.30, linetype="dashed", colour="red")
?geom_line

