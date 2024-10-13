#!/bin/sh

set -e

deps=rieMiner0.94Deps
if test -f "${deps}.tar.gz" || test -d "${deps}" ; then
	echo "Dependencies already downloaded, delete the ${deps}.tar.gz archive and ${deps} folder if you want to download it again."
	exit
else
	wget "https://riecoin.xyz/rieMiner/Download/${deps}.tar.gz"
fi

tar -xf "${deps}.tar.gz"
