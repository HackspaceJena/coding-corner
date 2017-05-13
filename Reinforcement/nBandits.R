#####
#    nBandits: Anzahl der Arme am Banditen
#         eps: Explorationswahrscheinlichkeit
#       plays: Anzahl der Versuche
#
#    Simuliert das n-armige Banditenproblem mit epsilon-greedy-Strategie.
#    Gibt die Belohnung für jedes Spiel zurück.
#####
epsBandits<-function(nBandits = 10, eps = .1, plays) {
   # Erzeugt Zufallsfunktionen mit unterschiedlichem Mittelwert
   bandits <- rnorm(nBandits)

   tries <- list() # Speichert die Ergebnisse am jeweiligen Automaten
   expected <- rep(0, length(bandits)) # Zwischengespeicherter Erwartungswert
   reward <- numeric(plays)             # Ergebnisse aller Durchläufe
 
   for (i in seq_along(bandits)) {
      tries[i] <- list(NULL)
   }

   # Es wird der Automat mit dem höchsten Erwartungswert gewählt
   # oder zufällig (gleichverteilt) einer der Automaten.
   # Anschließend wird der Erwartungswert für den gewählten Automaten
   # aktualisiert.
   for (i in seq_len(plays)) {
      if (runif(1) < eps) {
         pick <- sample.int(nBandits, 1)  
      } else {
         pick <- which.max(expected)
      }
   
      reward[i] <- rnorm(1, mean = bandits[pick])
      tries[[pick]] <- c(tries[[pick]], reward[i])
      expected[pick] <- mean(tries[[pick]]) # Einladung zum Optimieren
   }
   return(reward)
}

#####
#    nBandits: Anzahl der Arme am Banditen
#         eps: Explorationswahrscheinlichkeit
#       plays: Anzahl der Versuche
#
#    Simuliert das n-armige Banditenproblem mit epsilon-greedy-Strategie.
#    Am Start wird jeder Arm einmal ausprobiert.
#    Gibt die Belohnung für jedes Spiel zurück.
#####
epsBanditsPlayFirst<-function(nBandits = 10, eps = .1, plays) {
   # Erzeugt Zufallsfunktionen mit unterschiedlichem Mittelwert
   bandits <- rnorm(nBandits)

   tries <- list() # Speichert die Ergebnisse am jeweiligen Automaten
   expected <- rep(0, length(bandits)) # Zwischengespeicherter Erwartungswert
   reward <- numeric(plays)             # Ergebnisse aller Durchläufe

   # Alle Automaten werden ausprobiert
   for (i in seq_along(bandits)) {
      expected[i] <- rnorm(1, mean = bandits[i])
      tries[i] <- expected[i]
      reward[i] <- expected[i]
   }

   # Es wird der Automat mit dem höchsten Erwartungswert gewählt
   # oder zufällig (gleichverteilt) einer der Automaten.
   # Anschließend wird der Erwartungswert für den gewählten Automaten
   # aktualisiert.
   for (i in seq((nBandits+1),plays)) {
      if (runif(1) < eps) {
         pick <- sample.int(nBandits, 1)  
      } else {
         pick <- which.max(expected)
      }
   
      reward[i] <- rnorm(1, mean = bandits[pick])
      tries[[pick]] <- c(tries[[pick]], reward[i])
      expected[pick] <- mean(tries[[pick]]) # Einladung zum Optimieren
   }
   return(reward)
}

#####
#    nBandits: Anzahl der Arme am Banditen
#        init: Anfänglicher Erwartungswert für alle Arme
#       plays: Anzahl der Versuche
#
#    Simuliert das n-armige Banditenproblem mit optimistischer Strategie.
#    Gibt die Belohnung für jedes Spiel zurück.
#####
optimisticBandits<-function(nBandits = 10, init = 5, plays) {
   # Erzeugt Zufallsfunktionen mit unterschiedlichem Mittelwert
   bandits <- rnorm(nBandits)

   tries <- list() # Speichert die Ergebnisse am jeweiligen Automaten
   expected <- rep(init, length(bandits)) # Zwischengespeicherter Erwartungswert
   reward <- numeric(plays)             # Ergebnisse aller Durchläufe
 
   for (i in seq_along(bandits)) {
      tries[i] <- list(init)
   }

   # Es wird der Automat mit dem höchsten Erwartungswert gewählt
   # oder zufällig (gleichverteilt) einer der Automaten.
   # Anschließend wird der Erwartungswert für den gewählten Automaten
   # aktualisiert.
   for (i in seq_len(plays)) {
      pick <- which.max(expected)
   
      reward[i] <- rnorm(1, mean = bandits[pick])
      tries[[pick]] <- c(tries[[pick]], reward[i])
      expected[pick] <- mean(tries[[pick]]) # Einladung zum Optimieren
   }
   return(reward)
}

# plays <- 1000
# reward01eps <- epsBandits(plays = plays, eps = 0.1)
# reward0eps  <- epsBanditsPlayFirst(plays = plays, eps = 0)
# rewardOpt   <- optimisticBandits(plays = plays, init = 5)
