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
if (Array.from) {
    // node.js
    Array.prototype.uniq = function() {
        return Array.from(new Set(this));
    };
} else {
    // Spider monkey
    Array.prototype.uniq = new Function('return [...new Set(this)];');
}

// print([1,2,3,2,1].uniq());

Array.prototype.cross = function (other, op) {
    let ret = [];
    for (let a of this) {
        for (let b of other) {
            ret.push(op(a, b));
        }
    }
    return ret;
};

// print([1, 2].cross([3, 4], (a, b) => a + b));

let primeNumbers = [2,3,5,7,11,13,17,19];
const limit = 5e7;

for (let num = primeNumbers[primeNumbers.length - 1] + 2;
     num <= Math.sqrt(limit); num += 2) {
    for (var i = Math.floor(Math.sqrt(num)); i >= 3; --i) {
        if (num % i == 0)
            break;
    }
    if (i < 3)
        primeNumbers.push(num);
}

print('There are ' + primeNumbers.length + ' prime numbers below sqrt(50.000.000)');

function pnPower(exp) {
    return primeNumbers.filter(x => x <= Math.pow(limit, 1 / exp))
    .map(x => Math.pow(x, exp));
}

// print(pnPower(4));

let answ = pnPower(2).cross(pnPower(3), (a, b) => a + b)
  .filter(x => x < limit)
  .cross(pnPower(4), (a, b) => a + b)
  .filter(x => x < limit)
  .uniq()
  .length;

print('Answer: ' + answ);
