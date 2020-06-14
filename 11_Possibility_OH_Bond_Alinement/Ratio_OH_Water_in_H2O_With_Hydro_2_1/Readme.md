# Obtain Density of the OH Orientations & Dipole Moment Orientations for All Water Molecules (Including the Hydronium ion)

Here, we try to examine number of the orientations (degree) within certain degree range. 

## Main Scripts & Functions

**i)** **`Submit_First.run`**: Linux submit file, perform at the first step.

**ii)** **`Submit_Second.sh`**: Linux submit file, perform at the second step.

**iii)** **`Data_processes_Corres_H_Posiitons_First.sh`**: The data processing script.

**iv)** **`OH_Unit_Area_Second.sh`**: The data processing script for obtaining the number of orientation within certain degree region per unit surface (cell). 

## About Outputs

#### Outputs created by Data_processes_Corres_H_Posiitons_First.sh: 

**i)** **`final_PWOH_bonding_each_step_first`**: Contain info of step number, the number of protons within the system, the proton-bonded O index, the proton index. 

**ii)** **`corres_O_W_num_second`**: If the proton bonded with the water-O, there will be a number 1 after the corresponding water-O index.

**iii)** **`final_H_list_step_second`**: Used for the next-step data processing script.

#### Outputs created by OH_Unit_Area_Second.sh:

**i)** **`Python_Result.log`**: Averaged number of OH within certain degree (45) towards the surface of the eletrode materials.

**ii)** **`final_polarization_file`**: 

**iii)** **`final_num_OH_ratio_${Water_layer_num}_${degree_for_all}`**:

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`WOH_position, WO_position`** from previous **`Separate_1 folder`**,

**`Final_proton_bonded_O_reorder_list_Final`** from **`4_Reordering_O_H_List folder`**,

### Scripts & submit files: 

**`Data_processes_Corres_H_Posiitons_First.sh, Submit_First.run, Submit_Second.sh, OH_Unit_Area_Second.sh`**.

****

**1. Typing the command**: **`sbatch Submit_First.sh > LOG_1`**

We need to modify parameters in **`Data_processes_Corres_H_Posiitons_First.sh`**:

```javascript
#Definition of variables
##Number of the protons
total_proton_num=`echo 2` #You can modify 

##The O index from Water 
##If the indexes have an order
WO_St=`echo 65` #You can modify 
WO_En=`echo 76` #You can modify 
interger_WO=`echo 1` #You can modify 
##If the index does not have an order
#WaterO=(65,68,71,72,74)
```

****

**2. Typing the command**: **`sbatch Submit_Second.sh > LOG_2`**

We need to modify parameters in **`OH_Unit_Area_Second.sh`**:

```javascript
##Definition of variables
##Number of the protons
total_proton_num=`echo 2` #You can modify 

##The separate degrees
degree_for_all=`echo 45` #You can modify 

#The x y position for the area for calculating the area (from lattice constants)
AxisOxy=(10.0,0.0) #You can modify 
AxisTxy=(-5.0,10.0) #You can modify 
AxisRxy=(0.0,0.0) #You can modify 

##The O index from Water 
##If the indexes have an order
WO_St=`echo 65` #You can modify 
WO_En=`echo 76` #You can modify 
interger_WO=`echo 1` #You can modify 
##If the index does not have an order
#WaterO=(65,68,71,72,74)
```

****
