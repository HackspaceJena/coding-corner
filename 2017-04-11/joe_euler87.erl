-module(joe_euler87).
-export([go/0]).

go() ->
    Max = 50000000,
    Primes = sieve(Max),
    Sums = find_pow234(Max, Primes),
    length(Sums).

%%% find all solutions for X^2+Y^3+Z^4 smaller Max
find_pow234(Max, Primes) ->
    XPrimes = lists:takewhile(fun(P) -> pow2(P) < Max end, Primes),
    YPrimes = lists:takewhile(fun(P) -> pow3(P) < Max end, Primes),
    ZPrimes = lists:takewhile(fun(P) -> pow4(P) < Max end, Primes),
    lists:usort(lists:filter(
                  fun(Num) -> Num < Max end,
                  [powsum234(A, B, C) || A<-XPrimes, B<-YPrimes, C<-ZPrimes])).

%%% generate a list of all primes smaller Max
sieve(Max) ->
    Until = trunc(math:sqrt(Max)),
    sieve([], 2, 3, Until).

sieve(Primes, LastPrime, N, Until) when (N > Until) ->
    lists:append(Primes, [LastPrime]);
sieve(Primes, LastPrime, N, Until) ->
    case lists:all(fun(P) -> (N rem P)=/=0 end, Primes) of
        true  -> sieve(lists:append(Primes, [LastPrime]), N, N+2, Until);
        false -> sieve(Primes, LastPrime, N+2, Until)
    end.

%%% helper functions
powsum234(X, Y, Z) -> pow2(X) + pow3(Y) + pow4(Z).
pow2(X) -> X*X.
pow3(X) -> X*X*X.
pow4(X) -> X*X*X*X.
