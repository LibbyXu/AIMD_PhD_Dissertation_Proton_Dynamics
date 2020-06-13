# Creating all Surface-O positions at Interfaces Along Trajectories

**Here, we obtain the XYZ-coordinate positions of all Surface-O within interfaces for each step along paths.** 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Graping_SurO.sh`**: The data processing script for obtaining the positions of all H and protons within interfaces the whole trajectories.

## About Outputs

**i)** **`position_Surface_O_all`**: The combined XYZ-position file for all H/proton within interfaces for each steps along paths. 

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`POSCAR, XDATCAR`** from **`2_Split_Manually_Data_Processing`**.

#### Scripts & submit files: 

**`Graping_SurO.sh, Submit.run`**.

**We need to modify one parameter in** **`Submit.run`**.

```javascript
#The number of the last steps that will be needed in your data analysis
needed_step=`echo 15000` #You can modify 
```

**We also need to modify some parameters in** **`Graping_SurO.sh`**.

```javascript
#Definition of variables
##The surface-O index at interfaces
##If the indexes have an order
SO_St=`echo 30`  #you can modify
SO_En=`echo 65`  #you can modify
interger_SO=`echo 1`  #you can modify
##If the index does not have an order
#SurfaceO=(126,131,132,135,137,140,141,143,145)
```

****

**Typing the command**: **`sbatch Submit.run`** 

****
