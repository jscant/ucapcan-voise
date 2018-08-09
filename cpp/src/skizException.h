/**
 * @file
 * @copydetails skizException.cpp
 */

#ifndef SKIZEXCEPTION_H
#define SKIZEXCEPTION_H

#include <exception>
#include <string>

/**
 * @brief Parent class for all SKIZ exceptions
 * @param s Message to be given when thrown
 */
class SKIZException : public std::exception {
private:
    /// Stores message to be thrown
    std::string  msg;
public:
    /// Constructor takes string as argument which is stored in msg
    SKIZException(const std::string s);

    /// Destructor
    virtual ~SKIZException() throw();

    /// Extract message stored in msg
    const char* what();
};

/**
 * @brief Thrown by circumcentre if input coordinates form a line
 * @param s Message to be given when thrown
 */
class SKIZLinearSeedsException : public SKIZException {
private:
    /// Stores message to be thrown
    std::string msg;
public:
    /// Constructor takes string as argument which is stored in msg
    SKIZLinearSeedsException(const std::string s);

    /// Destructor
    virtual ~SKIZLinearSeedsException() throw();

    /// Extract message stored in msg
    const char* what();
};

/**
 * @brief Thrown when trying to access a non-existent entry in a std::vector or std::map
 * @param s Message to be given when thrown
 */
class SKIZIndexException : public SKIZException {
private:
    /// Stores message to be thrown
    std::string msg;
public:
    /// Constructor takes string as argument which is stored in msg
    SKIZIndexException(const std::string s);

    /// Destructor
    virtual ~SKIZIndexException() throw();
    const char* what();

    /// Extract message stored in msg
};

/**
 * @brief Thrown if addSeed is given a seed to add to Voronoi diagram where one already exists
 * @param s Message to be given when thrown
 */
class SKIZIdenticalSeedsException : public SKIZException {
private:
    /// Stores message to be thrown
    std::string msg;
public:
    /// Constructor takes string as argument which is stored in msg
    SKIZIdenticalSeedsException(const std::string s);

    /// Destructor
    virtual ~SKIZIdenticalSeedsException() throw();

    /// Extract message stored in msg
    const char* what();
};

/**
 * @brief Thrown in case of failure to open a file for reading or writing
 * @param s Message to be given when thrown
 */
class SKIZIOException : public SKIZException {
private:
    /// Stores message to be thrown
    std::string msg;
public:
    /// Constructor takes string as argument which is stored in msg
    SKIZIOException(const std::string s);

    /// Destructor
    virtual ~SKIZIOException() throw();

    /// Extract message stored in msg
    const char* what();
};

/**
 * @brief Thrown in case of unexpected behaviour in proposition2.cpp
 * @param s Message to be given when thrown
 */
class SKIZProposition2Exception : public SKIZException {
private:
    /// Stores message to be thrown
    std::string msg;
public:
    /// Constructor takes string as argument which is stored in msg
    SKIZProposition2Exception(const std::string s);

    /// Destructor
    virtual ~SKIZProposition2Exception() throw();

    /// Extract message stored in msg
    const char* what();
};

#endif
