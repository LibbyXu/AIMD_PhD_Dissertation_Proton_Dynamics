# Creating Each Proton Index Trajectory

**We obtain the continueous index change along the trajectory of the proton.** 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Obtain_Each_Proton_Traj.sh`**: The data processing script.

## About Outputs

**i)** **`final_SO_WO_index_all_traj`**: The continuous index change of the protons for each step. 

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`Final_proton_bonded_O_reorder_list_Final`** from **`4_Reordering_O_H_List`**.

#### Scripts & submit files: 

**`Obtain_Each_Proton_Traj.sh, Submit.run`**.

**We need to modify some parameters in** **`Obtain_Each_Proton_Traj.sh`**.

```javascript
#Definition of variables
#Number of the protons within system
total_proton_num=`echo 2`  #you can modify

#Definition of variables
##The O index from surface 
##If the indexes have an order
SO_St=`echo 33`  #you can modify
SO_En=`echo 64`  #you can modify
interger_SO=`echo 1`  #you can modify
##If the index does not have an order
#SurfaceO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)

##Water-O index from interfaces 
##If the indexes have an order
WO_St=`echo 65`  #you can modify
WO_En=`echo 76`  #you can modify
interger_WO=`echo 1`  #you can modify
##If the index does not have an order
#WaterO=(115,116,117,118,119,120,121,122,123,124,125,126)
```

****

**Typing the command**: **`sbatch Submit.run`** 

****
