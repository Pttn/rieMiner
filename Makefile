CXX    = g++
CFLAGS = -Wall -Wextra -std=gnu++11 -O3 -march=native
LIBS   = -pthread -ljansson -lcurl -lgmp -lgmpxx

all: rieMiner

rieMiner: main.o miner.o client.o sha2.o
	$(CXX) $(CFLAGS) -o rieMiner $^ $(LIBS)

main.o: main.cpp
	$(CXX) $(CFLAGS) -c -o main.o main.cpp $(LIBS)

miner.o: miner.cpp
	$(CXX) $(CFLAGS) -c -o miner.o miner.cpp $(LIBS)

client.o: client.cpp
	$(CXX) $(CFLAGS) -c -o client.o client.cpp $(LIBS)

sha2.o: External/sha2.cpp
	$(CXX) $(CFLAGS) -c -o sha2.o External/sha2.cpp $(LIBS)

clean:
	rm -rf rieMiner *.o
