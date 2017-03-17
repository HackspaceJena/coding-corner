#!/usr/bin/python
# -*- coding: utf-8 -*-

from math import sqrt


primzahlen = [2]
stop = 50000000
menge = set()


# maximalwerte der einzelnen werte festlegen

max_eins = int(stop ** (1/2.))
max_zwei = int(stop ** (1/3.))
max_drei = int(stop ** (1/4.))
print "Maximalwerte:", max_eins, max_zwei, max_drei


# die primzahlen in der liste bis zu maximalwert ergänzen

for x in xrange(3, max_eins, 2):
    ende = sqrt(x)
    for i in (p for p in primzahlen[1:] if p <= ende):
        if x % i == 0:
            break
    else:
        primzahlen.append(x)


for drei in primzahlen:
    if drei > max_drei:
        break
    summand_drei = drei ** 4
    for zwei in primzahlen:
        summand_zwei = zwei ** 3
        if summand_drei + summand_zwei >= stop:
            break
        for eins in primzahlen:
            summe = summand_drei + summand_zwei + eins * eins
            if summe <= stop:
                menge.add(summe)
print "Count:", len(menge)
