# Grabbing Proton-bonded O Positions (XYZ-coordinates)

From the **`Final_proton_bonded_O_reorder_list_Final`** from **`4_Reordering_O_H_List`** of which the file involves information of all the continuous O index change along trajectories. Here, in this folder, we try to grab the position (XYZ-Coordinates) of the proton-bonded O corresponding to each step. The resulted trajectories will be used to further calculate the proton diffusion coefficeints.

***The requirements for the systems that can use these scripts to obtain the proton-bonded O coordinates for the whole trajectories: The unit cell: The Z-direction should be perpendicular to the XY-plane.***

## Main Scripts & Functions

**i)** **`Submit_Total.run`**: Linux submit file used for performing the first calculation.

**ii)** **`Submit_XY.run`**: Linux submit file used for performing the second calculation.

**iii)** **`Grap_Proton_Binded_O_Position_All.sh`**: Obtain the XYZ-dir. coordinate positions of the proton-bonded O for the whole trajectory. Data processing script (for the first calculation).

**iv)** **`Grap_Proton_Binded_O_Position_XYplane.sh`**: Obtain the X-dir. and Y-dir. Coordinate positions of the proton-bonded O for the whole trajectory. Data processing script (for the second calculation).

## About Outputs

#### After the first calculations:

**i)** **`final_O_position_traj`**: Contain the calculated XYZ-dir. coordinate positions results. (The format similar to VASP **`XDATCAR`**)

**ii)** Generated a folder called **`xy_plane_MSD`**: In this folder, we have the produced **`position_O_traj_temp`** & **`head_XDATCAR`** files.

#### After the second calculations:

**i)** **`final_xy_O_position`**: Contain the calculated XY-dir. coordinate positions results.(The format similar to VASP **`XDATCAR`**)

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`POSCAR, XDATCAR`** from **`2_Split_Manually_Data_Processing`**, **`Final_proton_bonded_O_reorder_list_Final`** from **`4_Reordering_O_H_List`**.

#### Scripts & submit files: 

**`Grap_Proton_Binded_O_Position_All.sh, Grap_Proton_Binded_O_Position_XYplane.sh, Submit_Toal.run, Submit_XY.run`**.

**We need to modify some parameters in Submit_Toal.run.**

```javascript
#The number of the last steps that will be needed in your data analysis
needed_step=`echo 15000` #you can modify
```

**Also, we need to modify some parameters in** **`Grap_Proton_Binded_O_Position_All.sh`** and **`Grap_Proton_Binded_O_Position_XY.sh`**

```javascript
#How many protons are studied in the system
total_proton_num=`echo 2` #you can modify
```

****

**1.Typing the command**: 

```javascript
sbatch Submit_Total.run
```

**After the previous step finished.**

**2.Then we type the command**: 

```javascript
cd xy_plane_MSD
sbatch Submit_XY.run
```

****

## Notes:

The produced results **`final_O_position_traj`** and **`final_xy_O_position`** can be used for the (mean square displacement) *MSD* analysis [nMOLDYN]. *And for later calculating the proton (total) diffusion coefficient, the decomposed diffusion coefficient (XY-plane, Z-dir.).*  

****
