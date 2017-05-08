#!/usr/bin/Rscript

# Falls das Paket numbers nicht installiert ist:
# 1. R_LIBS=$PWD/r-libs R -e "install.packages('numbers', dependencies=TRUE, repos='http://cran.r-project.org')"
# 2. R_LIBS=$PWD/r-libs ./pikatech_euler87.R
library(numbers)

####
#    limit: Obere Grenze für die Summe der Primzahltripel
#
#    Gibt die Anzahl der einmaligen Primzahltripel
#    bis zu einer oberen Grenze zurück.
####
euler87 <- function(limit) {
   primes <- Primes(1, ceiling(limit^(1/2)))

   x2 <- primes^2
   x3 <- primes^3
   x4 <- primes^4
   x2 <- x2[x2 < limit]
   x3 <- x3[x3 < limit]
   x4 <- x4[x4 < limit]

   x <- expand.grid(x2, x3, x4)
   xSums <- rowSums(x)
   length(unique(xSums[xSums < limit]))
}

system.time(print(euler87(5e7)))
