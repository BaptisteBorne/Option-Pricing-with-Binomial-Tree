import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import norm

def payoff_fixedstrike_lookback(strike,nb_euler,arraystock):
    return max(max(arraystock)-strike,0)

def price_fixekstrike_lookback(So,K,T,n,Nmc,s,r):
    liste_t=np.linspace(0,T,n)
    liste_S_Euler=np.zeros(n) #n+1 ?
    liste_S_Euler[0]=So
    sum=0
    for i in range(Nmc): #pour chaque simulation de MC:
        for j in range(1,n):   #on simule un trajet pr la stock en simulant des normales indep à chaque time step
            BM_simu=norm.rvs(0,1,1)
            liste_S_Euler[j]=liste_S_Euler[j-1]+r*liste_S_Euler[j-1]*(liste_t[j]-liste_t[j-1])+s*liste_S_Euler[j-1]*(liste_t[j]-liste_t[j-1])*BM_simu
        #print(i,liste_S_Euler)
        print(max(liste_S_Euler))
        sum=sum+payoff_fixedstrike_lookback(K,n,liste_S_Euler)
    return sum/Nmc
    

print(price_fixekstrike_lookback(30,29,2,100,100,0.2,0.05))