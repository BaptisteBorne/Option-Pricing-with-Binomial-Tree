//
//  BinomialTree.h
//  Binomial Tree
//
//  Created by Baptiste Borne on 24/12/2018.
//  Copyright © 2018 Baptiste Borne. All rights reserved.
//

#ifndef BinomialTree_h
#define BinomialTree_h
#include <string>


class BinomialTree
{
public:
    BinomialTree();
    BinomialTree(double _So,double _K,double _T,double _r,
                    double _sigma,int _n = 1000);
    BinomialTree & operator=(const BinomialTree & opt);
    virtual double price()=0; //  méthode virtuelle pure, n'a pas de corps ! Csq : on est dans une classe abstraite, on ne peut pas en créer d'instance !
    virtual void display();
    // polymorphisme ! > besoin de virtual + d'un pointeur/référence ...
    // ces deux méthodes serront redéfinis dans les classes filles
    // dans la fonction price, on utilise des pointeurs dans la boucle for pour remplir un tableau permettant l'allocation dynamique de mémoire pour N+1 valeurs, les valeurs de l'option. Mais on peut aussi utiliser la librairie vector !
    // Il faudra faire les deux versions ?
    
    double riskNeutralProb()const;
    void setSigma(double sigma);
    double getSigma() const;
    void setR(double r);
    double getR() const;
    void setT(double T);
    double getT() const;
    void setK(double K);
    double getK() const;
    void setSo(double So);
    double getSo() const;
    int getN() const;
    void setN(int N);
    virtual ~BinomialTree();
    
    
protected:
    // outils intermédiaires, on ne veut pas que l'utilisateur final y aie accès, mais on veut que les classes héritées puissent en faire usage !
    double payOff(double S,double K, const std::string type = "call")const;
    double getStock(int j,int n);
    double Up(int j)const;
    double Down(int j)const;
    

//private:
    double So; // prix actuel du sous-jacent
    double K; // strike
    double r; // risk-free rate of interest (univers risque-neutre ...)
    double T; // maturuté
    double sigma; // volatilité
    int N; // nbs d'itérations (nbs de sous-périodes)
    
};



#endif /* BinomialTree_h */
