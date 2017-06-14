# Turing Machine Simulator
This is a simple attempt to replicate the (awesome) work done in the online Turing machine simulator at [turingmachinesimulator.com](http://turingmachinesimulator.com) in C++ so it is faster to test big machines.
I don't claim it ot be bug-free, feature complete, well written nor the fastest possible implementation but it serves its purpose decently well.

# Building
    make

# Usage
In the examples directory there are some nice algorithms implemented for the online simulator that can be used to to test this simulator (some were copied verbatim from the online simulator examples, others were written by me). The basic syntax is as follows

    ./turing <tm_code> <input_string>

If you want to simulate the machine without input you can use _ as the second argument. The underscore character works as the TM blank symbol so it is equivalent.

## Flags
The simulator has several flags to get more information out of the simulation, the following summary comes up when the simulator is ran without arguments.

		Usage
		turing <tm_file> <input_word>

		--show_machine [false]:
				Show a summary of the parsed TM
		--show_steps [false]:
				Show each step of the main tape of the TM excecution
		--run [true]:
				Run the TM
		--output [true]:
				Output the final content of the TM tapes
		--max_steps [10000000]:
				Maximum number of steps
		--limit [true]:
				Limit number of steps

## Examples
Try running the following commands to the simulator working

    # 5-state busy beaver machine. It will run for a while
    ./turing examples/bb5.tm _ --nolimit --nooutput

    # Decimal to binary converter. This will only show the machine
    ./turing examples/dec2bin.tm --show_machine --norun

    # Duplicate binary string with single tape
    ./turing examples/dup_bin_string.tm 101 --show_steps

    # Sort a list of binary numbers
    ./turing examples/list_sort.tm 0101#0011#0110#0111#0011#1000
