# rieMiner 0.113

rieMiner is a Riecoin miner using the Getwork protocol and the latest mining algorithm, so it can be used to solo mine efficiently using the official wallet. It is adapted from gatra's cpuminer-rminerd (https://github.com/gatra/cpuminer-rminerd) and dave-andersen's fastrie (https://github.com/dave-andersen/fastrie):

* rminerd can be used to mine with the wallet, but its algorithm is outdated and slow;
* fastrie (also known as xptMiner) mines efficiently but only supports the Stratum and the outdated and undocumented XPT protocols. Yes, you can also use solo mining pools, but then you depend on them, and they might charge a fee or get the transactions fees for themselves. Moreover, it is more gratifying to get directly the reward in your wallet :D ;
* By combining both, rieMiner can be used to mine efficiently and easily with the wallet!

Code was also much simplified. As trade-off, I only tested it on Linux x64 and it might not compile on other systems. If you want to get this miner working in other systems or architectures, feel free to adapt yourself this project.

It does not support Stratum, but if you want to use it, just use or adapt fastrie. Though, if I receive enough interest in supporting Stratum (so this miner can do both pooled and solo mining), I will add this protocol.

This README also serves as manual for rieMiner, and assumes that you use Riecoin-Qt as wallet/server. I hope that this program will be useful for you!

## Configure the Riecoin wallet for solo mining

To mine with the official Riecoin wallet, you have to configure it.

* Find the riecoin.conf configuration file. It should be located in /home/username/.riecoin
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

## Compile this program

Note that I never tested this program in 32 bits x86 systems, but this should not be an issue, since every 32 bits only processors are too slow for mining anyway, and very few people are going to install 32 bits OSes in a 64 bits machine.

### In Debian/Ubuntu x64

You can compile this C++ program with g++ and make, install them if needed. Then, get if needed the following dependencies:

* Jansson
* cURL
* GMP

On a recent enough Debian or Ubuntu, you can easily install these by doing as root:

```bash
apt install g++ make git libjansson-dev libcurl4-openssl-dev libgmp-dev
```

Then, just download the source files, go/cd to the directory, and do a simple make:

```bash
git clone https://github.com/Pttn/rieMiner.git
cd rieMiner
make
```

For other Linux, executing equivalent commands should work.

### In Windows x64

Currently, it is possible to compile rieMiner with MSYS2, but for unknown reasons, the executable fails by throwing a bad alloc at the start of mining. This seems to be solved by decreasing the max_increments, but for now, the Windows support is very limited. Here are the compilation instructions anyway, if you are interested in.

First, you have to install [MSYS2](http://www.msys2.org/) (follow the instructions on the website), then enter in the MSYS MinGW-w64 console, and install the tools and dependencies:

```bash
pacman -S make
pacman -S git
pacman -S mingw64/mingw-w64-x86_64-gcc
pacman -S mingw64/mingw-w64-x86_64-curl
pacman -S mingw64/mingw-w64-x86_64-jansson
```

And finally compile with make.

## Run this program

First of all, open or create a file named "rieMiner.conf" next to the executable, in order to provide options to the miner. The rieMiner.conf syntax is very simple: each option is given by a line such

```
Option type = Option value
```

It is case sensitive, but spaces and invalid lines are ignored. If an option or the file is missing, the default value(s) will be used. If there are duplicate lines, the last one will be used. The available options are:

* Host : IP of the Riecoin wallet/server. Default: 127.0.0.1 (your computer);
* Port : port of the Riecoin wallet/server. Default: 28332 (default port for Riecoin-Qt);
* User : username used to connect in the server (rpcuser). Default: nothing;
* Pass : password used to connect in the server (rpcpassword). Default: nothing;
* Threads : number of threads used for mining. Default: 8;
* Sieve : size of the sieve table used for mining. Use a bigger number (but less than 2^32) if you have more RAM as you will obtain better results. Default: 2^30;
* Tuples : submit not only blocks (6-tuples) but also k-tuples of at least the given length. Its use will be explained later. Default: 6;
* Refresh : refresh rate of the stats in seconds. 0 to disable them; will only notify when a k-tuple (k > 4) is found, or when the network finds a block. Default: 10.

You can finally run the newly created rieMiner executable using

```bash
./rieMiner
```

Then, just be patient... Happy mining :D ! It is always nice to wake up to see that your miner found a block during the night :p, and you will be a direct contributor for the robustness of the Riecoin network.

## Statistics

rieMiner will regularly print some stats, and the frequency of this can be changed with the -r argument. Example:

```bash
[0024:46:09] (2/3t/s) = (7.36 0.255) ; (2-6t) = (654259 22261 793 38 2) | 1.14 d
```

This means: "24 h 46 min and 9 s passed since the start of mining. The miner found on average 7.36 2-tuples and 0.255 3-tuples each second since the last difficulty change. Then the total of tuples found (example, 793 4-tuples, and 2 blocks) since the start of the mining.

After finding at least a 4-tuples after a difficulty change, rieMiner will also estimate the average time to find a block (here, 1.14 days) by extrapolating from how many 2, 3 and 4-tuples were found, but of course, even if the average time to find a block is for example 2 days, you could find a block in the next hour as you could find nothing during a week.

These results were obtained with a Ryzen R7 2700X at 3.7 GHz, and you can use this reference to ensure that your miner is mining as fast as it should. Keep in mind that you should wait at least a few hours before comparing values, and the higher is the difficulty, the lower are the tuples find rates (I will add a benchmark mode in a future version). With a 2700X and at ~1600 difficulty, you can expect to get 2-3 blocks every week on average.

Note that these values are not comparable at all with those given by fastrie! It seems that somewhere in the past, the definition of a valid share (for pooled mining) changed, so they adapted the stats formulas to match with the old system, but now their numbers do not really mean anything (but can be used to compare different computers, as long as they use the same miner). Moreover, a share for pooled mining is valid if 4 numbers from any in the sextuplet is prime (4ch), but in rieMiner a 4-tuple is a sextuplet in which the 4 first numbers are prime, so it is harder to find.

But the performance should match the fastrie's, as it uses the same algorithm.

rieMiner will also notify if it found a k-tuple (k > 3) or if the network found a new block. If it finds a block, it will show the full Getwork submission and tell if it was accepted or not. If the block was accepted, the reward will be generated and sent to a new random address which is included in your wallet, and you can spend it after 100 confirmations. Don't forget to backup regularly your wallet or move your rewards as these addresses don't appear in Receiving Addresses. To set an address for mining, the GetBlockTemplate protocol would have to be added in the miner, which I could do if I had enough time.

## Work control

You might have to wait some consequent time before finding a block. What if something is actually wrong and then the time the miner finally found a block, the submission fails?

First, if for some reason rieMiner disconnects from the wallet (you killed it or its computer crashed), it will detect that it has not received the Getwork data and then just stop mining: so if it is currently mining, everything is fine.

If you are worried about the fact that the block will be incorrectly submitted, here comes the -k option. Indeed, you can send invalid blocks to the wallet (after all, it is yours), and check if the wallet actually received them and if these submissions are properly processed. When such invalid block is submitted, you can check the debug.log file in the same location as riecoin.conf, and then, you should see something like

```
ERROR: CheckProofOfWork() : n+10 not prime
```

Remember that the miner searches numbers n such that n, n + 2, n + 6, n + 10, n + 12 and n + 16 are prime, so if you passed, for example, 3 via the -k option, rieMiner will submit a n such that n, n + 2 and n + 6 are prime, but not necessarily the other numbers, so you can conclude that the wallet successfully decoded the submission here, and that everything works fine. If you see nothing or

```
ERROR: CheckProofOfWork() : not a pow
```

Then something is wrong (possible example would be an unstable overclock)...

Also watch regularly if the wallet is correctly synching, especially if the message "Blockheight = ..." did not appear since a very long time (except if the Diff is very high, in this case, it means that the network is now mining the superblock). In Riecoin-Qt, this can be done by hovering the green check at the lower right corner, and comparing the number with the latest block found in an Riecoin explorer. If something is wrong, try to change the nodes in riecoin.conf, the following always worked fine for me:

```
﻿connect=5.9.39.9
connect=37.59.143.10
connect=46.105.29.136
connect=144.217.15.39
connect=149.14.200.26
connect=178.251.25.240
connect=193.70.33.8
connect=195.138.71.80
connect=198.251.84.221
connect=199.126.33.5
connect=217.182.76.201
```

## Miscellaneous

Unless the weather is very cold, I do not recommend to overclock a CPU for mining, unless you can do that without increasing noticeably the power consumption. My 2700X computer would draw much, much more power at 4 GHz/1.2875 V instead of 3.7 GHz/1.08125 V, which is certainly absurd for a mere 8% increase. To get maximum efficiency, you might want to find the frequency with the best performance/power consumption ratio (which could also be obtained by underclocking the processor).

If you can, try to undervolt the CPU to reduce power consumption, heat and noise. Note that the Riecoin miner is not really a good stress test, as I was able to mine for weeks with rieMiner, but launching Prime 95 crashed the system within seconds! I wonder if the miner code is somewhat unoptimized, as it is not stressing as much as Prime 95.

## Author and license

* [Pttn](https://github.com/Pttn), contact: dev at Pttn dot me

Parts coming from other projects are subject to their respective licenses. Else, this work is released under the MIT license. See the [LICENSE](LICENSE) or top of source files for details.

## Contributing

Feel free to do a pull request and I will review it. I am open for adding new features, but I also wish to keep this project minimalist. Any useful contribution will be welcomed.

Donations welcome:

* Bitcoin: 1PttnMeD9X6imTsRojmhHa1rjudW8Bjok5
* Riecoin: RPttnMeDWkzjqqVp62SdG2ExtCor9w54EB
* Ethereum: 0x32de6b854b6a05448b4f25d4496990bece8a2862

## Resources

* [Get the Riecoin wallet](http://riecoin.org/download.html)
* [Fast prime cluster search - or building a fast Riecoin miner (part 1)](https://da-data.blogspot.ch/2014/03/fast-prime-cluster-search-or-building.html), nice article by dave-andersen explaining how Riecoin works and how to build an efficient miner and the algorithms. Unfortunately, he never published part 2...
* [Riecoin FAQ](http://riecoin.org/faq.html) and [technical aspects](http://riecoin.org/about.html#tech)
* [Bitcoin Wiki - Getwork](https://en.bitcoin.it/wiki/Getwork)
