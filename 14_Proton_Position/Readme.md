# Creating Proton Positions Along Trajectories

**Here, we obtain the XYZ-coordinate positions of protons within interfaces for each step along paths.** 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Grap_Proton_Position.sh`**: The data processing script for obtaining the positions of all protons within interfaces the whole trajectories.

## About Outputs

**i)** **`Final_Proton_position`**: The combined XYZ-position file for proton (index, proton-bonded O index) along paths. 

**ii)** **`Final_Proton_index_corres`**: The distance between the proton and proton-bonded O.

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`XDATCAR, POSCAR`** from **`2_Split_Manually_Data_Processing`**, **`Final_proton_bonded_O_reorder_list_Final, Final_proton_bonded_O_nearest_three_H_list_Final`** from **`4_Reordering_O_H_List`**

#### Scripts & submit files: 

**`Grap_Proton_Position.sh, Submit.run`**.

**We need to modify one parameter in** **`Submit.run`**.

```javascript
#The number of the last steps that will be needed in your data analysis
needed_step=`echo 15000` #You can modify 
```

**We also need to modify some parameters in** **`Grap_Proton_Position.sh`**.

```javascript
#Definition of variables
##Number of the protons  
total_proton_num=`echo 2` #You can modify
```

****

**Typing the command**: **`sbatch Submit.run`** 

****
