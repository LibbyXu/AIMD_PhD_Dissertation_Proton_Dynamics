# Creating Proton-bonded O Trajectory

**We obtain the XYZ-coordinate positions of protons each step along paths.** 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Grap_Proton_Binded_O_Traj.sh`**: The data processing script.

## About Outputs

**i)** **`Each_Proton_binded_O_position`**: The combined XYZ-position file for proton-bonded O. 

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`Final_Proton_index_corres`** from **`14_Proton_Position`**, **`XDATCAR, POSCAR`** from **`2_Split_Manually_Data_Processing`**.

#### Scripts & submit files: 

**`Grap_Proton_Binded_O_Traj.sh, Submit.run`**.

**We need to modify one parameters in** **`Submit.run`**.

```javascript
#The number of the last steps that will be needed in your data analysis
needed_step=`echo 15000` #You can modify 
```

**We also need to modify some parameters in** **`Grap_Proton_Binded_O_Traj.sh`**.

```javascript
#Definition of variables
##Number of the protons  
total_proton_num=`echo 2` #You can modify
```

****

**Typing the command**: **`sbatch Submit.run`** 

****
