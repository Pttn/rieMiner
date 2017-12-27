# rieMiner 0.11

rieMiner is a Riecoin miner using the Getwork protocol and the latest mining algorithm, so it can be used to solo mine efficiently using the official wallet. It is adapted from gatra's cpuminer-rminerd (https://github.com/gatra/cpuminer-rminerd) and dave-andersen's fastrie (https://github.com/dave-andersen/fastrie):

* rminerd can be used to mine with the wallet but its algorithm is outdated and slow;
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

You can compile this C++ (with many C parts, though) program with g++ and make, install them if needed. Then, get if needed the following dependencies:

* Jansson
* cURL
* GMP

On a recent enough Debian or Ubuntu, you can easily install these by doing as root:

```bash
apt install g++ make libjansson-dev libcurl4-openssl-dev libgmp-dev
```

Then, just download the source files, go/cd to the directory, and do a simple make:

```bash
git clone https://github.com/Pttn/rieMiner.git
cd rieMiner
make
```

## Run this program

You can then run the newly created rieMiner executable using the following syntax:

```bash
./rieMiner <Options>
```

The available options are:

* -o : IP and port. Default: 127.0.0.1:28332;
* -u : username;
* -p : password;
* -t : number of threads. Default: 1;
* -s : size of the sieve table used for mining. Use a bigger number (but less than 2^32) if you have more RAM as you will obtain better results. Default: 2^30;
* -k : submit not only blocks (6-tuples) but also k-tuples of at least the given length. Its use will be explained later. Default: 6.

Example:

```bash
./rieMiner -o 127.0.0.1:28332 -u username -p password -t 8 -s 2000000000
```

Then, just be patient... Happy mining :D ! It is always nice to wake up to see that your miner found a block during the night :p, and you will be a direct contributor for the robustness of the Riecoin network.

## Statistics

Every 10 seconds or so, rieMiner will print some stats. Example:

```bash
[0053:23:13] (2/3t/s) = (3.52 0.120) ; (4-6t) = (677095 23024 798 24 1) ; Diff = 1687
```

This means: "53 h 23 min and 13 s passed since the start of mining. The miner found on average 3.52 2-tuples and 0.12 3-tuple each second. The next numbers are the number of total tuples found (example, 798 4-tuples, and 1 block). Currently, the Riecoin difficulty is 1687."

These results were obtained with an Intel 6700K so you can tell if something is wrong if a 8700K has lower values for example... But, you should wait at least a few hours before comparing values. With a 6700K and at ~1700 difficulty, you can expect to get 1-2 block(s) every week on average. Note too than the higher is the difficulty, the lower is the tuples find rates.

Note that these values are not comparable at all with those given by fastrie! It seems that somewhere in the past, the definition of a valid share (for pooled mining) changed, so they adapted the stats formulas to match with the old system, but now their numbers do not really mean anything (but can be used to compare different computers, as long as they use the same miner). Moreover, a share for pooled mining is valid if 4 numbers from any in the sextuplet is prime (4ch), but in rieMiner a 4-tuple is a sextuplet in which the 4 first numbers are prime, so it is harder to find.

But the performance is guaranteed to match the fastrie's, as it uses the same algorithm.

rieMiner will also notify if it found a k-tuple (k > 3) or if the network found a new block. If it finds a block, it will show the full Getwork submission and tell if it was accepted or not. If the block was accepted, the reward will be generated and sent to a new random address which is included in your wallet, and you can spend it after 100 confirmations. Don't forget to backup regularly your wallet or move your rewards as these addresses don't appear in Receiving Addresses. To keep the same address for mining with the original wallet, I think that you need to modify it.

## Work control

Unless you have a bunch of powerful processors, you have to wait some consequent time before finding a block. What if something is actually wrong and then the time the miner finally found a block, the submission fails?

First, if for some reason rieMiner disconnects from the wallet (you killed it or its computer crashed), it will detect that it has not received the Getwork data so it will just stop mining: so if it is currently mining, everything is fine.

If you are worried about the fact that the block will be incorrectly submitted, here comes the -k option. Indeed, you can send invalid blocks to the wallet (after all, it is yours), and check if the wallet actually received them and if these submissions are properly processed. When such invalid block is submitted, you can check the debug.log file in the same location as riecoin.conf, and then, you should see something like

```
ERROR: CheckProofOfWork() : n+10 not prime
```

Remember that the miner searches numbers n such that n, n + 2, n + 6, n + 10, n + 12 and n + 16 are prime, so if you passed, for example, 3 via the -k option, rieMiner will submit a n such that n, n + 2 and n + 6 are prime, but not necessarily the other numbers, so you can conclude that the wallet successfully decoded the submission here, and that everything works fine. If you see nothing or

```
ERROR: CheckProofOfWork() : not a pow
```

Then something is wrong (possible example would be an unstable overclock)...

Also watch regularly if the wallet is correctly synching, especially if the message "New block found by the network" did not appear since a very long time (except if the Diff is very high, in this case, it means that the network is now mining the superblock). In Riecoin-Qt, this can be done by hovering the green check at the lower right corner, and comparing the number with the latest block found in an Riecoin explorer. If something is wrong, try to change the nodes in riecoin.conf, the following always worked fine for me:

```
connect=5.9.39.9
connect=37.59.143.10
connect=46.105.29.136
connect=51.255.207.142
connect=217.182.76.201
```

## Author and license

* [Pttn](https://github.com/Pttn), contact: dev at PttNguyen dot net

Parts coming from other projects are subject to their respective licenses. Else, this work is released under the MIT license.
See the [LICENSE](LICENSE) or top of source files for details.

## Contributing

Feel free to do a pull request and I will review it. I am open for but not so interested in adding new features, as I wish to keep this project minimalist. But then contributions cleaning the code will be appreciated. Making the code more C++ish is welcome too (example: replace pthread by std::thread), and obviously if you find a bug.

Donations welcome:

* Bitcoin: 1EZ3g68314WFcxFVttgeqQpLe1z2Z8GL8g
* Ethereum: 0x32de6b854b6a05448b4f25d4496990bece8a2862
* Riecoin: RC2zUmBQbL4XQKsjp23LARn99qZq9a9uHC

## Resources

* [Get the Riecoin wallet](http://riecoin.org/download.html)
* [Fast prime cluster search - or building a fast Riecoin miner (part 1)](https://da-data.blogspot.ch/2014/03/fast-prime-cluster-search-or-building.html), nice article by dave-andersen explaining how Riecoin works and how to build an efficient miner and the algorithms. Unfortunately, he never published part 2...
* [Riecoin FAQ](http://riecoin.org/faq.html) and [technical aspects](http://riecoin.org/about.html#tech)
* [Bitcoin Wiki - Getwork](https://en.bitcoin.it/wiki/Getwork)
