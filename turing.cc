#include <iostream>
#include <string>
#include <regex>
#include <unordered_map>
#include <vector>
#include <set>
#include <utility>
#include <algorithm>
#include <sstream>
#include <fstream>

#include "logging.h"
#include "utils.h"

typedef char symbol;
const symbol B = '_';

struct Cell {
  symbol content;
  Cell* left;
  Cell* right;
};

class Tape {
  public:
  Cell* current_cell;
  size_t position;

  Tape() {
    current_cell = new Cell{B, NULL, NULL};
    position = 0;
  }

  std::string content() {
    std::stringstream ss;
    Cell *c = current_cell;
    while(c->left != NULL) c = c->left;
    for(;c != NULL; c=c->right) {
      ss << c->content;
    }
    return ss.str();
  }

  void left() {
    position--;
    if(current_cell->left == NULL) {
      current_cell->left = new Cell{B, NULL, current_cell};
    }
    current_cell = current_cell->left;
  }

  void right() {
    position++;
    if(current_cell->right == NULL) {
      current_cell->right = new Cell{B, current_cell, NULL};
    }
    current_cell = current_cell->right;
  }
};

class State {
  public:
  std::string name;
  State() {}
  State(std::string name) : name(name) {};
};

static bool operator==(const State s1, const State s2) {
  return s1.name.compare(s2.name) == 0;
}

namespace std {
  template<>
    struct hash<State> {
      public:
        size_t operator()(const State & state) {
          return std::hash<std::string>{}(state.name);
        }
    };
}

enum Movement {Left, Right, None};
class Transition {
  public:
  State* from;
  std::vector<symbol> read_symbols;
  State* to;
  std::vector<symbol> write_symbols;
  std::vector<Movement> movements;
};

class TuringMachine {
  public:
  std::string name;
  std::unordered_map<std::string, State> states;
  std::set<std::string> accepting_states;
  State* current_state;

  std::vector<Tape> tapes;

  std::unordered_map<std::pair<
    State, std::string>,
    Transition, pair_hash> transitions;

  bool halted;

  TuringMachine() {}
  TuringMachine(std::string name, size_t ntapes, State* initial_state) {
    this->name = name;
    current_state = initial_state;
    for(size_t i = 0; i < ntapes; i++) {
      tapes.push_back(Tape());
    }
    halted = false;
  }

  void halt() {
    halted = true;
  }

  bool accepted() {
    if(accepting_states.find(current_state->name) != accepting_states.end()) {
      return halted;
    }
    return false;
    //return halted && accepting_states.count(current_state) > 0;
  }

  void set_word(std::string word) {
    Tape tape = tapes[0];
    Cell* initial_cell = tape.current_cell;
    for(char& c : word) {
      tape.current_cell->content = c;
      tape.right();
    }
    tape.current_cell = initial_cell;
  }

  void add_accepting_state(State* state) {
    accepting_states.insert(state->name);
  }

  State *get_or_add_state(std::string state_name) {
    if(states.find(state_name) != states.end()) {
      return &states[state_name];
    }
    State* s = new State(state_name);
    states.insert({state_name, *s});
    return s;
  }

  void add_transition(State* from, std::vector<symbol> read_symbols, State* to,
      std::vector<symbol> write_symbols, std::vector<Movement> movements) {
    Transition *t = new Transition();
    t->from = from;
    t->to = to;
    for(auto c : read_symbols) {
      t->read_symbols.push_back(c);
    }
    for(auto c : write_symbols) {
      t->write_symbols.push_back(c);
    }
    for(auto m : movements) {
      t->movements.push_back(m);
    }
    add_transition(*t);
  }

  void add_transition(Transition transition) {
    std::string word;
    for(auto& sym: transition.read_symbols) {
      word += sym;
    }
    transitions.insert({std::make_pair(*transition.from, word), transition});
  }

  void step() {
    if(halted) {
      return;
    }
    Transition* transition = next_transition();
    if(transition == NULL) {
      halt();
      return;
    }
    // Write symbols
    for(size_t i = 0; i < tapes.size(); i++) {
      tapes[i].current_cell->content = transition->write_symbols[i];
    }
    // Change state
    current_state = transition->to;
    // Move
    for(size_t i = 0; i < tapes.size(); i++) {
      if(transition->movements[i] == Movement::Left)
        tapes[i].left();
      if(transition->movements[i] == Movement::Right)
        tapes[i].right();
    }
  }

