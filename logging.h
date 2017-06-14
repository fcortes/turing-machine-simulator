#ifndef _LOGGING_H
#define _LOGGING_H

#include <iostream>

/*
LOGS
*/

#define DEBUG_INFO __PRETTY_FUNCTION__ << ":" << __LINE__

#define LOG_DEBUG(message) \
if (false) {\
  std::cout << "\033[2;32m" << __func__ << ":" << __LINE__ << "\t" << message << "\033[0m" << std::endl;\
}

#define LOG_WARNING(message) std::cout << "\033[2;35m" << "[WARN] " << "\033[0m\033[1;35m" << message << "\033[0m" << std::endl;
#define LOG_ERROR(message) std::cout << "\033[2;31m" << "[ERROR] " << "\033[0m\033[1;31m" << message << "\033[0m" << std::endl;
#define LOG_INFO(message) std::cout << "\033[2;37m" << "[INFO] " << "\033[0m\033[1;37m" << message << "\033[0m" << std::endl;

#define LOG(level, message) \
LOG_##level("[" << #level << "]  " << message)

#endif
