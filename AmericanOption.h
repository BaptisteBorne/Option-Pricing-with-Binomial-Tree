//
//  AmericanOption.h
//  Binomial Tree
//
//  Created by Baptiste Borne on 24/12/2018.
//  Copyright © 2018 Baptiste Borne. All rights reserved.
//

#ifndef AmericanOption_h
#define AmericanOption_h

#include "BinomialTree.h"
#include <string>

class AmericanOption: public BinomialTree {
public:
    AmericanOption();
    AmericanOption(double So,double K,double T,double r,
                   double sigma,const std::string type = "call",int n = 1000);
    AmericanOption(const BinomialTree &opt, const std::string _type = "call");
    double price(); // virtual method
    void display(); // virtual method
    void setType(std::string type);
    std::string getType() const;
    virtual ~AmericanOption();
private :
    std::string type;
};



#endif /* AmericanOption_h */
