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
// Solution of Euler 87 https://projecteuler.net/problem=87 with iterators
//
function* filter(seq, fun) {
    for (let e of seq) {
        if (fun(e))
            yield e;
    }
};

// print(Array.from(filter([1,2,3,4], x => x < 3)));

function* cross(seq1, seq2_gen, op) {
    if (seq2_gen.next) {
        // convert the second sequence into an array, because we have to loop
        // over it multiple times, which isn't supported by iterators
        let orig_seq = Array.from(seq2_gen);
        seq2_gen = () => orig_seq;
    }

    for (let a of seq1)
        for (let b of seq2_gen())
            yield op(a,b);
};

// print(Array.from(cross([1, 2], function* () { yield 3; yield 4; }(), (a, b) => a + b)));

let primeNumbers;
!function() {
    var cache = [];

    primeNumbers = function*() {
        yield 2;

        let idx;
        for (idx = 0; idx < cache.length; ++idx)
            yield cache[idx];

        for (let num = cache[idx - 1] || 3; ; num += 2) {
            for (var i = Math.floor(Math.sqrt(num)); i >= 3; --i) {
                if (num % i === 0)
                    break;
            }
            if (i < 3) {
                cache[idx] = num;
                ++idx;
                yield num;
            }
        }
    };
}();

// print(Array.from(function* () { for (let x of primeNumbers()) { if (x > 50) return; yield x; } }()));

let limit = 5e7;

function* pnPower(exp) {
    for (let e of primeNumbers()) {
        let x = Math.pow(e, exp);
        if (x >= limit)
            return;
        yield x;
    }
}

// print(Array.from(pnPower(4)));

let seq = cross(pnPower(2), pnPower.bind(undefined, 3), (a, b) => a + b);
seq = filter(seq, x => x < limit);
seq = cross(seq, pnPower.bind(undefined, 4), (a, b) => a + b);
seq = filter(seq, x => x < limit);

print('Answer: ' + new Set(seq).size);
