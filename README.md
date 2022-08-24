# Heston-Model-Hardware-Acceleration
### Description
This is a project for undergraduate research program at National Taiwan University, advised by Prof. Yi-Chang Lu.  
This work implements a hardware accelerator for option pricing using Heston model and Monte Carlo simulation.  
  
The Heston model, named after Steven L. Heston, is a mathematical model that use random process to describe the evolution of the volatility of an underlying asset. 
<p align="center">
  <img src="./image/Heston_model.PNG" width=60%/>
</p>
Note that in the above equations, the two W variables are Wiener processes (i.e., continuous random walks) with correlation not necessary 0.  
For more information, please refer to "A Closed-Form Solution for Options with Stochastic Volatility with Applications to Bond and Currency Options" by Steven L. Heston.  
<br />
<br />
Monte Carlo simulation is a method that rely on repeated independent random sampling to obtain numerical results. Generally, it is preferable to use MC simulation for random process equations due to the long latency to obtain an exact solution.  
<br />
<br />
Below is a simple demo of Heston model Monte Carlo simulation for a asset that starts with a price of 100.  
After 10000 different random process/path samples that end at day 365, we can collect the 10000 different results and compute the appropriate 1 year option price for this asset. 
<p align="center">
  <img src="./image/HestonMC2.gif" alt="animated" width=60%/>
</p>
