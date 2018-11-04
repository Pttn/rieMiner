CXX    = g++
CFLAGS = -Wall -Wextra -std=gnu++11 -O3 -march=native
LIBS   = -pthread -ljansson -lcurl -lgmp -lgmpxx -lcrypto

all: rieMiner

release: CFLAGS += -DNDEBUG
release: rieMiner

debug: CFLAGS += -g
debug: rieMiner

rieMiner: main.o miner.o stratumclient.o gbtclient.o client.o tools.o
	$(CXX) $(CFLAGS) -o rieMiner $^ $(LIBS)

main.o: main.cpp main.h miner.h client.h gbtclient.h stratumclient.h tools.h
	$(CXX) $(CFLAGS) -c -o main.o main.cpp

miner.o: miner.cpp miner.h
	$(CXX) $(CFLAGS) -c -o miner.o miner.cpp

stratumclient.o: stratumclient.cpp
	$(CXX) $(CFLAGS) -c -o stratumclient.o stratumclient.cpp

gbtclient.o: gbtclient.cpp
	$(CXX) $(CFLAGS) -c -o gbtclient.o gbtclient.cpp

client.o: client.cpp
	$(CXX) $(CFLAGS) -c -o client.o client.cpp

tools.o: tools.cpp
	$(CXX) $(CFLAGS) -c -o tools.o tools.cpp

clean:
	rm -rf rieMiner *.o
