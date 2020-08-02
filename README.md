# genetic-algorithm-pratice

<!-- ABOUT THE PROJECT -->
## About The Project
This is a program use Genetic-algorithm to search the global solutions of mathematical case.

## Formula
<!-- PROJECT LOGO -->
<br />
<p align="center">
<img src="images/formula.png" alt="Logo" width="659" height="87"> 
</p>
<br/>

## Parameters
```sh
Crossover rate = 0.9
Mutation rate = 0.1
# Penalty: 
C = 0.8
t = 100
α = β = 0.5 
```

* the composition of chromosomes
```sh
Chromosomes x: 10 bits
Chromosomes y: 12 bits
```

* Number of chromosomes and number of generations
```sh
populationSize = 100
generation = 100
```

* Mechanisms of selection, crossover and mutation
1. Selection: roulette wheel,
2. Crossover: one-point crossover
3. Mutation: one-bit mutation
4. Penalty: Dynamic Penalty

## Prerequisites
* lua
Download Lua For Windows installer from [GitHub](http://github.com/rjpcomputing/luaforwindows/releases)

## Installation

1. Clone the repo 
```sh
git clone https://github.com/EasternGD/genetic-algorithm-pratice
```
2. Generate the result 
```sh
lua main.lua
```
<!-- CONTACT -->

## Result
The optimal solution x: 3.575 y: 0.991 fitness: 0.999
<br />
<p align="center">
<img src="images/result_chart.png"> 
</p>
<br/>

## Contact

Abbey, Chen - encoref9241@gmail.com

Project Link: [https://github.com/EasternGD/genetic-algorithm-pratice](https://github.com/EasternGD/genetic-algorithm-pratice)
