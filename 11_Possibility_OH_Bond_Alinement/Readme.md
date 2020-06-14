# Obtain Water OH Orientations & Dipole Moment Orientations for All Water Molecules

We need to know the water dipole moment directions, the OH orientations from water molecules. All the orientations are with respect to the -Z directions. Here, we try to examine the distributions of the orientations (degree). This will help to check the water configurations with respect to the variations of the external environmental conditions.

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Submit_Jobs_1.sh`**: Since we have several folders, we need to put each `Submit.run` file into each folder and then perform the calculations.

**iii)** **`Possibility_OH_Degree.sh`**: The data processing script for obtaining H positions (XYZ-coordinates) and the corresponding distance towards the related water-O.

**iv)** **`Combined_Traj.sh`**: The data processing script for obtaining the combined results for the produced results from **iii)**.

## About Outputs

#### Outputs created by Possibility_OH_Degree.sh: 

**i)** **`final_WO_position`**: Index, atom_index, distance, position X, position Y, position Z (Every group contains 6 columns). *The first 6 columns are for the Water-O, and then is the closest surrounding Hs.*

#### Outputs created by Combined_Traj.sh:

**i)** **`Final_Conbined_OH_Degree_Results`** folder: Contains the combined results for all **`final_WO_position`** outputs, the final combined file named as **`Final_Total_OH_Degree_Results`**.

**ii)** **`Slurm_ALL`** folder: Contain the check files.

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

Copy all **`File_XDATCAR_#`** folders from **`2_Split_Manually_Data_Processing`**. Make sure, in each folder, we have **`XDATCAR & POSCAR`** file.

### Scripts & submit files: 

**`Possibility_OH_Degree.sh, Submit.run, Submit_Jobs_1.sh, Combined_Traj.sh`**.

****

**1. Typing the command**: **`./Submit_Jobs_1.sh > LOG_1`**

We need to modify parameters in **`Possibility_OH_Degree.sh`**.

```javascript
#Definition of variables
##Number of the protons
total_proton_num=`echo 2` #You can modify 

##The O index from Water 
##If the indexes have an order
WO_St=`echo 65`  #you can modify
WO_En=`echo 76`  #you can modify
interger_WO=`echo 1`  #you can modify
##If the index does not have an order
#WaterO=(65,68,71,72,74)

##Initial index of Hydrogen (H)
First_H_index=`echo 125`  #You can modify
#The number of steps included in the current XDATCAR file
num_XDATCAR=`echo 500`  #You can modify
```

****

**2. Typing the command**: **`./Combined_Traj.sh > LOG_2`**

****

## Notes:

**Please go to the folder **`Separate_1`** to continue the calculations.**