  std::string state_word() {
    std::string res;
    for(auto& tape : tapes) {
      res += tape.current_cell->content;
    }
    return res;
  }

  Transition* next_transition() {
    auto res = transitions.find(std::make_pair(*current_state, state_word()));
    if(res == transitions.end()) {
      return NULL;
    } else {
      return &res->second;
    }
  }
};

#define PARSE_CHECK(condition, message) \
  CHECK(condition, message << "\n" << linenm << ": " << line)
TuringMachine parseMachine(std::string machine_code) {
  std::stringstream ss(machine_code);
  std::string line;
  std::string name;
  std::string initial_state;
  std::string final_states;
  std::vector<std::string> accepting_states;

  std::string state_from;
  std::vector<symbol> read_symbols;
  std::string state_to;
  std::vector<symbol> write_symbols;
  std::vector<Movement> movements;

  std::size_t ntapes = 0;

  TuringMachine machine;
  Transition current_transition;

  enum parse_state {trans_from, trans_to, trans_done};
  parse_state current_state = parse_state::trans_from;

  std::size_t linenm = 0;

  std::regex trim_regex = std::regex("^\\s+|\\s+$");
  std::regex comment_regex = std::regex("//.*$");
  while(std::getline(ss, line, '\n')) {
    linenm++;
    if(line.size() == 0) {
      continue;
    }
    // Remove leading and trailing whitespace
    line = std::regex_replace(line, trim_regex, "");
    // Remove comments
    line = std::regex_replace(line, comment_regex, "");
    if(line.compare(0, 5, "name:") == 0) {
      name = line.substr(5);
      continue;
    }
    // Remove spaces and tabs
    line.erase (std::remove(line.begin(), line.end(), ' '), line.end());
    line.erase (std::remove(line.begin(), line.end(), '\t'), line.end());
    line.erase (std::remove(line.begin(), line.end(), '\r'), line.end());
    if(line.size() == 0) {
      continue;
    }
    PARSE_CHECK(line.size() >= 2, "line length is not enough");
    if(line.compare(0, 7, "accept:") == 0) {
      accepting_states = split(line.substr(7), ',');
      continue;
    }
    if(initial_state.size() == 0) {
      if(line.compare(0, 5, "init:") == 0) {
        initial_state = line.substr(5);
        continue;
      }
    }

    // Al the lines from here on should be a comma separated list
    std::vector<std::string> tokens = split(line, ',');
    if(current_state == parse_state::trans_from) {
      state_from = tokens[0];
      read_symbols.clear();
      PARSE_CHECK(tokens.size() > 1,
          "State and read symbols must be given");
      for(size_t i = 1; i < tokens.size(); i++) {
        PARSE_CHECK(tokens[i].size() == 1,
            "Only single character symbols are allowed");
        read_symbols.push_back(tokens[i][0]);
      }
      current_state = parse_state::trans_to;
      if(ntapes == 0) {
        // Built machine as soon as we have the number of tapes
        ntapes = read_symbols.size();
        PARSE_CHECK(initial_state.size() > 0, "Initial state not found");
        machine = TuringMachine(name, ntapes, new State(initial_state));
        for(const auto& st : accepting_states) {
          State* ss = machine.get_or_add_state(st);
          machine.add_accepting_state(ss);
        }
      } else {
        PARSE_CHECK(read_symbols.size() == ntapes,
            "Number of symbols must be the same as number of tapes");
      }
    } else if(current_state == parse_state::trans_to) {
      state_to = tokens[0];
      write_symbols.clear();
      PARSE_CHECK(tokens.size() == 1 + 2 * ntapes,
          "State, write symbols and directions must be given");
      for(size_t i = 1; i < ntapes + 1; i++) {
        PARSE_CHECK(tokens[i].size() == 1,
            "Only single character symbols are allowed");
        write_symbols.push_back(tokens[i][0]);
      }
      movements.clear();
      for(size_t i = ntapes + 1; i < 2 * ntapes + 1; i++) {
        PARSE_CHECK(
            tokens[i][0] == '<' || tokens[i][0] == '>' || tokens[i][0] == '-',
            "Direction must be one of <, >, -");
        if(tokens[i][0] == '<') {
          movements.push_back(Movement::Left);
        } else if(tokens[i][0] == '>') {
          movements.push_back(Movement::Right);
        } else if(tokens[i][0] == '-') {
          movements.push_back(Movement::None);
        }
      }

      State* from = machine.get_or_add_state(state_from);
      State* to = machine.get_or_add_state(state_to);

      machine.add_transition(from, read_symbols, to, write_symbols, movements);

      current_state = parse_state::trans_from;
    }

  }
  return machine;
}

