#!/bin/sh

set -e

if test -d "incs" || test -d "libs" ; then
	echo "Dependencies already built, delete the incs and libs directories if you want to rebuild."
	exit
fi

deps=rieMiner0.93Deps
if test -f "${deps}.tar.gz" ; then
	echo "Dependencies already downloaded, delete the ${deps}.tar.gz file if you want to download it again."
	exit
else
	wget "https://riecoin.dev/resources/Pttn/${deps}.tar.gz"
fi

tar -xf "${deps}.tar.gz"
cd $deps
./Build.sh
mv incs ..
mv libs ..
cd ..
rm -rf $deps
