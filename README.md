# Queuing Process Simulation

This project is dedicated to the simulation of a queuing line problem in a clinic with certain specifications.

## How does it work ?

**Simulation of a queuing problem** : 
A clinic has three doctors. Patients come into the clinic at random, starting at 9am, according to a Poisson process with time parameter 8 minutes. The time after opening at which the first patient appears follows an exponential
distribution with expectation 8 minutes and then, after each patient arrives, the waiting time until the next patient is independently exponentially distributed, also with expectation 8 minutes. When a patient arrives, he or she waits until a doctor is available. The amount of time spent by each doctor with each patient is a random variable, uniformly distributed between 15 and 30 minutes. The office stops admitting new patients at 4pm and closes when the last patient is through with the doctor.

In this project, we will :

- Simulate this process once and answer questions : How many patients came to the office? How many had to
wait for a doctor? What was their average wait? When did the office close?

- Simulate the process 1000 times and estimate the median and 95% confidence interval for each of the questions stated before.