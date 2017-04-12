#!/usr/bin/php
<?php
define("MAX", 5*(10**7));

$nextPrime = 2;
$primes = array($nextPrime);
while ($nextPrime < sqrt(MAX)) {
    $nextPrime = gmp_intval(gmp_nextprime($nextPrime));
    $primes[] = $nextPrime;
}

$sums = array();
$primeCount = count($primes);
for($outer = 0; $outer < $primeCount; $outer++) {
    $fourth = $primes[$outer] ** 4;
    if ($fourth >= MAX) {
        break;
    }
    
    for($middle = 0; $middle < $primeCount; $middle++) {
        $cube = $fourth + $primes[$middle] ** 3;
        if ($cube >= MAX) {
            break;
        }

        for($inner = 0; $inner < $primeCount; $inner++) {
            $sum = $cube + $primes[$inner] ** 2;
            if ($sum >= MAX) {
                break;
            }
            $sums[] = $sum;
        }
    }
}

echo "Found ".count(array_unique($sums))." numbers\n";
