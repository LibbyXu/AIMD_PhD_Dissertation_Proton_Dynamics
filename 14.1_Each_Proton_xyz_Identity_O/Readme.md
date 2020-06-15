# Creating Each Proton Positions and the proton-O (closest) Distance

**Here, we obtain the XYZ-coordinate positions of protons and the corresponding proton-O (closest) Distance each step along paths.** 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Grap_Each_Proton_Pos.sh`**: The data processing script for obtaining the positions of all protons the whole trajectories.

## About Outputs

**i)** **`Each_Proton_position`**: The combined XYZ-position file for proton (index, proton-bonded O index, ditance between them, identity of the proton-bonded O[1:water; 0:surface]) along paths. 

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`Final_Proton_index_corres`** from **`14_Proton_Position`**, **`XDATCAR, POSCAR`** from **`2_Split_Manually_Data_Processing`**

#### Scripts & submit files: 

**`Grap_Each_Proton_Pos.sh, Submit.run`**.

**We need to modify one parameter in** **`Submit.run`**.

```javascript
#The number of the last steps that will be needed in your data analysis
needed_step=`echo 15000` #You can modify 
```

**We also need to modify some parameters in** **`Grap_Each_Proton_Pos.sh`**.

```javascript
#Definition of variables
##Number of the protons  
total_proton_num=`echo 2` #You can modify
```

****

**Typing the command**: **`sbatch Submit.run`** 

****
