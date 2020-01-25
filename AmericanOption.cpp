#include "AmericanOption.h"
#include "BinomialTree.h"
#include <iostream>
#include <cmath>
#include <string>

using namespace std;


// constructeur sans rien, quel intérêt ???
AmericanOption::AmericanOption(){}

// constructeur avec en argument un arbre BinomialTree (opt) et le type d'option
AmericanOption::AmericanOption(const BinomialTree &opt,const string _type):BinomialTree(opt.getSo(),opt.getK(),opt.getT(),opt.getR(),opt.getSigma(),opt.getN()),
                        type(_type){
}

// constructeur avec en arguments les infos de départ (So, K, T, sigma ...) et le type d'option
AmericanOption::AmericanOption(double So,double K,double T,double r,
                               double sigma,const string _type,
                               int n):BinomialTree(So,K,T,r,sigma,n),type(_type){
}


double AmericanOption::price(){
    double  *v= new double[N+1]; // ptr vers un tableau de 'doubles' de N+1 valeurs
    // pointeur vers un tableau statique (unidimensionel)
    double Sij;                                     
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
            Sij = payOff(getStock(j,i),K,type); // 2 lignes propres aux options américaines
            *(v+j)=(*(v+j)> Sij)?(*(v+j)): Sij; // on compare la valeur en utilisant la formule avec la valeur si on exerce maintenant (val intinsèque).
        }
    }
    return *v;
}

void AmericanOption::display(){
    BinomialTree::display(); // on ré-affiche les paramètre utilisés + la valeur calculée par la méthode binomiale
    cout<<"-----------------------------"<<endl;
    cout<<"Value of American "<<type <<" : "<<price()<< " $"<<endl;
    cout<<"-----------------------------"<<endl;

}
void AmericanOption::setType(std::string type) {
    this->type = type;
}
// pq besoin de passer par this-> ???
// à cause des 2 "types" ???


std::string AmericanOption::getType() const {
    return type;
}

AmericanOption::~AmericanOption(){
}
