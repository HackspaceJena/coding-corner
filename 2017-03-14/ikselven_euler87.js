#!/usr/bin/js

function isPrime(num) {
    if (num === 3) {
        return true;
    }
    
    if (num % 2 === 0) {
        return false;
    }

    for (let i = 3; i <= Math.sqrt(num); i++) {
        if (num % i === 0) {
            return false;
        }
    }
    return true;
}

const MAX = 5e7;
let primes = [2, 3, 5, 7];

for(let i=10; i<Math.sqrt(MAX); i++) {
    if (isPrime(i)) {
        primes.push(i);
    }
}

print("found "+primes.length+" prime numbers");

let sumSet = new Set();
for(let index4=0; index4 < primes.length; index4++) {
    let fourth = primes[index4] * primes[index4] * primes[index4] * primes[index4];
    if (fourth > MAX) {
        break;
    }

    for(let index3=0; index3 < primes.length; index3++) {
        let cube = fourth + primes[index3] * primes[index3] * primes[index3];
        if (cube > MAX) {
            break;
        }

        for(let index2=0; index2 < primes.length; index2++) {
            let sum = cube + primes[index2] * primes[index2];
            if (sum >= MAX) {
                break;
            }
            sumSet.add(sum);
        }
    }
}

print("found "+sumSet.size+" numbers");
