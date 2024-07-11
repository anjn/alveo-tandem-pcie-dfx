.PHONY: all clean project open build mcs

all: project

clean:
	rm -rf build

project:
	vivado -mode batch -nolog -nojournal -source ./script/create_project.tcl

open:
	vivado -nolog -nojournal ./build/*.xpr

build:
	vivado -mode batch -nolog -nojournal -source ./script/build.tcl

mcs:
	vivado -mode batch -nolog -nojournal -source ./script/generate_mcs.tcl

