#!/usr/bin/js
/*
  Copyright © 2017 Jörg Sommer <joerg@alea.gnuu.de>

  License: MIT https://opensource.org/licenses/MIT
 */

'use strict';

//////
//
// Some monkey patching
//
if (typeof putstr === 'undefined')
    // in case of node.js
    var putstr = process.stdout.write.bind(process.stdout);

if (typeof print === 'undefined')
    // in case of node.js
    var print = console.log.bind(console);

//////
//
// Solution of Euler 37 https://projecteuler.net/problem=37
//
let primeNumbers = new Set([2,3,5,7,11,13,17,19]);

function nextPrimeNumAfter(number) {
    while (true) {
        number += 2;
        for (var i = Math.floor(Math.sqrt(number)); i >= 3; --i) {
            if (number % i == 0)
                break;
        }
        if (i < 3)
            return number;
    }
}

function allSubnumsArePrime(num) {
    let rightSide = num % 10;
    let leftSide = Math.floor(num / 10);
    let factor = 1;
    while (leftSide > 0) {
        if (!(primeNumbers.has(leftSide) && primeNumbers.has(rightSide)))
            return false;

        factor *= 10;
        rightSide += (leftSide % 10) * factor;
        leftSide = Math.floor(leftSide / 10);
    }

    return true;
}

let sum = 0;
let num = 19;

for (let numCnt = 0; numCnt < 11; ) {
    num = nextPrimeNumAfter(num);

    primeNumbers.add(num);

    putstr('\rChecking ' + num);
    if (allSubnumsArePrime(num)) {
        print('\r' + num + '         ');
        sum += num;
        ++numCnt;
    }
}

print('Answer: ' + sum);
