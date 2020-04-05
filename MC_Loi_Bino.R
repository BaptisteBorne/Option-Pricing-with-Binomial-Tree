# MC version discr??te

# fonction d importance

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

#fonction dans l esp
phi<-function(K,S,typeopt)
  {
    if (typeopt=="call")
    {
        return(fcall(S,K))
    }
    if (typeopt=="put")
    {
        return(fput(S,K))
    }
  
  }

# fonction pour simuler une loi binomiale de parametre N et p*
# en utilisant N bernoulli

binomiale<-function(p,N){
  s=0
  for(i in 1:N)
  {
    u=runif(1)
    
    if(u<=p)
    {
      s=s+1
    }
    else
    {
      s=s  
    }
  }
  return(s)
}

Binomiale(0.3,200)

#Estimation de la variance via la simulation de n binomiales

# d abord avec pstar

variancestar<-function(So,K,N,typeopt,Tm,sigma, r, retour="var",n=1000)
{
  up=exp(sigma*sqrt(Tm/N))
  #print(up)
  down=exp(-sigma*sqrt(Tm/N))
  pstar=(exp(r*(Tm/N))-down)/(up-down)
  #print(pstar)
  somme=0
  sommeesp=0
  #n=1000
  for (i in 1:n)
  {
    a=binomiale(pstar,N) #nombre de up
    up=exp(sigma*sqrt(Tm/N))
    b=So*up^(a)*down^(N-a) #Sn
    #print(b)
    fi=(1+r/N)^(-N)*phi(K,b,typeopt)
    sommeesp=sommeesp+fi
    
    a2=binomiale(pstar,N)
    b2=So*up^(a2)*down^(N-a2)
    #print(b2)
    fi2=(1+r/N)^(-N)*phi(K,b2,typeopt)
    #print((fi-fi2)^2)
    somme=somme+(fi-fi2)^2
    
  }
  if (retour=="var")
  {
    return(sqrt(somme/(2*n)))
  }
  if (retour=="esp")
  {
    return(sommeesp/n)
  }
  
  
}

#variance avec fct de vraisemblance
#on teste pour plusieurs p possibles

variancep<-function(So,K,N,typeopt,Tm,sigma, r,p,retour="var",n=1000)
{
  up=exp(sigma*sqrt(Tm/N))
  down=exp(-sigma*sqrt(Tm/N))
  somme=0
  sommeesp=0
  #n=1000
  for (i in 1:n)
    {
      a=binomiale(p,N) #nombre de up
      
      pstar=(exp(r*Tm/N)-down)/(up-down)
      b=So*up^a*down^(N-a) #Sn
      fi=(1+r/N)^(-N)*phi(K,b,typeopt)
      #probastar=factorial(N)/(factorial(a)*factorial(N-a))*pstar^(a)*(1-pstar)^(N-a)
      #proba=factorial(N)/(factorial(a)*factorial(N-a))*p^(a)*(1-p)^(N-a)
      probastar=choose(N,a)*pstar^(a)*(1-pstar)^(N-a)
      proba=choose(N,a)*p^(a)*(1-p)^(N-a)
      truc=probastar*fi/proba
      sommeesp=sommeesp+truc
      
      
      a2=binomiale(p,N) #nombre de up
      b2=So*up^(a)*down^(N-a) #Sn
      fi2=phi(K,b,typeopt)
      #probastar2=factorial(N)/(factorial(a2)*factorial(N-a2))*pstar^(a2)*(1-pstar)^(N-a2)
      #proba2=factorial(N)/(factorial(a2)*factorial(N-a2))*p^(a2)*(1-p)^(N-a2)
      probastar2=choose(N,a2)*pstar^(a2)*(1-pstar)^(N-a2)
      proba2=choose(N,a2)*p^(a2)*(1-p)^(N-a2)
      truc2=probastar2*fi2/proba2
      #print(truc)
      #print(truc2)
      somme=somme+(truc-truc2)^2
  }
  if (retour=="var")
  {
    return(sqrt(somme/(2*n)))
  }
  if (retour=="esp")
  {
    return(sommeesp/n)
  }

}


variancep(29,30,365,"call",1,0.1, 0.05,0.5,"esp",n=6000)

variancep(31,30,100,"call",1,0.2, 0.05,0.4,"esp",n=30000)
variancestar(31,30,100,"call",1,0.2, 0.05, "esp")

variancep(40,30,100,"call",1,0.2, 0.05,0.2,"esp",n=5000)
variancestar(40,30,100,"call",1,0.2, 0.05, "var", n=10000)

variancestar(40,30,100,"call",1,0.2, 0.05, "esp", n=10000)
variancep(40,30,100,"call",1,0.2, 0.05,0.5,"esp",10000)

