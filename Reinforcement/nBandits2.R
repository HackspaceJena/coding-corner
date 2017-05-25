#####
#    nBandits: Anzahl der Arme am Banditen
#         eps: Explorationswahrscheinlichkeit
#        init: Ausgangswert für die Erwartungswerte
#       plays: Anzahl der Versuche
#
#    Simuliert das n-armige Banditenproblem mit epsilon-greedy-Strategie.
#
#    Gibt eine Liste mit der Belohnung für jedes Spiel, den Mittelwerten der
#    Normalverteilungen und den gewählten Banditen zurück.
#####
epsBandits<-function(nBandits = 10L, eps = .1, init = 0, plays) {
   # Unterschiedlicher Mittelwert für die Normalverteilungen
   bandits <- rnorm(nBandits)

   expected <- rep(init, length(bandits)) # Gespeicherter Erwartungswert
   reward <- numeric(plays)            # Ergebnisse aller Durchläufe
   picks <- numeric(plays)             # Aufzeichnung aller Aktionen
   k <- rep(0L, nBandits)              # Zähler für Aktionen
 
   # Es wird der Automat mit dem höchsten Erwartungswert gewählt
   # oder zufällig (gleichverteilt) einer der Automaten.
   # Anschließend wird der Erwartungswert für den gewählten Automaten
   # aktualisiert.
   for (i in seq_len(plays)) {
      if (runif(1) < eps) {
         pick <- sample.int(nBandits, 1)  
      } else {
         pick <- which(expected == max(expected))
         # Bei Gleichstand wird zufällig aus den Besten gewählt
         if (length(pick) > 1) {
            pick <- sample(pick, 1)
         }
      }
   
      reward[i] <- rnorm(1, mean = bandits[pick])
      expected[pick] <- expected[pick] + (reward[i] - expected[pick]) / (k[pick] + 1)
      picks[i] <- pick
      k[pick] <- k[pick] + 1
   }
   return(list(reward=reward, bandits = bandits, picks = picks))
}

#####
#    nBandits: Anzahl der Arme am Banditen
#         eps: Explorationswahrscheinlichkeit
#        init: Ausgangswert für die Erwartungswerte
#       alpha: Schrittweitenparameter zur Berechnung des Erwartungswertes
#       plays: Anzahl der Versuche
#
#    Simuliert das n-armige Banditenproblem mit epsilon-greedy-Strategie.
#    Zur Schrittweitensteuerung wird alpha statt k verwendet.
#
#    Gibt eine Liste mit der Belohnung für jedes Spiel, den Mittelwerten der
#    Normalverteilungen und den gewählten Banditen zurück.
#####
epsBanditsalpha<-function(nBandits = 10L, eps = .1, init = 0, alpha = .1, plays) {
   # Unterschiedlicher Mittelwert für die Normalverteilungen
   bandits <- rnorm(nBandits)

   expected <- rep(init, length(bandits)) # Gespeicherter Erwartungswert
   reward <- numeric(plays)            # Ergebnisse aller Durchläufe
   picks <- numeric(plays)             # Aufzeichnung aller Aktionen
 
   # Es wird der Automat mit dem höchsten Erwartungswert gewählt
   # oder zufällig (gleichverteilt) einer der Automaten.
   # Anschließend wird der Erwartungswert für den gewählten Automaten
   # aktualisiert.
   for (i in seq_len(plays)) {
      if (runif(1) < eps) {
         pick <- sample.int(nBandits, 1)  
      } else {
         pick <- which(expected == max(expected))
         # Bei Gleichstand wird zufällig aus den Besten gewählt
         if (length(pick) > 1) {
            pick <- sample(pick, 1)
         }
      }
   
      reward[i] <- rnorm(1, mean = bandits[pick])
      expected[pick] <- expected[pick] + alpha * (reward[i] - expected[pick])
      picks[i] <- pick
   }
   return(list(reward=reward, bandits = bandits, picks = picks))
}

