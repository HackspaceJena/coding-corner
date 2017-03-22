#!/usr/bin/ruby -W
# coding: utf-8
#
#  Copyright © 2017 Jörg Sommer <joerg@alea.gnuu.de>
#
#  License: MIT https://opensource.org/licenses/MIT

######
##
## Solution of Euler 87 https://projecteuler.net/problem=87
##
require 'prime'

LIMIT = 50_000_000

primesPower2 = Prime.each(Math.sqrt(LIMIT)).map { |e| e ** 2 }
primesPower3 = Prime.each(Math.cbrt(LIMIT)).map { |e| e ** 3 }
primesPower4 = Prime.each(LIMIT ** (1.0/4)).map { |e| e ** 4 }

ans = primesPower2.product(primesPower3) \
    .map { |a, b| a + b } \
    .select { |e| e < LIMIT } \
    .product(primesPower4) \
    .map { |a, b| a + b } \
    .select { |e| e < LIMIT } \
    .uniq \
    .size

puts 'Answer: ' + ans.to_s
