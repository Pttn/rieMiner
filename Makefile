CXX    = g++
M4     = m4
AS     = as
CFLAGS = -Wall -Wextra -std=gnu++11 -O3 -march=native
LIBS   = -pthread -ljansson -lcurl -lcrypto -Wl,-Bstatic -lgmp -lgmpxx -Wl,-Bdynamic

all: rieMiner

release: CFLAGS += -DNDEBUG
release: rieMiner

debug: CFLAGS += -g
debug: rieMiner

rieMiner: main.o miner.o stratumclient.o gbtclient.o client.o tools.o mod_1_4.o
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

mod_1_4.o: external/mod_1_4.asm
	$(M4) external/mod_1_4.asm >mod_1_4.s
	$(AS) mod_1_4.s -o mod_1_4.o
	rm mod_1_4.s

clean:
	rm -rf rieMiner *.o
