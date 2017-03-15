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
// Solution of Euler 87 https://projecteuler.net/problem=87
//
let primeNumbers = [2,3,5,7,11,13,17,19];

for (let num = primeNumbers[primeNumbers.length - 1] + 2;
     num <= Math.sqrt(5e7); num += 2) {
    for (var i = Math.floor(Math.sqrt(num)); i >= 3; --i) {
        if (num % i == 0)
            break;
    }
    if (i < 3)
        primeNumbers.push(num);
}

print('There are ' + primeNumbers.length + ' prime numbers below sqrt(50.000.000)');

let nums = new Set();

for (let idx2 = 0; idx2 < primeNumbers.length; ++idx2) {
    let pow2 = Math.pow(primeNumbers[idx2], 2);

    for (let idx3 = 0; idx3 < primeNumbers.length; ++idx3) {
        let pow3 = Math.pow(primeNumbers[idx3], 3);

        let sum = pow2 + pow3;
        if (sum >= 5e7)
            break;

        for (let idx4 = 0; idx4 < primeNumbers.length; ++idx4) {
            let pow4 = Math.pow(primeNumbers[idx4], 4);

            let sum2 = sum + pow4;
            if (sum2 >= 5e7)
                break;

            nums.add(sum2);
        }
    }
}

print('Answer: ' + nums.size);
