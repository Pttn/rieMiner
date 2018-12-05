#!/bin/bash

ispc primetest.ispc -o primetest.s -h primetest.h --emit-asm --target=avx2-x2
ispc primetest.ispc -o primetest512.s -h primetest512.h --emit-asm --target=avx512knl-i32x16
sed -i 's/fermat_test/fermat_test512/g' primetest512.s primetest512.h
sed -i 's/ {z}/{z}/g' primetest512.s
