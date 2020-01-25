//
//  Europe.h
//  Binomial Tree
//
//  Created by Baptiste Borne on 21/02/2019.
//  Copyright © 2019 Baptiste Borne. All rights reserved.
//

#ifndef EuropeanOption_h
#define EuropeanOption_h


#include "BinomialTree.h"
#include <string>
#include <vector>

class EuropeanOption: public BinomialTree {
public:
    EuropeanOption();
    EuropeanOption(double So,double K,double T,double r,
                   double sigma,const std::string type = "call",int n = 1000);
    EuropeanOption(const BinomialTree &opt, const std::string _type = "call");
    double price(); // virtual method
    void display(); // virtual method
    void setType(std::string type);
    std::string getType() const;
    virtual ~EuropeanOption();
    private :
    std::string type;
};


#endif /* EuropeanOption_h */
