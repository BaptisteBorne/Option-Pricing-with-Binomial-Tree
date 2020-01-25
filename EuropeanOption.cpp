//
//  Europe.cpp
//  Binomial Tree
//
//  Created by Baptiste Borne on 21/02/2019.
//  Copyright © 2019 Baptiste Borne. All rights reserved.
//

#include "EuropeanOption.h"
#include "BinomialTree.h"
#include <iostream>
#include <cmath>
#include <string>
#include <vector>

using namespace std;



EuropeanOption::EuropeanOption(){}

// constructeur avec en argument un arbre BinomialTree (opt) et le type d'option
EuropeanOption::EuropeanOption(const BinomialTree &opt,const string _type):BinomialTree(opt.getSo(),opt.getK(),opt.getT(),opt.getR(),opt.getSigma(),opt.getN()),
type(_type){
}

// constructeur avec en arguments les infos de départ (So, K, T, sigma ...) et le type d'option
EuropeanOption::EuropeanOption(double So,double K,double T,double r,
                               double sigma,const string _type,
                               int n):BinomialTree(So,K,T,r,sigma,n),type(_type){
}

//méthode avec pointeurs
/*
double EuropeanOption::price(){
    // BinomialTree::getN ... bizarre ... les méthodes sont héritées nn ?......
    double  *v= new double[BinomialTree::getN()+1]; // ptr vers un tableau de 'doubles' de N+1 valeurs
    // pointeur vers un tableau statique (unidimensionel)
    double p = riskNeutralProb();     // proba risque neutre
    
    // on calcule les payoffs finaux (dernière colonne de l'arbre)
    // on calcule en premier le payoff avec que des baisses puis on remonte jusqu'au payoff avec que des ups
    for(int j=0;j<=N;++j)  {      // boucle -> N+1 itérations (de 0 up à N up)
        *(v+j)= payOff(getStock(j,N), // getStock -> val de l'action après j up et n-j down
                       K,type);       // et on calcule le payoff final (fin de l'arbre) pour le cas j up n-j down
    }
    
    // Calcul  de la V.A. des pay-off récursivement en commençant du dernier élément du tableau au premier. (de i=n-1 à i=0)
    // on se place d'abord sur la colonne précédente, en diminuant i (i correspond au numéro de la période sur laquelle on se place, donc à la somme "dynamique" des ups and downs)
    // deuxième boucle : on commence à j=O (i.e 0 ups, que des downs -> dernière case de la colonne sur laquelle on se place)
    
    for(int i= N-1;i>=0;--i){
        for(int j=0;j<=i;++j){
            *(v+j)=(p*(*(v+j+1))+(1-p)*(*(v+j)))*exp(-r*T/N);
        }
    }
    return *v;
}
*/


//méthode sans pointeurs
 /*
double EuropeanOption::price(){
    double prob = riskNeutralProb();
 
    double table[N+1];
    // bien comprendre le fait qu'en mettant les attributs de la mère en protected, on peut les utiliser sans accesseurs dans les classes filles !!!!!
    for (int compteur=0; compteur <=N; compteur++){
        table[compteur]=payOff(getStock(N-compteur,N),K,type);
        }
    for (int col=1;col<=N;col++){
        for (int index=0; index<=N-col; index++){
            table[index]=(prob*table[index]+(1-prob)*table[index+1])*exp(-r*T/N);
                }
            }
    return table[0];
}
*/
//essai sans pointeurs avec un tableau dynamique

// bien comprendre le fait qu'en mettant les attributs de la mère en protected, on peut les utiliser sans accesseurs dans les classes filles !!!!!


double EuropeanOption::price(){
    double prob = riskNeutralProb();
    
    vector<double> table(N+1);
    
    for (int compteur=0; compteur <=N; compteur++){
        table[compteur]=payOff(getStock(N-compteur,N),K,type);
    }
    for (int col=1;col<=N;col++){
        for (int index=0; index<=N-col; index++){
            table[index]=(prob*table[index]+(1-prob)*table[index+1])*exp(-r*T/N);
        }
        table.pop_back();
    }
    return table[0];
}


void EuropeanOption::display(){
    BinomialTree::display(); // on ré-affiche les paramètre utilisés + la valeur calculée par la méthode binomiale
    cout<<"-----------------------------"<<endl;
    cout<<"Value of European "<<type <<" : "<<price()<< " $"<<endl;
    cout<<"-----------------------------"<<endl;
    
}
void EuropeanOption::setType(std::string type) {
    this->type = type;
}
// pq besoin de passer par this-> ???
// à cause des 2 "types" ???
// on ne le met pas pour l'acceseur de type ci-dessous ...

std::string EuropeanOption::getType() const {
    return type;
}

EuropeanOption::~EuropeanOption(){
}
