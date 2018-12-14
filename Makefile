CXX    = g++
M4     = m4
AS     = as
SED    = sed
CFLAGS = -Wall -Wextra -std=gnu++11 -O3 -march=native

msys_version := $(if $(findstring Msys, $(shell uname -o)),$(word 1, $(subst ., ,$(shell uname -r))),0)
ifneq ($(msys_version), 0)
LIBS   = -pthread -ljansson -lcurl -lcrypto -lgmpxx -lgmp -lws2_32
else
LIBS   = -pthread -ljansson -lcurl -lcrypto -lgmpxx -lgmp
endif

all: rieMinerL

debug: CFLAGS += -g
debug: rieMinerL

static: CFLAGS += -D CURL_STATICLIB -I incs/
static: LIBS   := -static -L libs/ $(LIBS)
static: rieMinerL

rieMinerL: main.o Miner.o StratumClient.o GBTClient.o Client.o WorkManager.cpp Stats.cpp tools.o
	$(CXX) $(CFLAGS) -o rieMinerL $^ $(LIBS)

main.o: main.cpp main.hpp Miner.hpp StratumClient.hpp GBTClient.hpp Client.hpp WorkManager.hpp Stats.hpp tools.hpp tsQueue.hpp
	$(CXX) $(CFLAGS) -c -o main.o main.cpp

Miner.o: Miner.cpp Miner.hpp tsQueue.hpp
	$(CXX) $(CFLAGS) -c -o Miner.o Miner.cpp

StratumClient.o: StratumClient.cpp
	$(CXX) $(CFLAGS) -c -o StratumClient.o StratumClient.cpp

GBTClient.o: GBTClient.cpp
	$(CXX) $(CFLAGS) -c -o GBTClient.o GBTClient.cpp

Client.o: Client.cpp
	$(CXX) $(CFLAGS) -c -o Client.o Client.cpp

Stats.o: Stats.cpp
	$(CXX) $(CFLAGS) -c -o Stats.o Stats.cpp

WorkManager.o: WorkManager.cpp
	$(CXX) $(CFLAGS) -c -o WorkManager.o WorkManager.cpp

tools.o: tools.cpp
	$(CXX) $(CFLAGS) -c -o tools.o tools.cpp

clean:
	rm -rf rieMinerL *.o
