# Heston-Model-Hardware-Acceleration

## Description
This is a project for undergraduate research program at National Taiwan University, advised by Prof. Yi-Chang Lu.  
This work implements a hardware accelerator for option pricing using Heston model and Monte Carlo simulation.  
  
The Heston model, named after Steven L. Heston, is a mathematical model that use random process to describe the evolution of the volatility of an underlying asset. 
<p align="center">
  <img src="./image/Heston_model.PNG" width=60%/>
</p>
Note that in the above equations, the two W variables are Wiener processes (i.e., continuous random walks) with arbitrary correlation.  
For more information about the model, please refer to "A Closed-Form Solution for Options with Stochastic Volatility with Applications to Bond and Currency Options", by Steven L. Heston.  
<br />
<br />
Monte Carlo simulation is a method that rely on repeated independent random sampling to obtain numerical results. Generally, it is preferable to use MC simulation for random process equations due to the long latency to obtain an exact solution.  
<br />
<br />
Below is a simple demo of Heston model Monte Carlo simulation for a asset that starts with a price of 100.  
After going through 10000 different random process/path samples that end at day 365, we can collect the 10000 different results and compute the appropriate 1 year option price for this asset. 
<p align="center">
  <img src="./image/HestonMC2.gif" alt="animated" width=40%/>
</p>

## Hardware Design

## Simulation
To test the quality of the U(0, 1) RNG, run the testbench to get the random samples written into U01.txt.  
```
$ ncverilog U01_tb.v U12.v U01.v -y /usr/cad/synopsys/synthesis/cur/dw/sim_ver/ +libext+.v +notimingchecks +access+r
```
Note the -y path is to specify the directory of required designware module.  
Then use the code written in the ipython notebook to see the mean, variance of the distribution and a comparison to ideal U(0, 1).
<p align="center">
  <img src="./image/Uniform(0,1).PNG" width=40%/>
  <img src="./image/U(0,1)_diff.PNG" width=40%/>
</p>

To test the quality of the Gaussian RNG, first copy the required file for designware module.  
```
$ cp /usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_sqrt_function.inc DW_sqrt_function.inc
```
Then run the testbench to get the random samples written into GRNG1.txt.  
```
$ ncverilog Id_Gaussian_tb.v U12.v U01.v Id_Gaussian.v -y /usr/cad/synopsys/synthesis/cur/dw/sim_ver/ +libext+.v +notimingchecks +access+r
```
Manually modify the Id_Gaussian_tb.v and run the above command again to get GRNG2.txt.  
Use the code written in the ipython notebook to see the mean, variance, correlation, and a display of the distribution.
<p align="center">
  <img src="./image/Gaussian.PNG" width=40%/>
</p>

To test the quality of the correlation module, run and modify the Correlator_tb.v to get the random samples written into Corr1.txt and Corr2.txt.  
```
$ ncverilog Correlator_tb.v U12.v U01.v Id_Gaussian.v Correlator.v -y /usr/cad/synopsys/synthesis/cur/dw/sim_ver/ +libext+.v +notimingchecks +access+r
``` 
Then use the code written in the ipython notebook to see the mean, variance, correlation, and a display of the distribution.
<p align="center">
  <img src="./image/Correlated.PNG" width=40%/>
</p>

## Schematic View
<p align="center">
  <img src="./image/double_core_schematic.PNG" width=40%/>
</p>

## Layout
clock tree
<p align="center">
  <img src="./image/double_core_clock.PNG" width=40%/>
</p>
chip
<p align="center">
  <img src="./image/double_core_APR.PNG" width=40%/>
</p>
area
<p align="center">
  <img src="./image/double_core_area.PNG" width=40%/>
</p>

## Author
Contributors names and contact info

Hao-Wei, Liang (b07502022@ntu.edu.tw)

If you have any question, please contact me with the email address above.
