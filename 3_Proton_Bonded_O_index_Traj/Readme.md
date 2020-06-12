# Proton Bonded O Index Trajectory

**Labeled O may either be the case that as the O in the hydronium ion (H<sub>3</sub>O<sup>+</sup>) within the water layer or the O binding with the surface O from electrode materials (interfaces) to from the hydroxyl group (-OH).** 

From the following codes, you will obtain the *_proton bonded O paths_* (the index of the proton at each step along trajectories) as well as its surrounding H-atom positions–three H atoms for the hydronium ion (H<sub>3</sub>O<sup>+</sup>) and only one H atom when it from the hydroxyl group (-OH) on interfacial surfaces.

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Submit_all_Jobs_1`**: Since we have several folders, we need to put each `Submit.run` file into each folder and then perform the calculations.

**iii)** **`Pro_O_coores_H.sh`**: The main script used to process the high-volume data analysis & produce the final results.

**iv)** **`Emergency_Remove.sh`**: In case that something wrong happened during calculations, this script can be used to clean all the produced results. *And make the folder content go back to the beginning.*

**v)** **`Combin_all_Pro_O_files_2.sh`**: Used to check the results & produce the final combined data files. 

## About Outputs

#### Outputs created by Pro_O_coores_H.sh:

**i)** **`First_python.log, Second_python.log, & Third_python.log`** are the check files for the three python files within **`Pro_O_coores_H.sh`**.

**ii)** **`Proton_bonded_O_H_list & with_Proton_bonded_Oid_H_list`** are the produced data file. The format for each file has been clarified in **`Pro_O_coores_H.sh`**.

#### Outputs created by Combin_all_Pro_O_files_2.sh:

###### Mainly created 6 foders: 

**i)** **`First_python, Second_python, Third_python, Slurm_all`**---Data & calculation checking.

**ii)** **`Final_Combined_H_list, Final_Combined_reduced_H_list`**---Combined final result data.

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

Copy all **`File_XDATCAR_`** folder from **`2_Split_Manually_Data_Processing`** to the current folder. So here, we only need **`POSCAR & XDATCAR`**.

****

### Scripts & submit files for the First-step calculations: 

**`Pro_O_coores_H.sh, Submit.run, Submit_all_Jobs_1.sh`**

For the **`Pro_O_coores_H.sh`**, you need to modify several parameters.

```javascript
#####Number of the protons#####  
total_proton_num=`echo 2` #You can modify

#####O indexes on Surface#####  
###If indexes have order  
SO_St=`echo 33` #You can modify 
SO_En=`echo 64` #You can modify 
interger_SO=`echo 1` #You can modify
###If indexes do not have an order  
#SurfaceO=(83,89,91,97,99,101,109,111,113)  #You can modify

#####O indexes in water#####  
###If indexes have order  
Wat_O_St=`echo 65`   #You can modify   
Wat_O_En=`echo 76`   #You can modify   
interger_WO=`echo 1`  #You can modify
###If indexes do not have an order  
#WaterO=(115,117,121,122,123,126)  #You can modify  

#####Initial index of Hydrogen (H)#####  
First_H_index=`echo 125`  #You can modify     
#####Total steps along trajectory (XDATCAR)#####  
num_XDATCAR=`echo 15000`  #You can modify   
```

****

**1. Typing the command**: **`./Submit_all_Jobs_1.sh > LOG_1`**

****

### Scripts & submit files for the Second-step data combination: 

**`Combin_all_Pro_O_files_2.sh`**

****

**2. Typing the command**: **`./Combin_all_Pro_O_files_2.sh > LOG_2`**

****

#### Important Notes:

**i)** You need to give the Right Path to the current folder for the following files:

**`Submit_all_Jobs_1.sh, Emergency_Remove.sh`**

**ii)** If you want to remove the previous or the wrong (produced) calculations, please use the following command: **`./Emergency_Remove.sh`**

****




