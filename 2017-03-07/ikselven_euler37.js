#!/usr/bin/js24

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

function findNextPrime(num) {
    while(!isPrime(++num)) {
    }
    return num;
}

function rightTruncatable(num, pset) {
    while (num > 9) {
        num = Math.floor(num/10);
        if (!pset.has(num)){
            return false;
        }
    }
    return true;
}

function leftTruncatable(num, pset) {
    while (num > 9) {
        exp = Math.pow(10, Math.floor(Math.log(num) / Math.log(10)));
        num -= Math.floor(num / exp) * exp;
        if (!pset.has(num)) {
            return false;
        }
    }
    return true;
}

let num = 7;
let pset = new Set([2,3,5,7]);
let tset = new Set();

while(tset.size < 11) {
    num = findNextPrime(num);
    putstr('\rChecking '+num);
    pset.add(num);
    if (rightTruncatable(num, pset) && leftTruncatable(num, pset)) {
        tset.add(num);
        print('\r'+num+'            ');
    }
}

print("Found 11 numbers, summing up.");

let sum = 0;
for (let number of tset) {
    print(number);
    sum += number;
}

print(sum);
