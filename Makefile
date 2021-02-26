CXX    = g++
M4     = m4
AS     = as
SED    = sed
CFLAGS = -Wall -Wextra -std=c++17 -O3 -s -march=native -fno-pie -no-pie

msys_version := $(if $(findstring Msys, $(shell uname -o)),$(word 1, $(subst ., ,$(shell uname -r))),0)
ifneq ($(msys_version), 0)
LIBS   = -pthread -ljansson -lcurl -lcrypto -lgmpxx -lgmp -lws2_32 -Wl,--image-base -Wl,0x10000000
else
LIBS   = -pthread -ljansson -lcurl -lcrypto -Wl,-Bstatic -lgmpxx -lgmp -Wl,-Bdynamic
endif

all: rieMinerL

debug: CFLAGS = -Wall -Wextra -std=c++17 -O3 -g -march=native -fno-pie -no-pie
debug: rieMinerL

static: CFLAGS += -D CURL_STATICLIB -I incs/
static: LIBS   := -static -L libs/ $(LIBS)
static: rieMinerL

rieMinerL: main.o Miner.o StratumClient.o GBTClient.o Client.o Stats.o tools.o
	$(CXX) $(CFLAGS) -o rieMinerL $^ $(LIBS)

main.o: main.cpp main.hpp Miner.hpp StratumClient.hpp GBTClient.hpp Client.hpp Stats.hpp tools.hpp
	$(CXX) $(CFLAGS) -c -o main.o main.cpp

Miner.o: Miner.cpp Miner.hpp
	$(CXX) $(CFLAGS) -c -o Miner.o Miner.cpp

StratumClient.o: StratumClient.cpp
	$(CXX) $(CFLAGS) -c -o StratumClient.o StratumClient.cpp

GBTClient.o: GBTClient.cpp
	$(CXX) $(CFLAGS) -c -o GBTClient.o GBTClient.cpp

Client.o: Client.cpp
	$(CXX) $(CFLAGS) -c -o Client.o Client.cpp

Stats.o: Stats.cpp
	$(CXX) $(CFLAGS) -c -o Stats.o Stats.cpp

tools.o: tools.cpp
	$(CXX) $(CFLAGS) -c -o tools.o tools.cpp

clean:
	rm -rf rieMinerL *.o
