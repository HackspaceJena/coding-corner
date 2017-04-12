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
foreach($primes as $outer) {
    $fourth = $outer ** 4;
    if ($fourth >= MAX) {
        break;
    }
    
    foreach($primes as $middle) {
        $cube = $fourth + $middle ** 3;
        if ($cube >= MAX) {
            break;
        }

        foreach($primes as $inner) {
            $sum = $cube + $inner ** 2;
            if ($sum >= MAX) {
                break;
            }
            $sums[] = $sum;
        }
    }
}

echo "Found ".count(array_unique($sums))." numbers\n";
