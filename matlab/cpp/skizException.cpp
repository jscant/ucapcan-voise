
#ifndef SKIZEXCEPTION_H
#define SKIZEXCEPTION_H
#include "skizException.h"
#endif

SKIZException::SKIZException(const std::string s) : msg(s) {}
SKIZException::~SKIZException() throw() {};
const char* SKIZException::what() {
    return msg.c_str();
}

SKIZLinearSeedsException::SKIZLinearSeedsException(const std::string s) : SKIZException(s) {}
SKIZLinearSeedsException::~SKIZLinearSeedsException() throw() {};
const char* SKIZLinearSeedsException::what() {
    return msg.c_str();
}

SKIZIndexError::SKIZIndexError(const std::string s) : SKIZException(s) {}
SKIZIndexError::~SKIZIndexError() throw() {};
const char* SKIZIndexError::what() {
    return msg.c_str();
}

SKIZIdenticalSeedsError::SKIZIdenticalSeedsError(const std::string s) : SKIZException(s) {}
SKIZIdenticalSeedsError::~SKIZIdenticalSeedsError() throw() {};
const char* SKIZIdenticalSeedsError::what() {
    return msg.c_str();
}