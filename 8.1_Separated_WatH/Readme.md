# Creating all H(proton) positions at Interfaces Along Trajectories

**Here, we obtain the XYZ-coordinate positions of all Hydrogen and protons within interfaces for each step along paths.** 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Graping_Proton_and_H_in_Water.sh`**: The data processing script for obtaining the positions of all H and protons within interfaces the whole trajectories.

## About Outputs

**i)** **`position_H_Proton_Water_all`**: The combined XYZ-position file for all H/proton within interfaces for each steps along paths. 

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`POSCAR, XDATCAR`** from **`2_Split_Manually_Data_Processing`**.

#### Scripts & submit files: 

**`Graping_Proton_and_H_in_Water.sh, Submit.run`**.

**We need to modify one parameter in** **`Submit.run`**.

```javascript
#The number of the last steps that will be needed in your data analysis
needed_step=`echo 15000` #You can modify 
```

**We also need to modify some parameters in** **`Graping_Proton_and_H_in_Water.sh`**.

```javascript
#Definition of variables
##The O index from surface 
##If the indexes have an order
H_St=`echo 125`  #you can modify
H_En=`echo 150`  #you can modify
interger_H=`echo 1`  #you can modify
##If the index does not have an order
#WaterHP=(126,131,132,135,137,140,141,143,145)
```

****

**Typing the command**: **`sbatch Submit.run`** 

****
