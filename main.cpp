//
//  main.cpp
//  Binomial Tree
//
//  Created by Baptiste Borne on 24/12/2018.
//  Copyright © 2018 Baptiste Borne. All rights reserved.
//

#include <iostream>
#include <cmath>
#include <vector>
#include <ctime>

#include "BinomialTree.h"
#include "AmericanOption.h"

#include "EuropeanOption.h"

using namespace std;

int main(){
/*
    cout<< "Valeur sous-jacent à t=0 : " ;
    double So_user;
    cin>>So_user;
    cout<< "Strike : ";
    double K_user;
    cin>>K_user;
    cout<< "Risk-free rate : ";
    double r_user;
    cin>> r_user;
    cout<< "Maturité option : ";
    double T_user;
    cin>>T_user;
    cout<< "Volatilité : ";
    double sigma_user;
    cin>> sigma_user;
    cout<< "Nombre de sous-périodes : ";
    double N_user;
    cin>> N_user;
    */
    // pr l instant on prend un call americain
    clock_t t;
    t=clock();
   
    //AmericanOption optionA(So_user,K_user, T_user, r_user,
     //                      sigma_user,"call",N_user);
    
    //optionA.display();
   
    
    AmericanOption optionA(50,52,2,0.05,0.7,"put",10000);
    //EuropeanOption optionB(50,52,2,0.05,0.7,"put",10000);
    optionA.display();
    //optionB.display();
    
    //EuropeanOption optiontest(25,30,1,0.05,0.2,"call",100);
    //optiontest.display();
    
    t=clock()-t;
    cout<<"..................................."<<endl;
    cout<<"Calculation time: " << ((float)t)/CLOCKS_PER_SEC<< " secondes" <<endl;
    cout<<"..................................."<<endl;
    
    return 0;
}