// Flags
DEFINE_bool(show_machine, false,
    "Show a summary of the parsed TM");
DEFINE_bool(show_steps, false,
    "Show each step of the main tape of the TM excecution");
DEFINE_bool(run, true,
    "Run the TM");
DEFINE_bool(limit, true,
    "Limit number of steps");
DEFINE_bool(output, true,
    "Output the final content of the TM tapes");
DEFINE_int(max_steps, 10000000,
    "Maximum number of steps");

int main(int argc, char** argv) {
  REGISTER_FLAG(argc, argv, show_machine);
  REGISTER_FLAG(argc, argv, show_steps);
  REGISTER_FLAG(argc, argv, run);
  REGISTER_FLAG(argc, argv, output);
  REGISTER_FLAG(argc, argv, max_steps);
  REGISTER_FLAG(argc, argv, limit);

  if(argc < 2) {
    std::cout << "Usage" << std::endl <<
      "turing <tm_file> <input_word>" << std::endl;
    FLAGHELP();
    return 1;
  }
  std::string filename(argv[1]);
	std::string word;
	if(argc > 2)
		word = argv[2];

  std::ifstream t(filename);
  CHECK(t.good(), "Failed trying to read file " << filename);
  std::stringstream buffer;
  buffer << t.rdbuf();
  t.close();

  TuringMachine machine2 = parseMachine(buffer.str());
  machine2.set_word(word);

  if(FLAG_show_machine) {
    LOG_INFO("Name: " << machine2.name);
    LOG_INFO("Number of tapes: " << machine2.tapes.size());

    LOG_INFO("Transitions: ");
    for(auto const & tr : machine2.transitions) {
      std::stringstream ss;
      ss << "d(" << tr.second.from->name;
      for(size_t t = 0; t < machine2.tapes.size(); t++) {
        ss << ", " << tr.second.read_symbols[t];
      }
      ss << ") -> (" << tr.second.to->name;
      for(size_t t = 0; t < machine2.tapes.size(); t++) {
        ss << ", " << tr.second.write_symbols[t];
      }
      for(size_t t = 0; t < machine2.tapes.size(); t++) {
        ss << ", ";
        switch(tr.second.movements[t]) {
          case Movement::Left:
            ss << "<";
            break;
          case Movement::Right:
            ss << ">";
            break;
          case Movement::None:
            ss << "-";
            break;
        }
      }
      ss << ")";
      LOG_INFO(ss.str());
   }
  }

  if(FLAG_run) {
    long long n_steps = 0;
    while(!machine2.halted && (!FLAG_limit || n_steps < FLAG_max_steps)) {
      machine2.step();
      n_steps++;
      if(FLAG_show_steps) {
        std::string content = machine2.tapes[0].content();
        LOG_INFO(content);
      }
    }
    if(!machine2.halted) {
      LOG_WARNING(
          "It seems that the machine didn't halt. Maybe try increasing the " <<
          "max_steps flag or disabling the limit flag to run until a " <<
          "halting state");
    }
    n_steps--;
    LOG_INFO("N steps: " << n_steps);
    LOG_INFO("Final State: " << machine2.current_state->name << "(" << machine2.state_word() << ")");
    if(machine2.accepted()) {
      LOG_INFO("\x1b[32mAccepted\x1b[0m");
    } else {
      LOG_INFO("\x1b[31mRejected\x1b[0m");
    }
    if(FLAG_output) {
      LOG_INFO("Tapes Content: ");
      for(size_t i = 0; i < machine2.tapes.size(); i++) {
        LOG_INFO(machine2.tapes[i].content());
      }
    }
  }
}
