CPPFLAGS += -std=c++20 -W -Wall -g -I include

bin/c_compiler : src/cli.cpp src/compiler.cpp
	mkdir -p bin
	g++ $(CPPFLAGS) -o bin/c_compiler $^

clean :
	rm -rf bin/*
