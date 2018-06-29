/**
 * @file
 * @copydetails skizException.h
 */
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

SKIZIndexException::SKIZIndexException(const std::string s) : SKIZException(s) {}
SKIZIndexException::~SKIZIndexException() throw() {};
const char* SKIZIndexException::what() {
    return msg.c_str();
}

SKIZIdenticalSeedsException::SKIZIdenticalSeedsException(const std::string s) : SKIZException(s) {}
SKIZIdenticalSeedsException::~SKIZIdenticalSeedsException() throw() {};
const char* SKIZIdenticalSeedsException::what() {
    return msg.c_str();
}

SKIZIOException::SKIZIOException(const std::string s) : SKIZException(s) {}
SKIZIOException::~SKIZIOException() throw() {};
const char* SKIZIOException::what() {
    return msg.c_str();
}