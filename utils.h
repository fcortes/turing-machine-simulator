#ifndef _UTILS_H
#define _UTILS_H

/*
Hash of a pair
*/
struct pair_hash {
    template <class T1, class T2>
    std::size_t operator () (const std::pair<T1,T2> &p) const {
        auto h1 = std::hash<T1>{}(p.first);
        auto h2 = std::hash<T2>{}(p.second);

        return h1 ^ h2;
    }
};

/*
CHECKS
*/

#define CHECK(cond, message) \
if (!(cond)) { \
  std::cerr << "\033[1;31m[FATAL ERROR]  " << #cond << " : " << message << "\033[0m" << std::endl << "\t\t" << std::endl; \
  std::abort(); \
}

/*
Strings
*/

#include <sys/stat.h>
#include <errno.h>
#include <string>

bool pathIsDir(const std::string& filePath) {
  int status;
  struct stat st_buf;

  status = stat (filePath.c_str(), &st_buf);
  return S_ISDIR(st_buf.st_mode);
}

#include <string>
#include <sstream>
#include <vector>
#include <iterator>

template<typename Out>
void split(const std::string &s, char delim, Out result) {
    std::stringstream ss;
    ss.str(s);
    std::string item;
    while (std::getline(ss, item, delim)) {
            *(result++) = item;
        }
}


std::vector<std::string> split(const std::string &s, char delim) {
    std::vector<std::string> elems;
    split(s, delim, std::back_inserter(elems));
    return elems;
}

/*
Vector Glob
*/

#include <glob.h>
#include <vector>

// From http://dannys-tech-musings.blogspot.com/2008/06/glob-example.html
std::vector<std::string> vGlob(const std::string& pattern) {
  std::vector<std::string> fileList;

  //Declare glob_t for storing the results of globbing
  glob_t globbuf;
  
  //Glob.. GLOB_TILDE tells the globber to expand "~" in the pattern to the home directory
  glob(pattern.c_str(), GLOB_TILDE, NULL, &globbuf);

  for (int i = 0; i < globbuf.gl_pathc; ++i) {
    fileList.push_back(globbuf.gl_pathv[i]);
  }
  
  //Free the globbuf structure
  if (globbuf.gl_pathc > 0)
    globfree( &globbuf );

  return fileList;
}

/*
FLAGS
*/

std::string FLAGhelpstring = "";

#define DEFINE_FLAG(type, flag_name, default_value, description) \
std::string FLAGname_##flag_name = #flag_name; \
std::string FLAGhelp_##flag_name = description; \
std::string FLAGdefaultvalue_##flag_name = #default_value; \
type FLAG_##flag_name = default_value;

#define DEFINE_bool(flag_name, default_value, description) \
DEFINE_FLAG(bool, flag_name, default_value, description)

#define DEFINE_string(flag_name, default_value, description) \
DEFINE_FLAG(std::string, flag_name, default_value, description)

#define DEFINE_double(flag_name, default_value, description) \
DEFINE_FLAG(double, flag_name, default_value, description)

#define DEFINE_int(flag_name, default_value, description) \
DEFINE_FLAG(int, flag_name, default_value, description)

#define DEFINE_vec_double(flag_name, default_value, description) \
DEFINE_FLAG(std::vector<double>, flag_name, default_value, description)

#define REGISTER_FLAG(argc, argv, flag_name) \
FLAGhelpstring.append("\n--" #flag_name " ["); \
FLAGhelpstring.append(FLAGdefaultvalue_##flag_name); \
FLAGhelpstring.append("]:\n\t"); \
FLAGhelpstring.append(FLAGhelp_##flag_name); \
parseFlag(argc, argv, FLAGname_##flag_name, FLAG_##flag_name);

#define FLAGHELP() \
std::cout << FLAGhelpstring << std::endl;


#include <cstdlib>  // std::atof

void parseFlag(int argc, char** argv, std::string name, bool& val) {
  std::string token;
  bool found = false;
  for (int i = 0; i < argc; ++i) {
    token = std::string(argv[i]);
    if (found) {
      if(token.find("--") == 0) {
        val = true;
        return;
      }

      val = (token.compare("true") == 0);
      return;
    }
    if (token.compare("--" + name) == 0) {
      if(i == argc - 1) {
        // If this is the last flag in the list
        val = true;
        return;
      }
      found = true;
    }
    if(token.compare("--no" + name) == 0) {
      val = false;
      return;
    }
  }
}

void parseFlag(int argc, char** argv, std::string name, double& val) {
  std::string token;
  bool found = false;
  for (int i = 0; i < argc; ++i) {
    token = std::string(argv[i]);
    if (found) {
      val = std::atof(argv[i]);
      return;
    }
    if (token.compare("--" + name) == 0) {
      found = true;
    }
  }
}

void parseFlag(int argc, char** argv, std::string name, int& val) {
  std::string token;
  bool found = false;
  for (int i = 0; i < argc; ++i) {
    token = std::string(argv[i]);
    if (found) {
      val = std::atoi(argv[i]);
      return;
    }
    if (token.compare("--" + name) == 0) {
      found = true;
    }
  }
}

void parseFlag(int argc, char** argv, std::string name, std::string& val) {
  std::string token;
  bool found = false;
  for (int i = 0; i < argc; ++i) {
    token = std::string(argv[i]);
    if (found) {
      val = token;
      return;
    }
    if (token.compare("--" + name) == 0) {
      found = true;
    }
  }
}

#include <cstring>  // std::strtok

void parseFlag(int argc, char** argv, std::string name, std::vector<double>& val) {
  std::string token;
  bool found = false;
  for (int i = 0; i < argc; ++i) {
    token = std::string(argv[i]);
    if (found) {
      char* tk = std::strtok(argv[i], ":");
      while (tk != NULL) {
        val.push_back(std::atof(tk));
        tk = strtok (NULL, ":");
      }
      return;
    }
    if (token.compare("--" + name) == 0) {
      found = true;
    }
  }
}

void parseFlag(int argc, char** argv, std::string name, std::vector<std::string>& val) {
  std::string token;
  bool found = false;
  for (int i = 0; i < argc; ++i) {
    token = std::string(argv[i]);
    if (found) {
      char* tk = std::strtok(argv[i], ":");
      while (tk != NULL) {
        val.push_back(std::string(tk));
      }
      return;
    }
    if (token.compare("--" + name) == 0) {
      found = true;
    }
  }
}
#endif  // _UTILS_H
