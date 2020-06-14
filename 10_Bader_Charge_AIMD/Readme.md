# Obtain Bader Charge for Different Building Blocks 

*We aim to get the bader charge for different building blocks of several different steps from the trajectories. Meanwhile, the separated and standard deviation for the bader charge value of these different building blocks will also be calculated here.* 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Submit_Jobs_1.sh`**: Since we have several folders, we need to put each **`Submit.run`** file into each folder and then perform the calculations.

**iii)** **`Bader_Diff_Blocks.sh`**: The data processing script for obtaining the bader charge for all atoms.

**i)** **`Combined_and_Calcu_Bader_2.sh`**: The data processing script for obtaining the combined/averaged bader charge value for different building blocks for the systems.

**v)** **`Support_Remove_Files_Folders.sh`**: In case that something wrong happened during calculations, this script can be used to clean all the produced results. *And make the folder content go back to the beginning.*

## About Outputs

#### Outputs created by Bader_Diff_Blocks.sh: 

**i)** **`Charge_building_block`**: Obtain the bader charge value for all atom in **`CONTCAR`**.

**ii)** **`Result_ py.log`**: Contains the bader charge info for each building block within the system.

#### Outputs created by Conbined_and_Calcu_Bader_2.sh:

###### Mainly created 4 foders:

**i)** **`Result_Python`**: All results “Charge_building_block” from each **`AIMD_bader_#`** are transferred under this folder.

**ii)** **`Bader_Final`**: the **`Final_bader_diff_blocks`** file gives the combined bader charge data from all **`Charge_building_block`** files. And the **`Average_bader_charge_blocks`** file gives the averaged value and standard deviation of the bader charge for each building block (from the data file **`Final_bader_diff_blocks`**). 

**iii)** **`First_Python & Slurm_all`**: Check files

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

The **`CONTCAR`** & the corresponding calculated **`ACF.dat`** from the **`VASP software`**. These two files should be stored under the folder named as **`AIMD_bader_#`**.

### Scripts & submit files: 

**`Bader_Diff_Blocks.sh, Submit.run, Support_Remove_Files_Folders.sh, Submit_Jobs_1.sh, Combined_and_Calcu_Bader_2.sh`**.

****

**1. Typing the command**: **`./Submit_Jobs_1.sh > LOG_1`**

We need to modify parameters in **`Bader_Diff_Blocks.sh`**.

```javascript
#Definition of variables
##Building blocks name and Num of atoms for each Building block
echo "A,B,C" > B_name_temp #Name for each building block "A,B,C", you can modify
B_num=(64,38,48) # Number of atoms in each building blcoks (corresbonding to the name of each building block), you can modify
```

****

**2. Typing the command**: **`./Combined_and_Calcu_Bader_2.sh > LOG_2`**

We also need to modify one parameter in **`Combined_and_Calcu_Bader_2.sh`**.

```javascript
#Definition of variables
##Building blocks name and Num of atoms for each Building block
echo "A,B,C" > B_name_temp #Name for each building block "A,B,C", you can modify
```

****
