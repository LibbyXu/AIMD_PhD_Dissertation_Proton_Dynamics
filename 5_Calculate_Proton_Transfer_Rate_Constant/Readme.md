# Calculating the Surface Redox Reaction Rate Constant

**We will count proton transfer time along trajectories. There are several possible transferring cases:** 

i) Proton transfer *from water to another water molecule*; 

ii) Proton transfer *from water to surface O*; 

iii) Proton transfer *from surface O to water*; 

iv) Proton transfers *from surface O to another surface O*; 

v) Proton *stays with the same water molecule*; 

vi) Proton *stays with the same surface O*. 

**The proton surface-redox reactions** involved two cases here, the **iii)** and **iv)**. Thus, we can calculate the surface redox rate constant using the following expression:

*rate constant*=(number of times for proton transfer)/(Time period×Proton concentration×Area)

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Surface_redox_rate_calcu.sh`**: Count the times of all **i), ii), iii), iv), v), vi)** proton transfer events. *Calculating the surface redox rate constant, water density.*  

## About Outputs

**i)** **`Fifth_python.log`**: Contain the calculated results.

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`Final_proton_bonded_O_reorder_list_Final`** from the folder **`4_Reordering_O_Proton_H_list`**. Containing the continuous proton-bonded O index change.

#### Scripts & submit files: 

**`Surface_redox_rate_calcu.sh, Submit.run`**.

We need to modify some parameters in **`Surface_redox_rate_calcu.sh`**.

```javascript
#####Number of the protons#####  
total_proton_num=`echo 2`  #You can modify   
  
#####time per step#####  
time_step=`echo 1`  #fs (femto second) and You can modify   

#####O indexes on Surface#####  
###If indexes have order  
Sur_O_St=`echo 30`  #You can modify   
Sur_O_En=`echo 60`  #You can modify   
interger_SO=`echo 1`  #You can modify  
###If indexes do not have an order  
#SurfaceO=(83,89,91,97,99,101,109,111,113)  #You can modify   

#####O indexes in water#####  
###If indexes have order  
Wat_O_St=`echo 70`   #You can modify   
Wat_O_En=`echo 80`   #You can modify   
interger_WO=`echo 1`  #You can modify   
###If indexes do not have an order  
#WaterO=(115,117,121,122,123,126)  #You can modify   

#####Unit-cell parameters#####  
#The a-,b-,c-lattice directions  
AxisO=(10.0,0.00,0.00)  #You can modify 
AxisT=(5.0,10.0,0.00)  #You can modify 
AxisR=(0.00,0.00,10.0)  #You can modify 
  
#####Unit-cell C-lattice constant#####  
#Without water and protons C-lattice constant  
No_water_hight=`echo 9.5`  #You can modify   
#With water and protons C-lattice constant  
With_WP_hight=`echo 12.0`  #You can modify   
```

****

**Typing the command**: **`sbatch Submit.run`** or **`./Surface_redox_rate_calcu.sh > LOG`**

****