#####
#    nBandits: Anzahl der Arme am Banditen
#         eps: Explorationswahrscheinlichkeit
#        init: Ausgangswert für die Erwartungswerte
#       alpha: Schrittweitenparameter zur Berechnung des Erwartungswertes
#        beta: Schrittweitenparameter für Prioritäten
#       plays: Anzahl der Versuche
#
#    Simuliert das n-armige Banditenproblem mit reinforcement comparison-Strategie.
#
#    Gibt eine Liste mit der Belohnung für jedes Spiel, den Mittelwerten der
#    Normalverteilungen und den gewählten Banditen zurück.
#####
rfcompBandits<-function(nBandits = 10L, init = 0, alpha = .1, beta = .1, plays) {
   # Unterschiedlicher Mittelwert für die Normalverteilungen
   bandits <- rnorm(nBandits)
   pref <- rep(0, nBandits)
   prob <- rep(1/nBandits, nBandits)

   expected <- init                    # Gespeicherter Erwartungswert
   reward <- numeric(plays)            # Ergebnisse aller Durchläufe
   picks <- numeric(plays)             # Aufzeichnung aller Aktionen
 
   # Rouletteauswahl proprotional zur jeweiligen Wahrscheinlichkeit
   for (i in seq_len(plays)) {
      pick <- which(cumsum(prob) - runif(1) >= 0)[1]
      reward[i] <- rnorm(1, mean = bandits[pick])
      picks[i] <- pick

      # Prioritäten mit Ergebnis abgleichen
      pref[pick] <- pref[pick] + beta * (reward[i] - expected)
      prob <- exp(pref) / sum(exp(pref))
      expected <- expected + alpha * (reward[i] - expected)
   }
   return(list(reward=reward, bandits = bandits, picks = picks))
}

#####
#    nBandits: Anzahl der Arme am Banditen
#         eps: Explorationswahrscheinlichkeit
#        init: Ausgangswert für die Erwartungswerte
#        beta: Schrittweitenparameter für Prioritäten
#       plays: Anzahl der Versuche
#
#    Simuliert das n-armige Banditenproblem mit pursuit-Strategie.
#
#    Gibt eine Liste mit der Belohnung für jedes Spiel, den Mittelwerten der
#    Normalverteilungen und den gewählten Banditen zurück.
#####
pursuitBandits<-function(nBandits = 10L, init = 0, beta = .01, plays) {
   # Unterschiedlicher Mittelwert für die Normalverteilungen
   bandits <- rnorm(nBandits)
   pref <- rep(0, nBandits)
   prob <- rep(1/nBandits, nBandits)

   expected <- rep(init, length(bandits)) # Gespeicherte Erwartungswerte
   reward <- numeric(plays)            # Ergebnisse aller Durchläufe
   picks <- numeric(plays)             # Aufzeichnung aller Aktionen
   k <- rep(0L, nBandits)              # Zähler für Aktionen
 
   # Rouletteauswahl proprotional zur jeweiligen Wahrscheinlichkeit
   for (i in seq_len(plays)) {
      pick <- which(cumsum(prob) - runif(1) >= 0)[1]
      reward[i] <- rnorm(1, mean = bandits[pick])
      picks[i] <- pick

      expected[pick] <- expected[pick] + (reward[i] - expected[pick]) / (k[pick] + 1)
      k[pick] <- k[pick] + 1

      pick <- which(expected == max(expected))
      if (length(pick) > 1) {
         pick <- sample(pick, 1)
      }

      # Greedy-Aktion wahrscheinlicher machen
      prob[pick] <- prob[pick] + beta * (1 - prob[pick])
      prob[-pick] <- prob[-pick] + beta * (0 - prob[-pick])
   }
   return(list(reward=reward, bandits = bandits, picks = picks))
}

# plays <- 1000
# res <- epsBandits(plays = plays, eps = .1)
# res <- epsBanditsalpha(plays = plays, eps = .1, alpha = .1)
# res <- rfcompBandits(plays = plays, alpha = .1, beta = .1)
# res <- pursuitBandits(plays = plays, beta = .01)
