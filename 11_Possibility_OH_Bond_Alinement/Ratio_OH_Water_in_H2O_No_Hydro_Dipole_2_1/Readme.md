# Obtain Density of the OH Orientations & Dipole Moment for All Water Molecules (Without the Hydronium ion)

Here, we try to examine number of the orientations (degree) within certain degree range. 

## Main Scripts & Functions

**i)** **`Submit_First.run`**: Linux submit file, perform at the first step.

**ii)** **`Submit_Second.sh`**: Linux submit file, perform at the second step.

**iii)** **`Corres_H_Posiitons_First.sh`**: The data processing script.

**iv)** **`OH_Unit_Area_Second.sh`**: The data processing script for obtaining the number of orientation within certain degree region per unit surface (cell). 

## About Final Outputs

**i)** **`Final_hydronium_O_corr`**: Info about the O atom in hydronium ion.

**ii)** **`corres_O_W_num_second`**: If the proton bonded with the water-O, there will be a number 1 after the corresponding water-O index.

**iii)** **`final_Dipole_direction_vector`**: All dipole info about the water moleucles.

**iv)** **`final_polarization_file`**: Detailed OH orientation value (degree) for every water molecule in every step along trajectories.

**v)** **`final_PWOH_bonding_each_step_first`**: Proton and Proton-bonded O index info for every step.

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`WOH_position, WO_position`** from previous **`Separate_1 folder`**,

**`Final_proton_bonded_O_reorder_list_Final`** from **`4_Reordering_O_H_List folder`**,

### Scripts & submit files: 

**`Corres_H_Posiitons_First.sh, Submit_First.run, Submit_Second.sh, OH_Unit_Area_Second.sh`**.

****

**1. Typing the command**: **`sbatch Submit_First.sh`**

We need to modify parameters in **`Corres_H_Posiitons_First.sh`**:

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

**2. Typing the command**: **`sbatch Submit_Second.sh`**

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
