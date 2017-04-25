library(numbers)
MAX <- 5e7
primes <- Primes(1, ceiling(sqrt(MAX)))

potfilter <- function(numbers, filter)
    numbers[numbers < filter]

sums <- sapply(
    potfilter(primes^4, MAX),
    function(x) { 
        sapply(
            potfilter(primes^3, MAX),
            function(y) { 
                sapply(primes^2, function(z) {
                    x+y+z
                })
            }
        )
    }
)

length(unique(sums[sums<MAX]))
