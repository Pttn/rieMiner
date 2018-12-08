# rieMiner 0.9RC5

rieMiner is a Riecoin miner supporting both solo and pooled mining. It was originally adapted and refactored from gatra's cpuminer-rminerd (https://github.com/gatra/cpuminer-rminerd) and dave-andersen's fastrie (https://github.com/dave-andersen/fastrie), though there is no remaining code from rminerd anymore.

Solo mining is done using the GetBlockTemplate protocol, while pooled mining is via the Stratum protocol. A benchmark mode is also proposed to compare more easily the performance between different computers.

Direct link to the latest official [Windows x64 standalone executable](https://ric.pttn.me/file.php?d=rieMinerWin64). First stable version, rieMiner 0.9, will be released on December 16.

This README also serves as manual for rieMiner. I hope that this program will be useful for you! Happy mining!

The Riecoin community thanks you for your participation, you will be a contributor to the robustness of the Riecoin network.

![rieMiner just found a block](https://ric.pttn.me/file.php?d=rieMiner)

I provide a Profitability Calculator [here](https://ric.pttn.me/page.php?n=ProfitabilityCalculator).

## Minimum requirements

Only x64 systems with SSE are supported.

* Windows 7 or later, or recent enough Linux;
* x64 CPU with SSE instruction set;
* 1 GiB of RAM (Sieve size must be manually set at a lower value in the options).

Recommended:

* Windows 10 or Debian 9;
* Intel Core i7 6700 or better, or AMD Ryzen R5 1600 or better;
* 8 GiB of RAM.

## Compile this program

### In Debian/Ubuntu x64

You can compile this C++ program with g++, as, m4 and make, install them if needed. Then, get if needed the following dependencies:

* Jansson
* cURL
* libSSL
* GMP

On a recent enough Debian or Ubuntu, you can easily install these by doing as root:

```bash
apt install g++ make m4 git libjansson-dev libcurl4-openssl-dev libssl-dev libgmp-dev
```

Then, just download the source files, go/cd to the directory, and do a simple make:

```bash
git clone https://github.com/Pttn/rieMiner.git
cd rieMiner
make
```

For other Linux, executing equivalent commands (using pacman instead of apt,...) should work.

If you get a warning after the compilation that there may be a conflict between libcrypto.so files, install libssl1.0-dev instead of libssl-dev.

### In Windows x64

You can compile rieMiner in Windows, and here is one way to do this. First, install [MSYS2](http://www.msys2.org/) (follow the instructions on the website), then enter in the MSYS **MinGW-w64** console, and install the tools and dependencies:

```bash
pacman -S make
pacman -S git
pacman -S mingw64/mingw-w64-x86_64-gcc
pacman -S mingw64/mingw-w64-x86_64-curl
```

Recommended: move the rieMiner's folder to the MSYS2 home directory.

Go to the rieMiner's directory with cd, and compile with make.

#### Static building

The produced executable will run only in the MSYS console, or if all the needed DLLs are next to the executable. To obtain a standalone executable, you need to link statically the dependencies. Normally, this is done just by adding "-static" at the LIBS line in the Makefile. Unfortunately, libcurl will give you a hard time, and you need to compile it yourself.

First, edit the Makefile to add "-D CURL_STATICLIB" at the end of the CFLAGS line and "-static" just after the "LIBS =" in the first LIBS line. You might also want to change the march argument to support other/olders processors.

```
CFLAGS = -Wall -Wextra -std=gnu++11 -O3 -march=native -D CURL_STATICLIB
[...]
LIBS   = -static -pthread -ljansson -lcurl -lcrypto -lgmp -lgmpxx -lws2_32
```

Then, download the [latest official libcurl code](https://curl.haxx.se/download.html) on their website, under "Source Archives", and decompress the folder somewhere (for example, next to the rieMiner's one).

In the MSYS MinGW-w64 console, cd to the libcurl directory. We will now configure it so we will not build unused features:

```bash
./configure --disable-dict --disable-file --disable-ftp --disable-gopher --disable-imap --disable-ldap --disable-ldaps --disable-pop3 --disable-rtsp --disable-smtp --disable-telnet --disable-tftp --without-ssl --without-libssh2 --without-zlib --without-brotli --without-libidn2  --without-ldap  --without-ldaps --without-rtsp --without-psl --without-librtmp --without-libpsl --without-nghttp2 --disable-shared --disable-libcurl-option
```

Then, compile libcurl with make. We now need to replace the existing libcurl headers and libs provided by MinGW:

* In the downloaded libcurl directory, go to the include directory and copy the "curl" folder to replace the one in X:\path\to\msys64\mingw64\include (make a backup if needed);
* Do the same with the file "libcurl.a" in the libs/.lib folder to replace the one in X:\path\to\msys64\mingw64\lib (make a backup if needed).

Now, you should be able to compile rieMiner with make and produce a standalone executable.

## Run and configure this program

You can finally run the newly created rieMiner executable using

```bash
./rieMiner
```

If no "rieMiner.conf" next to the executable was found, you will be assisted to configure rieMiner. Answer to its questions to start mining. If there is a "rieMiner.conf" file next to the executable with incorrect information that was read, you can delete this to get the assistant.

Alternatively, you can create or edit this "rieMiner.conf" file next to the executable yourself, in order to provide options to the miner. The rieMiner.conf syntax is very simple: each option is given by a line such

```
Option type = Option value
```

It is case sensitive, but spaces and invalid lines are ignored. A line starting with "#" will also be ignored. **Do not put ; at the end or use other delimiters than =** for each line, and **do not confuse rieMiner.conf with riecoin.conf**! If an option is missing, the default value(s) will be used. If there are duplicate lines, the last one will be used. Here is a sample configuration file for solo mining, with comments explaining the main available options.

```
# Mining mode: Solo for solo mining via GetBlockTemplate, Pool for pooled mining using Stratum, Benchmark for testing. Default: Benchmark
Mode = Solo

# IP and port of the Riecoin wallet/server or pool. Default: 127.0.0.1 (your computer), port 28332 (default port for Riecoin-Qt)
Host = 127.0.0.1
Port = 28332

# Username and password used to connect to the server (same as rpcuser and rpcpassword in riecoin.conf for solo mining). If using Stratum, the username includes the worker name (username.worker). Default: nothing
Username = user
Password = /70P$€CR€7/

# Custom payout address for solo mining (GetBlockTemplate only). Default: a donation address
PayoutAddress = RPttnMeDWkzjqqVp62SdG2ExtCor9w54EB

# Number of threads used for mining. Default: 8
Threads = 8

# The prime table used for mining will contain primes up to the given number. Use a bigger one if you have 16 GiB of available RAM or more, as you will obtain better results: this will usually reduce the ratio between the n-tuple and (n + 1)-tuples counts. Reduce if you have less than 8 GiB of RAM (or if you want to reduce memory usage). It can go up to 2^64 - 1, but setting this at more than a few billions will be too much and decrease performance. Default: 2^31
PrimeTableLimit = 2147483648

# Refresh rate of the stats in seconds. 0 to disable them: will only notify when a k-tuple or share (k >= Tuples option value if solo mining) is found, or when the network finds a block. Default: 30
RefreshInterval = 60

# For solo mining, submit not only blocks (6-tuples) but also k-tuples of at least the given length. Additionally, the base prime of such tuple will be shown in the Benchmark Mode. Default: 6
TupleLengthMin = 4

# For solo mining, add consensus rules in the GetBlockTemplate RPC call, each separated by a comma. Useful for softforks, for example, to mine SegWit transactions, you would need the following line. Default: no rule
# Rules = segwit
```

It is also possible to use custom configuration file paths, examples:

```bash
./rieMiner config/example.txt
./rieMiner "config 2.conf"
./rieMiner /home/user/rieMiner/rieMiner.conf
```

### Other statistics and benchmarking options

* BenchmarkDifficulty : only for Benchmark, sets the testing difficulty (must be from 265 to 32767). Default: 1600;
* BenchmarkTimeLimit : only for Benchmark, sets the testing duration in s. 0 for no time limit. Default: 0;
* Benchmark2tupleCountLimit : only for Benchmark, stops testing after finding this number of 2-tuples. 0 for no limit. Default: 50000;
* TupleCountsFile : Tuple Counts filename, in which rieMiner will save for each difficulty the number of tuples found. Note that there must never be more than one rieMiner instance using the same file, and you should also use different files if you use different Sieve sizes to not skew the stats (ratios). Default: None (special value that disables this feature).

### Advanced/Tweaking/Dev options

They can be useful to get better performance depending on your computer.

* SieveBits : size of the segment sieve is 2^SieveBits bits, e.g. 25 means the segment sieve size is 4 MiB. Choose this so that SieveWorkers*SieveBits fits in your L3 cache. Default: 25;
* SieveWorkers : the number of threads to use for sieving. Increasing it may solve some CPU underuse problems, but will use more memory. 0 for choosing automatically based on number of Threads and PrimeTableLimit. Default: 0.

These ones should never be modified outside developing purposes and research for now.

* ConstellationType : set your Constellation Type, i. e. the primes tuple offsets, each separated by a comma. Default: 0, 4, 2, 4, 2, 4 (values for Riecoin mining);
* PrimorialNumber : Primorial Number for the Wheel Factorization. Default: 40;
* PrimorialOffsets : list of Offsets from the Primorial for the first number in the prime tuple. Same syntax as ConsType. Default: carefully chosen offsets;
* Debug : activate Debug Mode: rieMiner will print a lot of debug messages. Set to 1 to enable, any other value do disable. Default : disabled.

Some possible constellations types (format: (type) -> offsets to put for ConstellationType ; 3 first constellations (n + 0) which can be used for PrimorialOffsets, though some might not work)

* 5-tuples
  * (0, 2, 6,  8, 12) -> 0, 2, 4, 2, 4 ; 5, 11, 101,...
  * (0, 4, 6, 10, 12) -> 0, 4, 2, 4, 2 ; 7, 97, 1867,...
* 6-tuples
  * (0, 4, 6, 10, 12, 16) -> 0, 4, 2, 4, 2, 4 (Riecoin) ; 7, 97, 16057,...
* 7-tuples
  * (0, 2, 6,  8, 12, 18, 20) -> 0, 2, 4, 2, 4, 6, 2 ; 11, 165701, 1068701,...
  * (0, 2, 8, 12, 14, 18, 20) -> 0, 2, 6, 4, 2, 4, 2 ; 5639, 88799, 284729,...
* 8-tuples
  * (0, 2, 6,  8, 12, 18, 20, 26) -> 0, 2, 4, 2, 4, 6, 2, 6 ; 11, 15760091, 25658441,...
  * (0, 2, 6, 12, 14, 20, 24, 26) -> 0, 2, 4, 6, 2, 6, 4, 2 ; 17, 1277, 113147,...
  * (0, 6, 8, 14, 18, 20, 24, 26) -> 0, 6, 2, 6, 4, 2, 4, 2 ; 88793, 284723, 855713,...

Also see the constellationsGen tool in my rieTools repository (https://github.com/Pttn/rieTools).

Note that you must use different tuple counts files if you use different constellations types.

### Memory problems

If you have memory errors, try to lower the Sieve value in the configuration file.

## Statistics

rieMiner will regularly print some stats, and the frequency of this can be changed with the Refresh parameter as said earlier.

For solo mining, rieMiner will regularly show the 1 to 3 tuples found per second metrics, and the number of 2 to 6 tuples found since the start of the mining. It will also estimate the average time to find a block by extrapolating from the 1-tuples/s (primes per second) metric and the 1 to 2-tuples/s ratio (note that all the ratios are the same, and the estimation should be fairly precise). Of course, even if the average time to find a block is for example 2 days, you could find a block in the next hour as you could find nothing during a week.

For pooled mining, the shares per minute metric and the numbers of valid and total shares are shown instead. As it is hard to get a correct estimation earnings from k-shares, no other metric is shown. The Benchmark Mode (or solo mining) can be used to get better figures for comparisons.

rieMiner will also notify if it found a k-tuple (k >= Tuples option value) in solo mining or a share in pooled mining, and if the network found a new block. If it finds a block or a share, it will tell if the submission was accepted (solo mining only) or not. For solo mining, if the block was accepted, the reward will be generated for the address specified in the options. You can then spend it after 100 confirmations. Note that orphaned blocks will be shown as accepted.

## Solo mining specific information

Note that other ways for solo mining (protocol proxies,...) were never tested with rieMiner. It was written specifically for the official wallet and the existing Riecoin pools.

### Configure the Riecoin wallet for solo mining

We assume that Riecoin Core is already working and synced. To solo mine with it, you have to configure it.

* Find the riecoin.conf configuration file. It should be located in /home/username/.riecoin or equivalent in Windows;
* **Do not confuse this file with the rieMiner.conf**!
* An example of riecoin.conf content suitable for mining is

```
rpcuser=(username)
rpcpassword=(password)
rpcport=28332
port=28333
rpcallowip=127.0.0.1
connect=(nodeip)
...
connect=(nodeip)
server=1
daemon=1
```

The (nodeip) after connect are nodes' IP, you can find a list of the nodes connected the last 24 h here: https://chainz.cryptoid.info/ric/#!network . The wallet will connect to these IP to sync. If you wish to mine from another computer, add another rpcallowip=ip.of.the.computer, or else the connection will be refused. Choose a username and a password and replace (username) and (password).

### Work control

You might have to wait some consequent time before finding a block. What if something is actually wrong and then the time the miner finally found a block, the submission fails?

First, if for some reason rieMiner disconnects from the wallet (you killed it or its computer crashed), it will detect that it has not received the mining data and then just stop mining: so if it is currently mining, everything should be fine.

If you are worried about the fact that the block will be incorrectly submitted, here comes the TupleLengthMin option. Indeed, you can send invalid blocks to the wallet (after all, it is yours), and check if the wallet actually received them and if these submissions are properly processed. When such invalid block is submitted, you can check the debug.log file in the same location as riecoin.conf, and then, you should see something like

```
ERROR: CheckProofOfWork() : n+10 not prime
```

Remember that the miner searches numbers n such that n, n + 2, n + 6, n + 10, n + 12 and n + 16 are prime, so if you set the TupleLengthMin option to for example 3, rieMiner will submit a n such that n, n + 2 and n + 6 are prime, but not necessarily the other numbers, so you can conclude that the wallet successfully decoded the submission here, and that everything works fine. If you see nothing or another error message, then something is wrong (possible example would be an unstable overclock)...

Also watch regularly if the wallet is correctly syncing, especially if the message "Blockheight = ..." did not appear since a very long time (except if the Diff is very high, in this case, it means that the network is now mining the superblock). In Riecoin-Qt, this can be done by hovering the green check at the lower right corner, and comparing the number with the latest block found in an Riecoin explorer. If something is wrong, try to change the nodes in riecoin.conf, the following always worked fine for me:

```
connect=nodes.riecoin-community.com
﻿connect=5.9.39.9
connect=37.59.143.10
﻿connect=78.83.27.28
connect=144.217.15.39
connect=149.14.200.26
connect=178.251.25.240
connect=193.70.33.8
connect=195.138.71.80
connect=198.251.84.221
connect=199.126.33.5
connect=217.182.76.201
```

Or check your connection.

## Pooled mining specific information

Existing pools:

* [XPoolX](https://xpoolx.com/ricindex.php)
  * Host = mining.xpoolx.com
  * Port = 5000
  * Owner: [xpoolx](https://bitcointalk.org/index.php?action=profile;u=605189) - info@xpoolx.com 
  * They also support Solo mining via Stratum with a 5% fee
* [RiePool](http://riepool.ovh/)
  * Host = riepool.ovh
  * Port = 8000
  * Owner: [Simba84](https://bitcointalk.org/index.php?action=profile;u=349865) - inforiepool@gmail.com 
* [uBlock.it](https://ublock.it/index.php)
  * Host = mine.ublock.it or mine.blockocean.com
  * Port = 5000
  * Owner: [ziiip](https://bitcointalk.org/index.php?action=profile;u=864739) - netops.ublock.it@gmail.com
  * Invitation needed to join (contact the owner)

The miner will disconnect if it did not receive anything during 3 minutes (time out).

## Benchmarking

rieMiner provides a way to test the performance of a computer, and compare with others. This feature can also be used to appreciate the improvements when trying to improve the miner algorithm. When sharing benchmark results, you must always communicate the difficulty, the sieve size, the test duration, the CPU model, the memory speeds (frequency and CL), the miner version, and the OS. Also, do not forget to precise if you changed other options, like the SieveWorkers or Bits.

To compare two different platforms, you must absolutely test with the same difficulty, during enough time. The proposed parameters, conditions and interpretations for serious benchmarking are:

* Standard Benchmark
  * Difficulty of 1600;
  * Sieve of 2^31 = 2147483648;
  * No memory limit;
  * Stop after finding 50000 2-tuples or more;
  * The computer must not do anything else during testing;
  * Very long for slow computers, but like the real mining conditions;
  * The system must not swap. Else, the result would not make much sense. Ensure that you have enough memory when trying to benchmark.

Once the benchmark finished itself (i. e. not by the user), it will print something like:

```
50000 2-tuples found, test finished. rieMiner 0.9RC3, difficulty 1600, sieve 2147483648
BENCHMARK RESULTS: 234.805246 primes/s with ratio 28.960823 -> 0.995788 block(s)/day
```

The block(s)/day metric is the one that should be shared or used to compare performance, though it is always good to also take in consideration the other ones. The precision will be about 2 significant digits for the block(s)/day. To get 3 solid digits, about 1 million of 2-tuples would need to be found, which would be way too long to be practical for the Standard Benchmark.

A run with valid parameters for the Standard Benchmark will additionally print the message

```
VALID parameters for Standard Benchmark
```

Which should appear if you want to share your results.

### A few results

More current results Coming Soon. Data: primes/s, ratio -> block(s)/day.

* AMD Ryzen 2700X @4 GHz, DDR4 2400 CL15, Debian 9, 0.9RC3: 234.805246, 28.960823 -> 0.995788

## Miscellaneous

Unless the weather is very cold, I do not recommend to overclock a CPU for mining, unless you can do that without increasing noticeably the power consumption. My 2700X computer would draw much, much more power at 4 GHz/1.2875 V instead of 3.7 GHz/1.08125 V, which is certainly absurd for a mere 8% increase. To get maximum efficiency, you might want to find the frequency with the best performance/power consumption ratio (which could also be obtained by underclocking the processor).

If you can, try to undervolt the CPU to reduce power consumption, heat and noise.

## Developers and license

* [Pttn](https://github.com/Pttn), author, contact: dev at Pttn dot me

Parts coming from other projects and libraries are subject to their respective licenses. Else, this work is released under the MIT license. See the [LICENSE](LICENSE) or top of source files for details.

### Notable contributors

* [Michael Bell](https://github.com/MichaelBell/): assembly optimizations, improvements of work management between threads, and some more.

## Contributing

Feel free to do a pull request or open an issue, and I will review it. I am open for adding new features, but I also wish to keep this project minimalist. Any useful contribution will be welcomed.

By contributing to rieMiner, you accept to place your code in the MIT license.

Donations welcome:

* Bitcoin: 1PttnMeD9X6imTsRojmhHa1rjudW8Bjok5
* Riecoin: RPttnMeDWkzjqqVp62SdG2ExtCor9w54EB
* Ethereum: 0x32de6b854b6a05448b4f25d4496990bece8a2862

### Quick contributor's checklist

* Your code must compile and work on recent Debian based distributions, and Windows using MSYS;
* If modifying the miner, you must ensure that your changes do not cause any performance loss. You have to do proper and long enough before/after benchmarks;
* rieMiner must work for any realistic setting, at least try these in the Benchmark Mode:
  * Difficulty 304, Sieve 2^20 (Testnet mining conditions);
  * Difficulty 800, Sieve 2^27;
  * Difficulty 1600, Sieve 2^31 (Standard Benchmark, similar to real mining conditions);
  * Difficulty 3200, Sieve 2^31 or more (we will eventually reach such Difficulties someday...).
* Ensure that your changes did not break anything, even if it compiles. Examples (if applicable):
  * There should never be random (or not) segmentation faults or any other bug, try to do actual mining with Gdb, debugging symbols and Debug Mode enabled during hours or even days to catch possible bugs;
  * Ensure that valid work is produced (pools and Riecoin-Qt must not reject submissions);
  * Mining must stop completely while disconnected and restart properly when connection is established again.
* Follow the style of the rest of the code (curly braces position, camelCase variable names, tabs and not spaces, spaces around + and - but not around * and /,...).

## Resources

* [rieMiner thread on Riecoin-Community.com forum](https://forum.riecoin-community.com/viewtopic.php?f=16&t=15)
* [My personal website about Riecoin](http://ric.Pttn.me/)
* [Get the Riecoin wallet](http://riecoin.org/download.html)
* [Fast prime cluster search - or building a fast Riecoin miner (part 1)](https://da-data.blogspot.ch/2014/03/fast-prime-cluster-search-or-building.html), nice article by dave-andersen explaining how Riecoin works and how to build an efficient miner and the algorithms. Unfortunately, he never published part 2...
* [Riecoin FAQ](http://riecoin.org/faq.html) and [technical aspects](http://riecoin.org/about.html#tech)
* [Bitcoin Wiki - Getblocktemplate](https://en.bitcoin.it/wiki/Getblocktemplate)
* [BIP141](https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki) (Segwit)
* [Bitcoin Wiki - Stratum](https://en.bitcoin.it/wiki/Stratum_mining_protocol)