variancestar(40,30,100,"call",1,0.2, 0.05, "var", n=10000)
variancep(40,30,100,"call",1,0.2, 0.05,0.507,"var",10000)


l=20
liste=seq(0,1,length.out = l)
liste=seq(0.47,0.54,length.out = l)
varliste=seq(0,1,length.out = l)
varliste=seq(0.47,0.54,length.out = l)

for (i in 1:l)
{
  u=variancep(40,30,100,"call",1,0.2, 0.05,liste[i],"esp",3000)
  #print(u)
  varliste[i]=u
}
varliste
plot(data.frame(liste, varliste))



#variance de contr??le

nombre=400
p=0.5
up=1.01
down=0.99
listeabs=1:100
Szero=32
N=300
listetesth=1:100
listetestf=1:100
K=30

for (i in 1:nombre)
  {
    u=binomiale(p,N)
    listetesth[i]=Szero*up^(u)*down^(N-u)-K
    listetestf[i]=max(Szero*up^(u)*down^(N-u)-K,0)
    
  }

plot(data.frame(listeabs,listetest))
listeabs
listetestf

?hist

hist(listetesth)
hist(listetestf)
hist(listetestf-listetesth)
?var

var(listetestf)
var(listetestf-listetesth)
#??a reduit

variancecontrolCall<-function(So,K,N,Tm,sigma, r,retour="var", n=1000)
{
  up=exp(sigma*sqrt(Tm/N))
  down=exp(-sigma*sqrt(Tm/N))
  pstar=(exp(r*Tm/N)-down)/(up-down)
  #print(pstar)
  sommevar=0
  sommeesp=0
  #n=1000
  for (i in 1:n)
  {
    a=binomiale(pstar,N) #nombre de up
    b=So*up^(a)*down^(N-a) #Sn
    fi=(1+r/N)^(-N)*phi(K,b,"put") # f(St)-h(St)=(K-St)+ =payoff d un put (f payoff call)
    #print(fi)
    sommeesp=sommeesp+fi
    
    a2=binomiale(pstar,N)
    b2=b=So*up^(a2)*down^(N-a2)
    fi2=(1+r/N)^(-N)*phi(K,b2,"put")
    
    sommevar=sommevar+(fi-fi2)^2
  }
  if (retour=="var")
  {
    return(sqrt(sommevar/(2*n)))
  }
  if (retour=="esp")
  {
    #print(So-K/((1+r/N)^(N)))
    #print(sommeesp/n)
    return(sommeesp/n+So-K/((1+r/N)^(N)))  
  }
  
}

variancestar(31,30,100,"call",1,0.2,0.05,"esp",40000)

variancecontrolCall(25,30,100,1,0.2,0.05,"var",30000)
variancestar(25,30,100,"call",1,0.2,0.05,"var",30000)

variancecontrolCall(31,30,100,1,0.2,0.05,"var",30000)
variancestar(31,30,100,"call",1,0.2,0.05,"var",30000)

variancecontrolCall(29,30,200,1,0.1,0.05,"var")
variancecontrolCall(29,30,200,1,0.1,0.05,"esp",10)

variancecontrolCall(31,30,200,1,0.1,0.05,"esp",2000)
variancestar(31,30,200,"call",1,0.1, 0.05,"esp",2000)

variancecontrolCall(31,30,200,1,0.1,0.05,"var",2000)
variancestar(31,30,200,"call",1,0.1, 0.05,"var",2000)

variancecontrolCall(31,30,100,1,0.1,0.05,"var",200)
variancestar(31,30,100,"call",1,0.1, 0.05,"var",200)

variancestar(29,30,200,"call",1,0.1, 0.05,"var")
variancestar(29,30,200,"call",1,0.1, 0.05,"esp")
#le r n est plus le m??me ... c'est le taux sur une p??riode, pas le taux continu ?

#on trace les valeurs obtenus pour le prix du call avec m??thode classique et avec m??thode variable de contr??le
# et des intevalles de confiance autour ...

l=seq(600,10000,by = 50)
#l=seq(1,1000,length.out = 20)
l
length(l)
lc=1:189
lstar=1:189
for (i in 1:189)
{
  lc[i]=variancecontrolCall(31,30,100,1,0.2,0.05,"esp",l[i])
  lstar[i]=variancestar(31,30,100,"call",1,0.2,0.05,"esp",l[i])
  
}
lc
lstar


plot(data.frame(l,l2))
plot(data.frame(l[2:30],l2[2:30]))

l=l[2:20]
lc=lc[2:20]

