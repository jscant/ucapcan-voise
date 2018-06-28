
#ifndef EXCEPTION_H
#define EXCEPTION_H
#include <exception>
#endif

#ifndef STRING_H
#define STRING_H
#include <string>
#endif

class SKIZException : public std::exception {
private:
    std::string  msg;
public:
    SKIZException(const std::string s);
    virtual ~SKIZException() throw();
    const char* what();
};

class SKIZLinearSeedsException : public SKIZException {
private:
    std::string msg;
public:
    SKIZLinearSeedsException(const std::string s);
    virtual ~SKIZLinearSeedsException() throw();
    const char* what();
};

class SKIZIndexError : public SKIZException {
private:
    std::string msg;
public:
    SKIZIndexError(const std::string s);
    virtual ~SKIZIndexError() throw();
    const char* what();
};

class SKIZIdenticalSeedsError : public SKIZException {
private:
    std::string msg;
public:
    SKIZIdenticalSeedsError(const std::string s);
    virtual ~SKIZIdenticalSeedsError() throw();
    const char* what();
};

class SKIZIOError : public SKIZException {
private:
    std::string msg;
public:
    SKIZIOError(const std::string s);
    virtual ~SKIZIOError() throw();
    const char* what();
};


//#endif //SKIZ_SKIZEXCEPTION_H
