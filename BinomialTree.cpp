#include "BinomialTree.h"
#include <iostream>
#include <cmath>
#include <string>
using namespace std;

BinomialTree::BinomialTree(){
    
}
// on surcharge le constructeur
BinomialTree::BinomialTree(double _So,double _K,double _T,double _r,double _sigma,int n){
    So =_So;
    K = _K;
    T =_T;
    r = _r;
    sigma = _sigma;
    N = n;
}

// un opérateur pour pouvoir créer un binomial tree en disant simplement tree_nouveau =tree_existant
BinomialTree & BinomialTree::operator=(const BinomialTree & opt){
    So = opt.So;
    K = opt.K;
    T = opt.T;
    r = opt.r;
    sigma = opt.sigma;
    N = opt.N;
    return *this; // toujours ça pour un opérateur ...
}
// on enleve pour mettre la methode en "virtuelle pure" !
/* double BinomialTree::price(){
    cout<< "Option type is not defined" <<endl; // utile que pour les classes filles ... (?)
    // on pourrait mettre une methode virtuelle pure au lieu de faire ça ...
    return(0);
}
*/

double BinomialTree::getStock(int j, int n){ // valeur de l'action après j hausse et n-j baisse
    return So*Up(j)*Down(n-j);
}

// comprends pas l'erreur pour payOff ?

double BinomialTree::payOff(double S,double K, const string type)const // valeur intrinsèque de l'option ???
{
    if(type == "call")
        return((S-K)>0)?(S-K):0; // si (S-K)>0 on renvoie S-K, sinon on renvoie 0
    else
        return ((K-S)>0)?(K-S):0;
}

void BinomialTree::display(){
    cout<<"-----------------------------"<<endl;
    cout<<"Current price    : "<< So << " $"<< endl;
    cout<<"Strike           : "<< K << " $"<< endl;
    cout<<"Maturity         : "<< T << " years"<< endl;
    cout<<"Risk-free rate   : "<< r << endl;
    cout<<"Volatility       : "<< sigma << endl;
    cout<<"Number of steps  : "<< N <<endl;
    cout<<"============================="<<endl;
}

double BinomialTree::riskNeutralProb()const{
    return (exp(r*T/N)-Down(1))/(Up(1)-Down(1)) ;
    // calcule la proba de hausse dans l'univers risque-neutre
}

double BinomialTree::Up(int j) const {
    return pow(exp(sigma*sqrt(T/N)),j);
    
}

double BinomialTree::Down(int j) const {
    return pow(exp(-sigma*sqrt(T/N)),j);
    
}
void BinomialTree::setSigma(double sigma) {
    this->sigma = sigma;
}

// des accesseurs pour sigma, R, T, K, So, N

double BinomialTree::getSigma() const {
    return sigma;
}

void BinomialTree::setR(double r) {
    this->r = r;
}

double BinomialTree::getR() const {
    return r;
}

void BinomialTree::setT(double T) {
    this->T = T;
}

double BinomialTree::getT() const {
    return T;
}

void BinomialTree::setK(double K) {
    this->K = K;
}

double BinomialTree::getK() const {
    return K;
}

void BinomialTree::setSo(double So) {
    this->So = So;
}

double BinomialTree::getSo() const {
    return So;
}
void BinomialTree::setN(int N){
    this->N = N;
}

int BinomialTree::getN() const{
    return N;
}

// le destructeur
BinomialTree::~BinomialTree() {
    
}