df=data.frame(l,lc)
df
ggplot(data=df, aes(x=l,y=lc))+geom_point()
dfstar=data.frame(l,lstar)
ggplot(data=dfstar, aes(x=l,y=lstar))+geom_point()
#----------->
dftot=data.frame(l,lc,lstar,lower=lc-2.34*1.96/sqrt(l),upper=lc+2.34*1.96/sqrt(l), lower2=lstar-4.8*1.96/sqrt(l),upper2=lstar+4.8*1.96/sqrt(l))
dftot_test=data.frame(l,lc,lstar,lower=3.78-2.34*1.96/sqrt(l),upper=3.78+2.34*1.96/sqrt(l), lower2=3.78-4.8*1.96/sqrt(l),upper2=3.78+4.8*1.96/sqrt(l))
#----------->
#ggplot(data=dftot, aes(x=l,y=lstar,y2=lc))+geom_point()
#ggplot(data=dftot, aes(x=l,y=rbind(lc,lstar)))+geom_point(l,lc)
#ggplot(data.frame(x = c(0,4)), aes(x = x)) +geom_point(data=dfstar,aes(l,ls),colour="darkblue")

ggplot(data.frame(x = c(0, 4)), aes(x = x)) +geom_line(data=dftot,aes(l,lstar),colour="darkblue")+geom_line(data=dftot,aes(l,lc),colour="red")

ggplot() +geom_path(data=dftot,aes(l,lstar),colour="darkblue",show.legend = TRUE, size=1/3)+geom_path(data=dftot,aes(l,lc),colour="red", show.legend = TRUE, size=1/3) +geom_hline(yintercept = 3.803, color="black", linetype="dashed",size=0.75)+ggtitle("Prix d'un call en fonction du nombre de v.a simulees")+xlab("nb de v.a. simulees")+ylab("estimation call price")+geom_label() 
#+geom_ribbon(data=dftot, aes(ymin=lower, ymax=upper, x=l, fill = "band"),alpha = 0.3, fill="darkseagreen4")

#------------->
ggplot() +geom_path(data=dftot,aes(l,lstar),colour="darkblue",show.legend = TRUE, size=0.4)+geom_path(data=dftot,aes(l,lc),colour="red", show.legend = TRUE, size=0.4)+ggtitle("Prix d'un call en fonction du nombre de v.a simulees")+xlab("nb de v.a. simulees")+ylab("estimation call price")+geom_label() +geom_hline(yintercept = 3.78, color="black", linetype="dashed",size=0.75)+geom_ribbon(data=dftot, aes(ymin=lower, ymax=upper, x=l, fill = "band"),alpha = 0.3, fill="indianred2")+geom_ribbon(data=dftot, aes(ymin=lower2, ymax=upper2, x=l, fill = "band"),alpha = 0.3, fill="lightskyblue3")+xlim(600,10000)

ggplot() +geom_path(data=dftot_test,aes(l,lstar),colour="darkblue",show.legend = TRUE, size=0.4)+geom_path(data=dftot_test,aes(l,lc),colour="red", show.legend = TRUE, size=0.4)+ggtitle("Prix d'un call en fonction du nombre de v.a simulees")+xlab("nb de v.a. simulees")+ylab("estimation call price")+geom_label() +geom_hline(yintercept = 3.78, color="black", linetype="dashed",size=0.75)+geom_ribbon(data=dftot_test, aes(ymin=lower, ymax=upper, x=l, fill = "band"),alpha = 0.3, fill="indianred2")+geom_ribbon(data=dftot_test, aes(ymin=lower2, ymax=upper2, x=l, fill = "band"),alpha = 0.3, fill="lightskyblue3")+xlim(600,10000)

?geom_path

?geom_label

geom
?geom_point
?ggplot
?geom_curve
?geom_hline
?geom_ribbon

#on fait la m??me chose mais avec la m??thode d echantillonage

l=seq(100,5000,by = 70)
#l=seq(1,1000,length.out = 20)
l
length(l)
lpref=1:71
lstar=1:71
for (i in 1:71)
{
  lpref[i]=variancep(40,30,100,"call",1,0.2, 0.05,0.507,"esp",l[i])
  lstar[i]=variancestar(40,30,100,"call",1,0.2,0.05,"esp",l[i])
  
}
lpref
lstar

dftot=data.frame(l,lpref,lstar,lower=lpref-3.69/sqrt(l),upper=lpref+3.69/sqrt(l), lower2=lstar-3.69/sqrt(l),upper2=lstar+3.69/sqrt(l))
ggplot() +geom_path(data=dftot,aes(l,lstar),colour="darkblue",show.legend = TRUE, size=1/3)+geom_path(data=dftot,aes(l,lpref),colour="red", show.legend = TRUE, size=1/3) +geom_hline(yintercept = 11.6, color="black", linetype="dashed",size=0.75)+ggtitle("Prix d'un call en fonction du nombre de v.a simulees")+xlab("nb de v.a. simulees")+ylab("estimation call price") 

