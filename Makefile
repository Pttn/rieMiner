CXX    = g++
M4     = m4
AS     = as
SED    = sed
CFLAGS = -Wall -Wextra -std=c++17 -O3 -fno-pie -no-pie

msys_version := $(if $(findstring Msys, $(shell uname -o)),$(word 1, $(subst ., ,$(shell uname -r))),0)
ifneq ($(msys_version), 0)
LIBS   = -pthread -lcurl -lcrypto -lgmpxx -lgmp -lws2_32 -Wl,--image-base -Wl,0x10000000
MOD_1_4_ASM = mod_1_4_win.asm
else
LIBS   = -pthread -lcurl -lcrypto -lgmpxx -lgmp
MOD_1_4_ASM = mod_1_4.asm
endif

all: standard

standard: CFLAGS += -march=native -s
standard: rieMinerAVX2

light: CFLAGS += -march=native -s -D LIGHT
light: rieMinerL

android: CXX    = $(shell printenv CXX)
android: CFLAGS = -Wall -Wextra -std=c++17 -O3 -D LIGHT -I incs/
android: LIBS   := -Wl,-Bstatic -static-libstdc++ -L libs/ $(LIBS) -Wl,-Bdynamic -Wl,--strip-all
android: rieMinerL

debug: CFLAGS += -march=native -g
debug: rieMinerAVX2

ifneq ($(msys_version), 0)
static: CFLAGS += -march=x86-64 -s -D CURL_STATICLIB -I incs/
static: LIBS   := -static -L libs/ $(LIBS)
static: rieMiner

staticAVX2: CFLAGS += -march=haswell -s -D CURL_STATICLIB -I incs/
staticAVX2: LIBS   := -static -L libs/ $(LIBS)
staticAVX2: rieMinerAVX2
else
static: CFLAGS += -march=x86-64 -s -D CURL_STATICLIB -I incs/
static: LIBS   :=  -Wl,-Bstatic -static-libstdc++ -L libs/ $(LIBS) -Wl,-Bdynamic
static: rieMiner

staticAVX2: CFLAGS += -march=haswell -s -D CURL_STATICLIB -I incs/
staticAVX2: LIBS   := -Wl,-Bstatic -static-libstdc++ -L libs/ $(LIBS) -Wl,-Bdynamic
staticAVX2: rieMinerAVX2
endif

testServer: rieMinerTestServer

rieMinerTestServer: TestServer.cpp
	$(CXX) -Wall -Wextra -std=c++20 $^ -o $@

rieMinerAVX2: main.o Miner.o StratumClient.o GBTClient.o Client.o Stats.o tools.o mod_1_4.o mod_1_2_avx.o mod_1_2_avx2.o fermat.o primetest.o primetest512.o
	$(CXX) $(CFLAGS) -o rieMiner $^ $(LIBS)

rieMiner: main.o Miner.o StratumClient.o GBTClient.o Client.o Stats.o tools.o mod_1_4.o mod_1_2_avx.o
	$(CXX) $(CFLAGS) -o rieMiner $^ $(LIBS)
	
rieMinerL: main.o Miner.o StratumClient.o GBTClient.o Client.o Stats.o tools.o
	$(CXX) $(CFLAGS) -o rieMiner $^ $(LIBS)

main.o: main.cpp main.hpp Miner.hpp Client.hpp Stats.hpp tools.hpp
	$(CXX) $(CFLAGS) -c -o $@ main.cpp

Miner.o: Miner.cpp Miner.hpp
	$(CXX) $(CFLAGS) -c -o $@ Miner.cpp

StratumClient.o: StratumClient.cpp
	$(CXX) $(CFLAGS) -c -o $@ StratumClient.cpp

GBTClient.o: GBTClient.cpp
	$(CXX) $(CFLAGS) -c -o $@ GBTClient.cpp

Client.o: Client.cpp
	$(CXX) $(CFLAGS) -c -o $@ Client.cpp

Stats.o: Stats.cpp
	$(CXX) $(CFLAGS) -c -o $@ Stats.cpp

tools.o: tools.cpp
	$(CXX) $(CFLAGS) -c -o $@ tools.cpp

fermat.o: ispc/fermat.cpp
	$(CXX) $(CFLAGS) -c -o $@ ispc/fermat.cpp -Wno-unused-function -Wno-unused-parameter -Wno-strict-overflow

mod_1_4.o: external/$(MOD_1_4_ASM)
	$(M4) external/$(MOD_1_4_ASM) >mod_1_4.s
	$(AS) mod_1_4.s -o $@
	rm mod_1_4.s

ifneq ($(msys_version), 0)
mod_1_2_avx.o: external/mod_1_2_avx.asm external/mod_1_2_avx_win.sed
	$(SED) -f external/mod_1_2_avx_win.sed <external/mod_1_2_avx.asm >mod_1_2_avx.asm
	$(M4) mod_1_2_avx.asm >mod_1_2_avx.s
	$(AS) mod_1_2_avx.s -o $@
	rm mod_1_2_avx.s mod_1_2_avx.asm

mod_1_2_avx2.o: external/mod_1_2_avx2.asm external/mod_1_2_avx_win.sed
	$(SED) -f external/mod_1_2_avx_win.sed <external/mod_1_2_avx2.asm >mod_1_2_avx2.asm
	$(M4) mod_1_2_avx2.asm >mod_1_2_avx2.s
	$(AS) mod_1_2_avx2.s -o $@
	rm mod_1_2_avx2.s mod_1_2_avx2.asm
else
mod_1_2_avx.o: external/mod_1_2_avx.asm
	$(M4) external/mod_1_2_avx.asm >mod_1_2_avx.s
	$(AS) mod_1_2_avx.s -o $@
	rm mod_1_2_avx.s

mod_1_2_avx2.o: external/mod_1_2_avx2.asm
	$(M4) external/mod_1_2_avx2.asm >mod_1_2_avx2.s
	$(AS) mod_1_2_avx2.s -o $@
	rm mod_1_2_avx2.s
endif

ifneq ($(msys_version), 0)
primetest.o: ispc/primetest.s ispc/primetest_win.sed
	$(SED) -f ispc/primetest_win.sed <ispc/primetest.s >primetest_win.s
	$(AS) primetest_win.s -o $@
	rm primetest_win.s

primetest512.o: ispc/primetest512.s ispc/primetest_win.sed
	$(SED) -f ispc/primetest_win.sed <ispc/primetest512.s >primetest512_win.s
	$(AS) primetest512_win.s -o $@
	rm primetest512_win.s
else
primetest.o: ispc/primetest.s
	$(AS) ispc/primetest.s -o $@

primetest512.o: ispc/primetest512.s
	$(AS) ispc/primetest512.s -o $@
endif

clean:
	rm -rf *.o
