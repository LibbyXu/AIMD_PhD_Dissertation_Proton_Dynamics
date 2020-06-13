# Creating all Water-O positions For All steps

**Here, we obtain the XYZ-coordinate positions of all interfacial Water-O for each step along paths.** 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Grap_Water_O_Position.sh`**: The data processing script for obtaining the positions of all interfacial Water-O along the whole trajectories.

## About Outputs

**i)** **`Water_O_POS_Z`**: The combined XYZ-position file for all interfacial Water-O for each step along paths. 

**ii)** **`Water_O_POS_Z_sorted`**: Sorted the Z-dir. (changing the direct coordinates to the cartesian coordinates) of the file **`Water_O_POS_Z`** for further analysis on the Water-O density along Z-direction. 

The requirement for producing this **`Water_O_POS_Z_sorted`** file is that the Z-direction of this unit-cell are perpendicular to the XY-plane.

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`final_pos_WO`** from **`9.1_RDF_Water_O`**, & **`POSCAR`** from **`2_Split_Manually_Data_Processing`**

#### Scripts & submit files: 

**`Grap_Water_O_Position.sh, Submit.run`**.

****

**Typing the command**: **`sbatch Submit.run`** 

****
