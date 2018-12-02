#!/bin/bash

ispc primetest.ispc -o primetest.s -h primetest.h --emit-asm --target=avx2-x2
