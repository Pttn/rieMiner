# rieMiner 0.92α1

rieMiner is a Riecoin miner supporting both solo and pooled mining. It was originally adapted and refactored from gatra's [cpuminer-rminerd](https://github.com/gatra/cpuminer-rminerd) and dave-andersen's [fastrie](https://github.com/dave-andersen/fastrie), though there is no remaining code from rminerd anymore.

Solo mining is done using the GetBlockTemplate protocol, while pooled mining is via the Stratum protocol. Additionally, a benchmark mode is also proposed to compare more easily the performance between different computers, as well as a pure prime constellation searching Mode for world record attempts!

Find the latest binaries [here](https://github.com/Pttn/rieMiner/releases) for Linux and Windows.
This README serves as manual for rieMiner. I hope that this program will be useful for you!

The Riecoin community thanks you for your participation, you will be a contributor to the robustness of the Riecoin network. Happy mining!

![rieMiner just found a block](https://riecoin.dev/wp-content/uploads/2019/09/rieMiner.png)

Suggestions? Having issues with rieMiner? Join us in [Discord](https://discordapp.com/channels/525275069946003457) ([invite](https://discord.gg/2sJEayC))!

## Minimum requirements

Only x64 systems with SSE are supported.

* Windows 8.1 or recent enough Linux;
* x64 CPU with SSE instruction set;
* 1 GiB of RAM (the prime table limit must be manually set at a lower value in the options).

Recommended:

* Windows 10 (latest version) or Debian 10;
* Recent Intel or AMD, with 8 cores or more;
* 8 GiB of RAM or more.

## Compile this program

### In Debian/Ubuntu x64

You can compile this C++ program with g++, as, m4 and make, install them if needed. Then, get if needed the following dependencies:

* [Jansson](http://www.digip.org/jansson/)
* [cURL](https://curl.haxx.se/)
* [libSSL](https://www.openssl.org/)
* [GMP](https://gmplib.org/)

On a recent enough Debian or Ubuntu, you can easily install these by doing as root:

```bash
apt install g++ make m4 git libjansson-dev libcurl4-openssl-dev libssl-dev libgmp-dev
```

Then, just download the source files, go/`cd` to the directory, and do a simple make:

```bash
git clone https://github.com/Pttn/rieMiner.git
cd rieMiner
make
```

For other Linux, executing equivalent commands (using `pacman` instead of `apt`,...) should work.

### In Windows x64

You can compile rieMiner in Windows, and here is one way to do this. First, install [MSYS2](http://www.msys2.org/) (follow the instructions on the website), then enter in the MSYS **MinGW-w64** console, and install the tools and dependencies:

```bash
pacman -S make git
pacman -S mingw64/mingw-w64-x86_64-gcc
pacman -S mingw64/mingw-w64-x86_64-curl
```

Note that you must install the `mingw64/mingw-w64-x86_64-...` packages and not just `gcc` or `curl`.

Clone rieMiner with `git` like for Linux, go to its directory with `cd`, and compile with `make`.

#### Static building

The produced executable will only run in the MSYS console, or if all the needed DLLs are next to the executable. To obtain a standalone executable, you need to link statically the dependencies. Unfortunately, libcurl will give you a hard time, and you need to compile it yourself.

First, download the [latest official libcurl code](https://curl.haxx.se/download.html) on their website, under "Source Archives", and decompress the folder somewhere (for example, next to the rieMiner's one).

In the MSYS MinGW-w64 console, cd to the libcurl directory. We will now configure it to not build unused features, then compile it:

```bash
./configure --disable-dict --disable-file --disable-ftp --disable-gopher --disable-imap --disable-ldap --disable-ldaps --disable-pop3 --disable-rtsp --disable-smtp --disable-telnet --disable-tftp --without-ssl --without-libssh2 --without-zlib --without-brotli --without-libidn2  --without-ldap  --without-ldaps --without-rtsp --without-psl --without-librtmp --without-libpsl --without-nghttp2 --disable-shared --disable-libcurl-option
make
```

Once done:

* Create "incs" and "libs" folders in the rieMiner directory;
* In the downloaded libcurl directory, go to the include directory and copy the "curl" folder to the "incs" folder;
* Do the same with the file "libcurl.a" from the libs/.lib folder to the rieMiner's "libs" folder.

Now, you should be able to compile rieMiner with `make static` and produce a standalone executable.

## Run and configure this program

You can finally run the newly created rieMiner executable using

```bash
./rieMiner
```

### Modes

rieMiner proposes the following Modes depending on what you want to do.

* Solo: solo mining via GetBlockTemplate;
* Pool: pooled mining using Stratum;
* Benchmark: test performance with a simulated and deterministic network;
* Search: pure prime constellation search (useful for records attempts);
* Test: simulates various network situations for testing.

### Configuration

If no "rieMiner.conf" next to the executable was found, you will be assisted to configure rieMiner. Answer to its questions to start mining. If there is a "rieMiner.conf" file next to the executable with incorrect information that was read, you can delete this to get the assistant.

Alternatively, you can create or edit this "rieMiner.conf" file next to the executable yourself, in order to provide options to the miner. The rieMiner.conf syntax is very simple: each option is given by a line such

```
Option type = Option value
```

It is case sensitive. A line starting with "#" will be ignored, as well as invalid ones. A single space or tab before or after "=" is also ignored. **Do not put ; at the end or use other delimiters than =** for each line, and **do not confuse rieMiner.conf with riecoin.conf**! If an option is missing, the default value(s) will be used. If there are duplicate lines, the last one will be used. Here is a sample configuration file for solo mining, with comments explaining the main available options.

```
# The mode, see above. Default: Benchmark
Mode = Solo

# IP and port of the Riecoin wallet/server or pool. Default: 127.0.0.1 (your computer), port 28332 (default port for Riecoin-Qt)
Host = 127.0.0.1
Port = 28332

# Username and password used to connect to the server (same as rpcuser and rpcpassword in riecoin.conf for solo mining).
# If using Stratum, the username includes the worker name (username.worker). Default: empty values
Username = user
Password = /70P$€CR€7/

# Custom payout address for solo mining.
# You can use Bech32 P2WPKH "ric1" addresses. Bech32 P2WSH is not supported for now.
# Default: this donation address
PayoutAddress = ric1qpttn5u8u9470za84kt4y0lzz4zllzm4pyzhuge

# Number of threads used for mining. Default: 8
Threads = 8

# The prime table used for mining will contain primes up to the given number.
# Use a bigger limit if you have 16 GiB of available RAM or more, as this will reduce the ratio between the n-tuple and (n + 1)-tuple counts (but also the 1-tuple find rate).
# Reduce if you have less than 8 GiB of RAM (or if you want to reduce memory usage).
# It can go up to 2^64 - 1, but setting this at more than 2^33 will usually be too much and decrease performance. Default: 2^31
PrimeTableLimit = 2147483648

# Refresh rate of the stats in seconds. 0 to disable them and only notify when a long enough tuple or share is found, or when the network finds a block. Default: 30
RefreshInterval = 60

# For solo mining, submit not only blocks (6-tuples) but also k-tuples of at least the given length.
# Additionally, the base prime of such tuple will be shown in the Search Mode. Default: 6
TupleLengthMin = 4

# For solo mining, there is a developer fee of 1%. Choose how many % you wish to donate between 1 and 99 (only integers!). Default: 2
Donate = 5

# Which sort of constellation the miner will mine. Currently, Riecoin MainNet accepts '0, 4, 2, 4, 2, 4' constellations, and TestNet '0, 2, 4, 2'. Default: 0, 4, 2, 4, 2, 4
# Note that the offsets are not cumulative, so '0, 4, 2, 4, 2, 4' corresponds to n + (0, 4, 6, 10, 12, 16).
# ConstellationType = 0, 2, 4, 2

# Other options
# Difficulty = 1600
# BenchmarkBlockInterval = 150
# BenchmarkTimeLimit = 0
# Benchmark2tupleCountLimit = 100000
# SieveBits = 25
# SieveWorkers = 0
# PrimorialNumber = 40
# PrimorialOffsets = 4209995887, 4209999247, 4210002607, 4210005967, 7452755407, 7452758767, 7452762127, 7452765487, 8145217177, 8145220537, 8145223897, 8145227257
# Debug = 0
# For solo mining, add consensus rules in the GetBlockTemplate RPC call, each separated by a comma. 'segwit' must be present.
# Rules = segwit
```

It is also possible to use custom configuration file paths, examples:

```bash
./rieMiner config/example.txt
./rieMiner "config 2.conf"
./rieMiner /home/user/rieMiner/rieMiner.conf
```

#### Benchmark and Search Modes options

* Difficulty: for Benchmark and Search Modes, sets the difficulty (must be from 265 to 32767). Default: 1600;
* BenchmarkBlockInterval: for Benchmark Mode, sets the time between blocks in s. Default: 150;
* BenchmarkTimeLimit: for Benchmark Mode, sets the testing duration in s. 0 for no time limit. Default: 0;
* Benchmark2tupleCountLimit: for Benchmark Mode, stops testing after finding this number of 2-tuples. 0 for no limit. Default: 50000;
* TuplesFile: for Search Mode, write tuples of at least length TupleLengthMin to the given file. Default: None (special value that disables this feature).

#### Advanced/Tweaking/Dev options

They can be useful to get better performance depending on your computer.

* EnableAVX2 : by default, AVX2 is disabled, as it may increase the power consumption more than the performance improvements. If your processor supports AVX2, you can choose to take advantage of this instruction set if you wish by setting this option to `Yes`. Do your own testing to find out if it is worth it. AVX2 is known to degrade performance for AMD Ryzens and similar before Zen2 (e. g. 1800X, 1950X, 2700X) and should be left disabled in these cases;
* SieveBits : size of the segment sieve is 2^SieveBits bits, e.g. 25 means the segment sieve size is 4 MiB. Choose this so that SieveWorkers*2^SieveBits fits in your L3 cache. Default: 25;
* SieveWorkers : the number of threads to use for sieving. Increasing it may solve some CPU underuse problems, but will use more memory. 0 for choosing automatically based on number of Threads and PrimeTableLimit. Default: 0.

These ones should never be modified outside developing purposes and research for now.

* PrimorialNumber : Primorial Number for the Wheel Factorization. Default: 40;
* PrimorialOffsets : list of Offsets from the Primorial for the first number in the prime tuple. Same syntax as ConstellationType. Default: see main.hpp source file;
* Debug : activate Debug Mode: rieMiner will print a lot of debug messages. Set to 1 to enable, 0 to disable. Other values may introduce some more specific debug messages. Default : 0.

### Memory problems

If you have memory errors (Unable to allocate... or Bad Allocs), try to lower the PrimeTableLimit value in the configuration file.

## Statistics

rieMiner will regularly print some statistics, and the frequency of this can be changed with the RefreshInterval parameter as said earlier. They consist of the candidates per second speed and the 0 to 1-tuples/s ratio. The estimate of the average time to find a block (for pooled mining, the earnings in RIC/day) is also shown. Of course, even if the average time to find a block is for example 2 days, you could find a block in the next hour as you could find nothing during a week. The number of tuples found since the start of the mining is also shown (for pooled mining, the numbers of valid and total shares).

rieMiner will also notify if it found a k-tuple (k >= Tuples option value) in solo mining or a share in pooled mining, and if the network found a new block. If it finds a block or a share, it will tell if the submission was accepted (solo mining only) or not. For solo mining, if the block was accepted, the reward will be generated for the address specified in the options. You can then spend it after 100 confirmations. Note that orphaned blocks will be shown as accepted.

## Solo mining specific information

Note that other ways for solo mining (protocol proxies,...) were never tested with rieMiner. It was written specifically for the official wallet and the existing Riecoin pools.

Also, rieMiner 0.92 is no longer compatible with Riecoin Core 0.16.3, and is required for 0.20.0.

### Configure the Riecoin wallet for solo mining

We assume that Riecoin Core is already working and synced. To solo mine with it, you have to configure it.

* Find the riecoin.conf configuration file. It should be located in /home/username/.riecoin or equivalent in Windows;
* **Do not confuse this file with the rieMiner.conf**!
* Here is a template of riecoin.conf suitable for mining (if mining from the same computer that runs Riecoin Core).

```
rpcuser=(username)
rpcpassword=(password)
server=1
daemon=1
rpcallowip=127.0.0.1

[main]
rpcport=28332
port=28333

[test]
rpcport=38332
port=38333
```

Choose a username and a password and replace (username) and (password). The ones in `rieMiner.conf` must match with them.

If mining for the first time, you should try to mine a few blocks in Testnet to ensure that everything works fine. To use Testnet, either add `testnet=1` at the beginning of `riecoin.conf` before running Riecoin Core, or start it with the command line option `-testnet`. Of course don't forget to set the appropriate Constellation Type. Note that you will probably find blocks so fast that many of them are rejected, this is normal (often, the error message will be `inconclusive`).

#### Mine with another or multiple computer(s)

If you wish to mine from another computer, add another `rpcallowip=ip.of.the.miningcomputer`, or else the connection will be refused. You will also need to add the option `rpcbind=ip.of.the.server`, where `ip.of.the.server` is the IP or the computer running the Riecoin Core node.

For example, if your computer running Riecoin has the local IP `192.168.1.100`, and you wish to mine with multiple computers from the local network, you can use `rpcallowip=192.168.1.0/24` to allow all these computers, and also need to add `rpcbind=192.168.1.100` in the `riecoin.conf` file. The miners' `rieMiner.conf` must have the setting `Host = 192.168.1.100`.

## Pooled mining specific information

Please choose a pool that does not already have a lot of mining power to prevent centralization. List:

* [XPoolX](https://xpoolx.com/), no account needed
  * Host = mining.xpoolx.com
  * Port = 2090
  * User = (Riecoin address)
  * Owner: [xpoolx](https://bitcointalk.org/index.php?action=profile;u=605189) - info@xpoolx.com 
* [PikaPools](http://ric.pikapools.com/), no account needed
  * Host = ric.pikapools.com
  * Port = 5000
  * User = (Riecoin address)
  * Owner: [1AndOnlyPika](https://bitcointalk.org/index.php?action=profile;u=2803096)
* [Suprnova](https://ric.suprnova.cc/)
  * Host = ric.suprnova.cc
  * Port = 5000
  * Owner: [OcMiner](https://twitter.com/SuprnovaPools)
* [uBlock.it](https://ublock.it/index.php)
  * Host = mine.ublock.it or mine.blockocean.com
  * Port = 5000
  * Owner: [ziiip](https://bitcointalk.org/index.php?action=profile;u=864739) - netops.ublock.it@gmail.com

The miner will disconnect if it did not receive anything during 3 minutes (time out).

## Benchmarking

rieMiner provides a way to test the performance of a computer, and compare with others. This feature can also be used to appreciate the improvements when trying to improve the miner algorithm. When sharing benchmark results, you must always communicate the difficulty, the prime table limit (PTL), the test duration, the CPU model, the memory speeds (frequency and CL), the miner version, and the OS. Also, do not forget to precise if you changed other options, like the SieveWorkers or Bits.

## Search Mode

rieMiner can be used to break prime constellations world records outside the Riecoin network with the Search Mode. Alternatively, it can serve as a Benchmark Mode without blocks.

To attempt a new record, you have to choose a constellation type and a Difficulty that is over the current record, and tweak the advanced configuration options to get the best performance, especially for 7-tuples and longer and if you have a lot of Threads.

If you have trouble doing it, you can ask for help in the #competition channel of the Riecoin's Discord. A guide will be provided later.

The [list of current prime k-tuplets world records](http://anthony.d.forbes.googlepages.com/ktuplets.htm) is maintained by Tony Forbes. Contact him if you find a new record. Good luck!

## Test Mode

This mode can be used to test the code. It does the following:

* Start at Difficulty 800;
* Increases it by 10 every 10 s 5 times;
* Simulates a disconnect after 10 more seconds;
* Restart with Difficulty 1600;
* Increases it by 40 after 30 and 20 s;
* Simulates another disconnect after 10 more seconds;
* Repeat.

## Miscellaneous

Unless the weather is very cold, I do not recommend to overclock a CPU for mining, unless you can do that without increasing noticeably the power consumption. To get maximum efficiency, you might want to find the frequency with the best performance/power consumption ratio (which could also be obtained by underclocking the processor).

If you can, try to undervolt the CPU to reduce power consumption, heat and noise.

## Developers and license

* [Pttn](https://github.com/Pttn), author and maintainer, contact: dev at Pttn dot me

Parts coming from other projects and libraries are subject to their respective licenses. Else, this work is released under the MIT license. See the [LICENSE](LICENSE) or top of source files for details.

### Notable contributors

* [Michael Bell](https://github.com/MichaelBell/): assembly optimizations, improvements of work management between threads, and some more.

### Versioning

The version naming scheme is 0.9, 0.99, 0.999 and so on for major versions, analogous to 1.0, 2.0, 3.0,.... The first non 9 decimal digit is minor, etc. For example, the version 0.9925a can be thought as 2.2.5a. A perfect bug-free software will be version 1. No precise criteria have been decided about incrementing major or minor versions for now.

## Contributing

Feel free to do a pull request or open an issue, and I will review it. I am open for adding new features, but I also wish to keep this project minimalist. Any useful contribution will be welcomed.

By contributing to rieMiner, you accept to place your code in the MIT license.

Donations welcome:

* Riecoin: ric1qpttn5u8u9470za84kt4y0lzz4zllzm4pyzhuge
* Bitcoin: bc1qpttn5u8u9470za84kt4y0lzz4zllzm4pwvel4c

Or donate directly to the Riecoin project: ric1qr3yxckxtl7lacvtuzhrdrtrlzvlydane2h37ja (RIC), bc1qr3yxckxtl7lacvtuzhrdrtrlzvlydaneqela0u (BTC).

### Quick contributor's checklist

* Your code must compile and work on recent Debian based distributions, and Windows using MSYS;
* If modifying the miner, you must ensure that your changes do not cause any performance loss. You have to do proper and long enough before/after benchmarks;
* Document well non trivial contributions to the miner so other and future developers can understand easily and quickly the code;
* rieMiner must work for any realistic setting, you should test using the Test Mode with a few different settings;
* Ensure that your changes did not break anything, even if it compiles. Examples (if applicable):
  * There should never be random (or not) segmentation faults or any other bug, try to do actual mining with Gdb, debugging symbols and Debug Mode enabled during hours or even days to catch possible bugs;
  * Ensure that valid work is produced (pools and Riecoin-Qt must not reject submissions);
  * Mining must stop completely while disconnected and restart properly when connection is established again.
* Follow the style of the rest of the code (curly braces position, camelCase variable names, tabs and not spaces, spaces around + and - but not around * and /,...).
  * Avoid using old C style and prefer modern C++ code;
  * Prefer longer and explicit variable names (except for loops indexes where single letter variables should be used in most cases).

## Resources

* [Get the Riecoin wallet](https://riecoin.dev/download/)
* [Fast prime cluster search - or building a fast Riecoin miner (part 1)](https://da-data.blogspot.ch/2014/03/fast-prime-cluster-search-or-building.html), nice article by dave-andersen explaining how Riecoin works and how to build an efficient miner and the algorithms. Unfortunately, he never published part 2...
* [Technical resources about Riecoin](https://riecoin.dev/resources/)
* [Bitcoin Wiki - Getblocktemplate](https://en.bitcoin.it/wiki/Getblocktemplate)
* [BIP141](https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki) (Segwit)
* [Bitcoin Wiki - Stratum](https://en.bitcoin.it/wiki/Stratum_mining_protocol)
