# rieMiner 0.92

rieMiner is a Riecoin miner supporting both solo and pooled mining, and can also be run standalone for prime constellation record attempts. Find the latest binaries [here](https://github.com/Pttn/rieMiner/releases) for Linux and Windows.

This README is intended for advanced users and will mainly only describe the different configuration options and give information for developers like how to compile or contribute. For more practical information on how to use rieMiner like configuration file templates and mining or record attempts guides, visit the [rieMiner's page](https://riecoin.dev/en/rieMiner). **Before asking for any help or reporting an issue, ensure that you followed the instructions correctly, and try first to solve the issues by yourself**.

Happy Mining or Good Luck on finding a new record!

## Minimum requirements

Only x64 systems with SSE are supported. If you want to run rieMiner on other systems, in particular with x86 or ARM CPUs (this includes Raspberry Pis), you need to use the [Light branch](https://github.com/Pttn/rieMiner/tree/Light) and compile yourself the code. 

* Windows 8.1 or recent enough Linux;
* x64 CPU with SSE instruction set;
* 1 GiB of RAM (the prime table limit must be manually set at a lower value in the options).

Recommended:

* Windows 10 (latest version) or Debian 10;
* Recent Intel or AMD, with 8 cores or more;
* 8 GiB (16 if using more than 8 cores) of RAM or more.

## Compile this program

Compilation should work fine for the systems below. If not, please report any issue. However, if you are trying to compile on another system or an older version, you are on your own, please don't report any problem in these cases.

### On Debian/Ubuntu x64

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

### On Windows x64

You can compile rieMiner on Windows, and here is one way to do this. First, install [MSYS2](http://www.msys2.org/) (follow the instructions on the website), then enter in the MSYS **MinGW-w64** console, and install the tools and dependencies:

```bash
pacman -S make git
pacman -S mingw64/mingw-w64-x86_64-gcc
pacman -S mingw64/mingw-w64-x86_64-curl
```

Note that you must install the `mingw64/mingw-w64-x86_64-...` packages and not just `gcc` or `curl`.

Clone rieMiner with `git`, go to its directory with `cd`, and compile with `make` (same commands as Linux, see above).

#### Static building

The produced executable will only run in the MSYS console, or if all the needed DLLs are next to the executable. To obtain a standalone executable, you need to link statically the dependencies. For this, you need to compile libcurl yourself.

First, download the [latest official libcurl code](https://curl.haxx.se/download.html) on their website, under "Source Archives", and decompress the folder somewhere (for example, next to the rieMiner's one).

In the MSYS MinGW-w64 console, cd to the libcurl directory. We will now configure it to not build unused features, then compile it:

```bash
./configure --disable-dict --disable-file --disable-ftp --disable-gopher --disable-imap --disable-ldap --disable-ldaps --disable-pop3 --disable-rtsp --disable-smtp --disable-telnet --disable-tftp --without-ssl --without-libssh2 --without-zlib --without-brotli --without-zstd --without-libidn2  --without-ldap  --without-ldaps --without-rtsp --without-psl --without-librtmp --without-libpsl --without-nghttp2 --disable-shared --disable-libcurl-option
make
```

Once done:

* Create "incs" and "libs" folders in the rieMiner directory;
* In the downloaded libcurl directory, go to the include directory and copy the "curl" folder to the "incs" folder;
* Do the same with the file "libcurl.a" from the libs/.lib folder to the rieMiner's "libs" folder.

Now, you should be able to compile rieMiner with `make static` and produce a standalone executable.

## Configure this program

rieMiner uses a text configuration file, by default a "rieMiner.conf" file next to the executable. It is also possible to use custom paths, examples:

```bash
./rieMiner config/example.txt
./rieMiner "config 2.conf"
./rieMiner /home/user/rieMiner/rieMiner.conf
```

If the provided configuration file was not found, you will be asked a few questions to configure very basic settings of Solo or Pooled Mining.

For other Modes or more options, you need to know how to write a configuration file yourself. The rieMiner.conf syntax is very simple: each option is set by a line like

```
Option = Value
```

It is case sensitive. A line starting with "#" will be ignored, as well as invalid ones. A single space or tab before or after "=" is also ignored. If an option is missing, the default value(s) will be used. If there are duplicate lines for the same option, the last one will be used.

Alternatively, command line options can be used like

```bash
./rieMiner config.conf Option1=Value1 "Option2 = Value2" Option3=WeirdValue\!\!
```

A configuration file path must always be provided. If the file exists, its options will be parsed first, then the command line ones, so the latter will override the common ones from the file. Else, it is just ignored, so just put a dummy value if you want to configure only by command line. The syntax of a command line option is the same as a line of the configuration file. You are responsible to correctly take care of special characters if needed.

### Modes

rieMiner proposes the following Modes depending on what you want to do. Use the `Mode` option to choose one of them (by default, `Benchmark`), below are the values to use.

* `Solo`: solo mining via GetBlockTemplate;
* `Pool`: pooled mining using Stratum;
* `Benchmark`: test performance with a simulated and deterministic network (use this to compare different settings or share your benchmark results);
* `Search`: pure prime constellation search (useful for record attempts);
* `Test`: simulates various network situations for testing, see below.

#### Test Mode

It does the following:

* Start at Difficulty 1600, the first time with constellation pattern 0, 2, 4, 2, 4;
* Increases Difficulty by 10 every 10 s two times;
* After 10 more seconds, sets Difficulty to 1200 and the constellation pattern to 0, 2, 4, 2, 4, 6, 2;
* Decreases Difficulty by 20 every 10 s (the time taken to restart the miner is counted, so if it takes more than 10 s, it is normal that a new block appears immediately after the reinitialization);
* The miner restarts several times due to the Difficulty variation (this adjusts some parameters if not set);
* When the Difficulty reaches 1040, a disconnect is simulated;
* Repeat (keeping the 7-tuple constellation). The miner will restart twice as when it disconnects, it is not aware that the Difficulty increased a lot.

### Solo and Pooled Mining options

* `Host`: IP of the Riecoin server. Default: 127.0.0.1 (your computer);
* `Port`: port of the Riecoin server (same as rpcport in riecoin.conf for solo mining). Default: 28332 (default RPC port for Riecoin Core);
* `Username`: username used to connect to the server (same as rpcuser in riecoin.conf for solo mining). Default: empty;
* `Password`: password used to connect to the server (same as rpcpassword in riecoin.conf for solo mining). Default: empty;
* `PayoutAddress`: payout address for solo mining. You can use Bech32 "ric1" addresses (only lowercase). Default: a donation address;
* `Donate`: for solo mining, choose how many % of the block reward you wish to donate to the Riecoin Project (only integers!). Default: 2;
* `Rules`: for solo mining, add consensus rules in the GetBlockTemplate RPC call, each separated by a comma. `segwit` must be present. You should not touch this unless a major Riecoin upgrade is upcoming and it is said to use this option. Default: segwit.

### Benchmark and Search Modes options

* `Difficulty`: for Benchmark and Search Modes, sets the difficulty (which is the number of binary digits, it must be at least 128). It can take decimal values and the numbers will be around 2^Difficulty. Default: 1024;
* `TupleLengthMin`: for Search Mode, the base prime of tuples of at least this length will be shown. 0 for the length of the constellation pattern - 1 (minimum 1). Default: 0;
* `BenchmarkBlockInterval`: for Benchmark Mode, sets the time between blocks in s. <= 0 for no block. Default: 150;
* `BenchmarkTimeLimit`: for Benchmark Mode, sets the testing duration limit in s. <= 0 for no time limit. Default: 86400;
* `BenchmarkPrimeCountLimit`: for Benchmark Mode, stops testing after finding this number of 1-tuples. 0 for no limit. Default: 1000000;
* `TuplesFile`: for Search Mode, write tuples of at least length TupleLengthMin to the given file. Default: Tuples.txt.

### More options

* `Threads`: number of threads used for mining, 0 to autodetect. Default: 0;
* `PrimeTableLimit`: the prime table used for mining will contain primes up to the given number. Set to 0 to automatically calculate according to the current Difficulty. You can try a larger limit as this will reduce the ratio between the n-tuple and (n + 1)-tuple counts (but also the candidates/s rate). Reduce if you want to lower memory usage. Default: 0;
* `EnableAVX2`: by default, AVX2 is disabled, as it may increase the power consumption more than the performance improvements. If your processor supports AVX2, you can choose to take advantage of this instruction set if you wish by setting this option to `Yes`. Do your own testing to find out if it is worth it. AVX2 is known to degrade performance for AMD Ryzens and similar before Zen2 (e. g. 1800X, 1950X, 2700X) and should be left disabled in these cases;
* `SieveBits`: the size of the primorial factors table for the sieve is 2^SieveBits bits. 25 seems to be an optimal value, or 24 if there are many SieveWorkers. Though, if you have less than 8 MiB of L3 cache, you can try to decrement this value. Default: 25 if SieveWorkers <= 4, 24 otherwise;
* `SieveIterations`: how many times the primorial factors table is reused for sieving. Increasing will decrease the frequency of new jobs, so less time would be "lost" in sieving, but this will also increase the memory usage. It is not clear however how this actually plays performance wise, 16 seems to be a good value. Default: 16;
* `SieveWorkers`: the number of threads to use for sieving. Increasing it may solve some CPU underuse problems, but will use more memory. 0 for choosing automatically. Default: 0;
* `RestartDifficultyFactor`: if the Difficulty changes by the given factor, the miner will restart. Useful to let it retune some parameters once a while to optimize for lower or higher Difficulties as it varies. This value must be at least 1 and the closer it is to 1 and the more often there will be restarts. Default: 1.05;
* `ConstellationPattern`: which sort of constellations to look for, as offsets separated by commas. Note that they are not cumulative, so '0, 2, 4, 2, 4, 6, 2' corresponds to n + (0, 2, 6, 8, 12, 18, 20). If empty (or not accepted by the server), a valid pattern will be chosen (0, 2, 4, 2, 4, 6, 2 in Search and Benchmark Modes). Default: empty;
* `PrimorialNumber`: Primorial Number for the sieve process. Higher is better, but it is limited by the target offset limit. 0 to set automatically, it should be left as is. Default: 0;
* `PrimorialOffsets`: list of offsets from a primorial multiple to use for the sieve process, separated by commas. If empty, a default one will be chosen if possible (see main.hpp source file), otherwise rieMiner will not start (if the chosen constellation pattern is not in main.hpp). Default: empty;
* `RefreshInterval`: refresh rate of the stats in seconds. <= 0 to disable them and only notify when a long enough tuple or share is found, or when the network finds a block. Default: 30;
* `GeneratePrimeTableFileUpTo`: if > 1, generates the table of primes up to the given limit and saves it to a `PrimeTable64.bin` file, which will be reused instead of recomputing the table at every miner initialization. This does not affect mining, but is useful if restarting rieMiner often with large Prime Table Limits, notably for debugging or benchmarks. However, the file will take a few GB of disk space for large limits and you should have a fast SSD. Default: 0;
* `Debug`: activate Debug Mode: rieMiner will print a lot of debug messages. Set to 1 to enable, 0 to disable. Other values may introduce some more specific debug messages. Default : 0.

## Interface

For now, rieMiner only works in a console. First, it will summarize the settings and print some information about the miner initialization, and you should look there to ensure that your settings were taken in account.

During mining, rieMiner will regularly print some statistics (use the `RefreshInterval` parameter to change the frequency). They consist of the candidates per second speed `c/s` and the 0 to 1-tuples/s ratio `r`. The estimate of the average time to find a block (for pooled mining, the earnings in RIC/day) is also shown. The number of tuples found since the start of mining is also shown (for pooled mining, the numbers of valid and total shares).

rieMiner will also notify if it found a block or a share, and if the network found a new block. If it finds a block or a share, it will tell if the submission was accepted (solo mining only) or not by the server.

In Benchmark, Search and Test Modes, the behavior is essentially the same as Solo mining. In mining and Test Modes, the statistics are based on the tuples found during the latest five blocks, including the current one. In the other Modes, everything since the beginning is taken in account.

## Developers and license

* [Pttn](https://github.com/Pttn), author and maintainer, contact: dev at Pttn dot me

This work is released under the MIT license, except the modified GMP code which is licensed with the LGPL license.

### Notable contributors

* [Michael Bell](https://github.com/MichaelBell/): assembly optimizations, improvements of work management between threads, and some more.

### Versioning

The version naming scheme is 0.9, 0.99, 0.999 and so on for major versions, analogous to 1.0, 2.0, 3.0,.... The first non 9 decimal digit is minor, etc. For example, the version 0.9925a can be thought as 2.2.5a. A perfect bug-free software will be version 1. No precise criteria have been decided about incrementing major or minor versions for now.

## Contributing

Feel free to do a pull request or open an issue, and I will review it. I am open for adding new features, but I also wish to keep this project minimalist. Any useful contribution will be welcomed.

By contributing to rieMiner, you accept to place your code in the MIT license.

Donations to the Riecoin Project are welcome (you can also set a higher Donate value when Solo Mining):

* Riecoin: ric1qr3yxckxtl7lacvtuzhrdrtrlzvlydane2h37ja
* Bitcoin: bc1qr3yxckxtl7lacvtuzhrdrtrlzvlydaneqela0u

### Quick contributor's checklist

* Your code must compile and work on recent Debian based distributions, and Windows using MSYS;
* If modifying the miner, you must ensure that your changes do not cause any performance loss. You have to do proper and long enough before/after benchmarks;
* Document well non trivial contributions to the miner so other and future developers can understand easily and quickly the code;
* rieMiner must work for any realistic setting, the Test Mode must work as expected;
* Ensure that your changes did not break anything, even if it compiles. Examples (if applicable):
  * There should never be random (or not) segmentation faults or any other bug, try to do actual mining with Gdb, debugging symbols and Debug Mode enabled during hours or even days to catch possible bugs;
  * Ensure that valid work is produced (pools and Riecoin Core must not reject submissions);
  * Mining must stop completely while disconnected and restart properly when connection is established again.
* Follow the style of the rest of the code (curly braces position, camelCase variable names, tabs and not spaces, spaces around + and - but not around * and /,...).
  * Avoid using old C style and prefer modern C++ code;
  * Prefer longer and explicit variable names (except for loops indexes where single letter variables should be used in most cases).

## Resources

* [Riecoin website](https://Riecoin.dev/)
  * [rieMiner's page](https://riecoin.dev/en/rieMiner)
  * [Explanation of the miner algorithm](https://riecoin.dev/en/Mining_Algorithm), you can also learn the theoretics behind some options
* [Bitcoin Wiki - Getblocktemplate](https://en.bitcoin.it/wiki/Getblocktemplate)
* [BIP141](https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki) (Segwit)
* [Bitcoin Wiki - Stratum](https://en.bitcoin.it/wiki/Stratum_mining_protocol)
