// speedtest script for project euler exercise 87
// can be run from cli (V8 or SpiderMonkey 45+) or browser

'use strict';

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

function mkPrimeSet(end) {
    let primes = new Set([2,3,5,7]);
    for(let i=10; i<Math.sqrt(end); i++) {
        if (isPrime(i)) {
            primes.add(i);
        }
    }
    return primes;
}

function mkPrimeArray(end) {
    let primes = [2, 3, 5, 7];
    for (let i=10; i<Math.sqrt(end); i++) {
        if (isPrime(i)) {
            primes.push(i);
        }
    }
    return primes;
}

function primeSet_itemOf_234(primeSet, end) {
    let sumSet = new Set();
    for(let item2 of primeSet) {
        let square = item2 * item2;
        for(let item3 of primeSet) {
            let cube = item3 * item3 * item3;
            for(let item4 of primeSet) {
                let sum = square + cube + item4 * item4 * item4 * item4;
                if (sum >= end) {
                    break;
                }
                sumSet.add(sum);
            }
        }
    }
    return sumSet.size;
}

function primeSet_itemOf_432(primeSet, end) {
    let sumSet = new Set();
    for(let item4 of primeSet) {
        let fourth = item4 * item4 * item4 * item4;
        for(let item3 of primeSet) {
            let cube = item3 * item3 * item3;
            for(let item2 of primeSet) {
                let sum = fourth + cube + item2 * item2;
                if (sum >= end) {
                    break;
                }
                sumSet.add(sum);
            }
        }
    }
    return sumSet.size;
}

function primeArray_index_234(primeArray, end) {
    let sumSet = new Set();
    for(let index2=0; index2 < primeArray.length; index2++) {
        let square = primeArray[index2] * primeArray[index2];
        for(let index3=0; index3 < primeArray.length; index3++) {
            let cube = primeArray[index3] * primeArray[index3] * primeArray[index3];
            for(let index4=0; index4 < primeArray.length; index4++) {
                let sum = square + cube + primeArray[index4] * primeArray[index4] * primeArray[index4] * primeArray[index4];
                if (sum >= end) {
                    break;
                }
                sumSet.add(sum);
            }
        }
    }
    return sumSet.size;
}

function primeArray_index_432(primeArray, end) {
    let sumSet = new Set();
    for(let index4=0; index4 < primeArray.length; index4++) {
        let fourth = primeArray[index4] * primeArray[index4] * primeArray[index4] * primeArray[index4];
        for(let index3=0; index3 < primeArray.length; index3++) {
            let cube = primeArray[index3] * primeArray[index3] * primeArray[index3];
            for(let index2=0; index2 < primeArray.length; index2++) {
                let sum = fourth + cube + primeArray[index2] * primeArray[index2];
                if (sum >= end) {
                    break;
                }
                sumSet.add(sum);
            }
        }
    }
    return sumSet.size;
}

function primeArray_itemOf_234(primeArray, end) {
    let sumSet = new Set();
    for(let item2 of primeArray) {
        let square = item2 * item2;
        for(let item3 of primeArray) {
            let cube = item3 * item3 * item3;
            for(let item4 of primeArray) {
                let sum = square + cube + item4 * item4 * item4 * item4;
                if (sum >= end) {
                    break;
                }
                sumSet.add(sum);
            }
        }
    }
    return sumSet.size;
}

function primeArray_itemOf_432(primeArray, end) {
    let sumSet = new Set();
    for(let item4 of primeArray) {
        let fourth = item4 * item4 * item4 * item4;
        for(let item3 of primeArray) {
            let cube = item3 * item3 * item3;
            for(let item2 of primeArray) {
                let sum = fourth + cube + item2 * item2;
                if (sum >= end) {
                    break;
                }
                sumSet.add(sum);
            }
        }
    }
    return sumSet.size;
}

function testrunFunction(fun, args, iterCount, printResult) {
    if (!Number.isInteger(iterCount) || iterCount < 1) {
        iterCount = 10;
    }
    
    if (printResult !== true) {
        printResult = false;
    }

    let totalTimeTaken = 0;
    
    for (let i = 0; i < iterCount; i++) {
        let start = Date.now(),
            funResult = fun(...args),
            end = Date.now();
        
        if (printResult) {
            console.log("Got result: "+funResult+" in "+String(end - start)+" ms");
        } else {
            console.log("Got result in "+String(end - start)+" ms");
        }
        totalTimeTaken += (end - start);
    }

    console.log("Average time after "+iterCount+" runs: "+totalTimeTaken/iterCount);
}

function benchmark() {
    const MAX = 5e7;
    const MAX_ITER = 10;

    console.log("Testing prime number generation first.");
    console.log("PrimeSet: ");
    testrunFunction(mkPrimeSet, [MAX], MAX_ITER);
    let primeSet = mkPrimeSet(MAX);
    console.log("PrimeArray:");
    testrunFunction(mkPrimeArray, [MAX], MAX_ITER);
    let primeArray = mkPrimeArray(MAX);
    console.log("Finished number generation tests, testing now different implementations.");
    console.log("PrimeSet, item of, 234:");
    testrunFunction(primeSet_itemOf_234, [primeSet, MAX], MAX_ITER, true);
    console.log("PrimeSet, item of, 432:");
    testrunFunction(primeSet_itemOf_432, [primeSet, MAX], MAX_ITER, true);
    console.log("PrimeArray, index, 234:");
    testrunFunction(primeArray_index_234, [primeArray, MAX], MAX_ITER, true);
    console.log("PrimeArray, index, 432:");
    testrunFunction(primeArray_index_432, [primeArray, MAX], MAX_ITER, true);
    console.log("PrimeArray, itemOf, 234:");
    testrunFunction(primeArray_itemOf_234, [primeArray, MAX], MAX_ITER, true);
    console.log("PrimeArray, itemOf, 432:");
    testrunFunction(primeArray_itemOf_432, [primeArray, MAX], MAX_ITER, true);
}

benchmark();
/*
undefined
*/
