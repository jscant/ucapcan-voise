//
// Created by root on 15/06/18.
//

#ifndef SKIZ_SKIZEXCEPTION_H
#define SKIZ_SKIZEXCEPTION_H
#include <exception>

class skizException : public std::exception{
    const char* what() const throw(){
        return "Skiz exception";
    }
};


#endif //SKIZ_SKIZEXCEPTION_H
