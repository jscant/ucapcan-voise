/**
* @file
* @brief Exception class for SKIZ Operator Tool
*/

#include "skizException.h"

SKIZException::SKIZException(const std::string s) : msg(s) {}
SKIZException::~SKIZException() throw() {};
const char* SKIZException::what() {
    return msg.c_str();
}

SKIZLinearSeedsException::SKIZLinearSeedsException(
        const std::string s) : SKIZException(s) {}
SKIZLinearSeedsException::~SKIZLinearSeedsException() throw() {};
const char* SKIZLinearSeedsException::what() {
    return msg.c_str();
}

SKIZIndexException::SKIZIndexException(
        const std::string s) : SKIZException(s) {}
SKIZIndexException::~SKIZIndexException() throw() {};
const char* SKIZIndexException::what() {
    return msg.c_str();
}

SKIZIdenticalSeedsException::SKIZIdenticalSeedsException(
        const std::string s) : SKIZException(s) {}
SKIZIdenticalSeedsException::~SKIZIdenticalSeedsException() throw() {};
const char* SKIZIdenticalSeedsException::what() {
    return msg.c_str();
}

SKIZIOException::SKIZIOException(
        const std::string s) : SKIZException(s) {}
SKIZIOException::~SKIZIOException() throw() {};
const char* SKIZIOException::what() {
    return msg.c_str();
}

SKIZProposition2Exception::SKIZProposition2Exception(
        const std::string s) : SKIZException(s) {}
SKIZProposition2Exception::~SKIZProposition2Exception() throw() {};
const char* SKIZProposition2Exception::what() {
    return msg.c_str();
}