# rieMiner 0.9β2.1

rieMiner is a Riecoin miner supporting both solo and pooled mining, and using the latest known mining algorithm. It was originally adapted and refactored from gatra's cpuminer-rminerd (https://github.com/gatra/cpuminer-rminerd) and dave-andersen's fastrie (https://github.com/dave-andersen/fastrie).

Solo mining is done using the GetBlockTemplate protocol, while pooled mining is via the Stratum protocol. A benchmark mode is also proposed to compare more easily the performance between different computers.

Official binaries will be distributed when the stable 0.9 code is out (which will not until Riecoin Core is officially updated).

This README also serves as manual for rieMiner. I hope that this program will be useful for you! Happy mining!

![rieMiner just found a block](https://pttn.me/medias/bildoj/alia/rieMiner1.png)

## Compile this program

### In Debian/Ubuntu x64

You can compile this C++ program with g++ and make, install them if needed. Then, get if needed the following dependencies:

* Jansson
* cURL
* libSSL
* GMP

On a recent enough Debian or Ubuntu, you can easily install these by doing as root:

```bash
apt install g++ make git libjansson-dev libcurl4-openssl-dev libssl-dev libgmp-dev
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

Edit the Makefile and add -lws2_32 at the end of the LIBS line, go to the rieMiner's directory with cd, and finally compile with make.

#### Static building

The produced executable will run only in the MSYS console, or if all the needed DLLs are next to the executable. To obtain a standalone executable, you need to link statically the dependencies. Normally, this is done just by adding "-static" at the LIBS line in the Makefile. Unfortunately, libcurl will give you a hard time, and you need to compile it yourself.

First, edit the Makefile add "-D CURL_STATICLIB" at the end of the CFLAGS line, and "-static" just after the "LIBS =" in the LIBS line. You might also want to change the march argument to support other/olders processors.

```
CFLAGS = -Wall -Wextra -std=gnu++11 -O3 -march=native -D CURL_STATICLIB
LIBS   = -static -pthread -ljansson -lcurl -lgmp -lgmpxx -lcrypto -lws2_32
```

Then, download the [latest official libcurl code](https://curl.haxx.se/download.html) on their website, under "Source Archives", and decompress the folder somewhere (for example, next to the rieMiner's one).

In the MSYS MinGW-w64 console, cd to the libcurl directory. We will now configure it so we will not build unused features:

```bash
./configure --disable-dict --disable-file --disable-ftp --disable-gopher --disable-imap --disable-ldap --disable-ldaps --disable-pop3 --disable-rtsp --disable-smtp --disable-telnet --disable-tftp --without-ssl --without-libssh2 --without-zlib --without-brotli --without-libidn2  --without-ldap  --without-ldaps --without-rtsp --without-psl --without-librtmp --without-libpsl --without-nghttp2 --disable-shared --disable-libcurl-option
```

This will for some reason take a very long time. Then, compile libcurl with make. We now need to replace the existing libcurl headers and libs provided by MinGW:

* In the downloaded libcurl directory, go to the include directory and copy the "curl" folder to replace the one in X:\path\to\msys64\mingw64\include (make a backup if needed);
* Do the same with the file "libcurl.a" in the libs/.lib folder to replace the one in X:\path\to\msys64\mingw64\lib (make a backup if needed).

Now, you should be able to compile rieMiner with make and produce a standalone executable.

### For 32 bits computers

First, go to the file main.h and change

```
#define BITS	64
```

to

```
#define BITS	32
```

Then, follow the instructions for 64 bits systems. If you do not do this, the compilation will work, but the blocks produced will be invalid.

## Run this program

If no "rieMiner.conf" next to the executable was found, you will be assisted to configure rieMiner. Answer to its questions to start mining. If there is a "rieMiner.conf" file next to the executable with incorrect information, you can delete this to get the assisted configuration.

Alternatively, you can create or edit this "rieMiner.conf" file next to the executable, in order to provide options to the miner. The rieMiner.conf syntax is very simple: each option is given by a line such

```
Option type = Option value
```

It is case sensitive, but spaces and invalid lines are ignored. **Do not put ; at the end or use other delimiters than =** for each line, and **do not confuse rieMiner.conf with riecoin.conf**! If an option or the file is missing, the default value(s) will be used. If there are duplicate lines, the last one will be used. The available options are:

* Host : IP of the Riecoin wallet/server or pool. Default: 127.0.0.1 (your computer);
* Port : port of the Riecoin wallet/server or pool. Default: 28332 (default port for Riecoin-Qt);
* User : username used to connect in the server (rpcuser for solo mining). Includes the worker name (user.worker) if using Stratum. Default: nothing;
* Pass : password used to connect in the server (rpcpassword for solo mining). Default: nothing;
* Protocol : protocol to use: GetBlockTemplate for solo mining, Stratum for pooled mining, Benchmark for testing. Default: Benchmark;
* Address : custom payout address for solo mining (GetBlockTemplate only). Default: a donation address;
* Threads : number of threads used for mining. Default: 8;
* Sieve : size of the sieve table used for mining. Use a bigger number if you have more RAM, as you will obtain better results: this will usually reduce the ratio between the n-tuple and n+1-tuples counts. It can go up to 2^64 - 1, but setting this at more than a few billions will be too much and decrease performance. Default: 2^30;
* Tuples : for solo mining, submit not only blocks (6-tuples) but also k-tuples of at least the given length. Its use will be explained later. Default: 6;
* Refresh : refresh rate of the stats in seconds. 0 to disable them; will only notify when a k-tuple or share (k > 4) is found, or when the network finds a block. Default: 30;
* TestDiff : only for Benchmark, sets the testing difficulty (must be from 265 to 32767). Default: 1600;
* TestTime : only for Benchmark, sets the testing duration in s. 0 for no time limit. Default: 0;
* Test3t : only for Benchmark, stops testing after finding this number of 3-tuples. 0 for no limit. Default: 1000.

You can finally run the newly created rieMiner executable using

```bash
./rieMiner
```

The Riecoin community thanks you for your participation, you will be a contributor to the robustness of the Riecoin network.

### Memory problems

If you have memory errors, try to lower the Sieve value.

## Statistics

rieMiner will regularly print some stats, and the frequency of this can be changed with the Refresh parameter as said earlier. Example for solo mining:

```bash
[0024:46:09] (2/3t/s) = (7.36 0.255) ; (2-6t) = (654259 22261 793 38 2) | 1.14 d
```

These are the time since start of mining (24 h 46 min 9 s), the number of tuples found each second since the last difficulty change (7.36 2-tuples/s and 0.255 3-tuple/s), and the total of tuples found (for example, 793 4-tuples, and 2 blocks) since the start of the mining.

After finding at least a 4-tuple after a difficulty change, rieMiner will also estimate the average time to find a block (here, 1.14 days) by extrapolating from how many 2, 3 and 4-tuples were found, but of course, even if the average time to find a block is for example 2 days, you could find a block in the next hour as you could find nothing during a week.

These results were obtained with a Ryzen R7 2700X at 3.7 GHz, and you can use this reference to ensure that your miner is mining as fast as it should. Keep in mind that you should wait at least a few hours before comparing values, and the higher is the difficulty, the lower are the tuples find rates (I will add a benchmark mode in a future version). With a 2700X and at ~1600 difficulty, you can expect to get 2-3 blocks every week on average.

For pooled mining, the number of primes "non consecutive tuples" are shown instead, and there is an estimation of how much RIC/day you are earning. If you want to compare the performance with fastrie, multiply the speeds by 4.096. The performance should be the same as fastrie's, as rieMiner uses the same algorithm.

rieMiner will also notify if it found a k-tuple (k > 3) in solo mining or a share in pooled mining, and if the network found a new block. If it finds a block or a share, it will tell if the submission was accepted (solo mining only) or not. For solo mining, if the block was accepted, the reward will be generated for the address specified in the options. You can then spend it after 100 confirmations.

## Solo mining specific information

Note that other ways for solo mining (protocol proxies,...) were never tested with rieMiner. It was written specifically for the official wallet and the existing Riecoin pools.

### Configure the Riecoin wallet for solo mining

To solo mine with the official Riecoin-Qt wallet, you have to configure it.

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

If you are worried about the fact that the block will be incorrectly submitted, here comes the -k option. Indeed, you can send invalid blocks to the wallet (after all, it is yours), and check if the wallet actually received them and if these submissions are properly processed. When such invalid block is submitted, you can check the debug.log file in the same location as riecoin.conf, and then, you should see something like

```
ERROR: CheckProofOfWork() : n+10 not prime
```

Remember that the miner searches numbers n such that n, n + 2, n + 6, n + 10, n + 12 and n + 16 are prime, so if you passed, for example, 3 via the -k option, rieMiner will submit a n such that n, n + 2 and n + 6 are prime, but not necessarily the other numbers, so you can conclude that the wallet successfully decoded the submission here, and that everything works fine. If you see nothing or another error message, then something is wrong (possible example would be an unstable overclock)...

Also watch regularly if the wallet is correctly syncing, especially if the message "Blockheight = ..." did not appear since a very long time (except if the Diff is very high, in this case, it means that the network is now mining the superblock). In Riecoin-Qt, this can be done by hovering the green check at the lower right corner, and comparing the number with the latest block found in an Riecoin explorer. If something is wrong, try to change the nodes in riecoin.conf, the following always worked fine for me:

```
﻿connect=5.9.39.9
connect=37.59.143.10
connect=144.217.15.39
connect=149.14.200.26
connect=178.251.25.240
connect=193.70.33.8
connect=195.138.71.80
connect=198.251.84.221
connect=199.126.33.5
connect=217.182.76.201
```

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

rieMiner provides a way to test the performance of a computer, and compare with others. This feature can also be used to appreciate the improvements when trying to improve the miner algorithm. When sharing benchmark results, you must always communicate the difficulty, the sieve size, the test duration, the CPU model, the memory speeds (frequency and CL), the miner version, and the OS.

To compare two different platforms, you must absolutely test with the same difficulty, during enough time. The proposed parameters, conditions and interpretations for serious benchmarking are:

* Standard Benchmark
  * Difficulty of 1600;
  * Sieve of 2^30 = 1073741824;
  * Stop after finding 1000 3-tuples or more;
  * The computer must not do anything else during testing;
  * Very long for slow computers, but like the real mining conditions;
  * The precision will be 2 solid digits for the 2-tuples/s metric, and almost 2 digits for the 3-tuples/s one (the 2nd will still vary a bit). That said, you can share your result with 3 significant digits for each;
  * It would not be enough to even obtain just one solid digit for the 4-tuples/s metric, so 4, 5 and 6-tuples find rates should be discarded.

Testing a few times longer will not really improve the precision. You would need to find tens if not hundreds times more tuples to gain another significant digit for each metric, which would be really unpractical. In the other direction, if you have a slow computer or want a very fast test, you can reduce the difficulty to find tuples much faster with these parameters:

* Easy Benchmark
  * Difficulty of 800;
  * Sieve of 2^27 = 134217728;
  * Stop after finding 1000 3-tuples or more;
  * The computer must not do anything else during testing;
  * Not adapted for powerful computers;
  * The precision will be similar to Standard Benchmark, but note that the results will be completely different to the ones provided by the standard benchmark;
  * 4, 5 and 6-tuples find rates should also be discarded.

In all cases, the system must not swap. Else, the result would not make much sense. Ensure that you have enough memory when trying to benchmark.

## Miscellaneous

Unless the weather is very cold, I do not recommend to overclock a CPU for mining, unless you can do that without increasing noticeably the power consumption. My 2700X computer would draw much, much more power at 4 GHz/1.2875 V instead of 3.7 GHz/1.08125 V, which is certainly absurd for a mere 8% increase. To get maximum efficiency, you might want to find the frequency with the best performance/power consumption ratio (which could also be obtained by underclocking the processor).

If you can, try to undervolt the CPU to reduce power consumption, heat and noise.

## Author and license

* [Pttn](https://github.com/Pttn), contact: dev at Pttn dot me

Parts coming from other projects are subject to their respective licenses. Else, this work is released under the MIT license. See the [LICENSE](LICENSE) or top of source files for details.

## Contributing

Feel free to do a pull request or open an issue, and I will review it. I am open for adding new features, but I also wish to keep this project minimalist. Any useful contribution will be welcomed.

Donations welcome:

* Bitcoin: 1PttnMeD9X6imTsRojmhHa1rjudW8Bjok5
* Riecoin: RPttnMeDWkzjqqVp62SdG2ExtCor9w54EB
* Ethereum: 0x32de6b854b6a05448b4f25d4496990bece8a2862

## Resources

* [rieMiner thread on Riecoin-Community.com forum](https://forum.riecoin-community.com/viewtopic.php?f=16&t=15)
* [Get the Riecoin wallet](http://riecoin.org/download.html)
* [Fast prime cluster search - or building a fast Riecoin miner (part 1)](https://da-data.blogspot.ch/2014/03/fast-prime-cluster-search-or-building.html), nice article by dave-andersen explaining how Riecoin works and how to build an efficient miner and the algorithms. Unfortunately, he never published part 2...
* [Riecoin FAQ](http://riecoin.org/faq.html) and [technical aspects](http://riecoin.org/about.html#tech)
* [Bitcoin Wiki - Getblocktemplate](https://en.bitcoin.it/wiki/Getblocktemplate)
* [Bitcoin Wiki - Stratum](https://en.bitcoin.it/wiki/Stratum_mining_protocol)
