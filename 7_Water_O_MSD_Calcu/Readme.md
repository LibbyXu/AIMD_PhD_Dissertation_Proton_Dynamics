# Grabbing Water-O Positions (XYZ-coordinates)

The water mobilities may also influence the proton dynamic behavior. Since in literature, besides the Grotthuss mechanism, we have the vehicle mechanisms. Hence, here, we try to grab the position (XYZ-Coordinates) of all water-O (including the O in hydronium ion) corresponding to each step for the later calculations on the water diffusion coefficient. 

***The requirements for the systems that can use these scripts to obtain the proton-bonded O coordinates for the whole trajectories: The unit cell: The Z-direction should be perpendicular to the XY-plane.***

## Main Scripts & Functions

**i)** **`Submit_Total.run`**: Linux submit file used for performing the first calculation.

**ii)** **`Submit_XY.run`**: Linux submit file used for performing the second calculation.

**iii)** **`Grap_Water_O_Position_All.sh`**: Obtain the XYZ-dir. coordinate positions of all water-O for the whole trajectory. Data processing script (for the first calculation).

**iv)** **`Grap_Water_O_Position_XYplane.sh`**: Obtain the X-dir. and Y-dir. Coordinate positions of all water-O for the whole trajectory. Data processing script (for the second calculation).

## About Outputs

#### After the first calculations:

**i)** **`final_Water_O_traj`**: Contain the calculated XYZ-dir. coordinate positions results.(The format similar to VASP **`XDATCAR`**)

**ii)** Generated a folder called **`xy_plane_MSD`**: In this folder, we have the produced **`position_O_traj_temp`** & **`head_XDATCAR`** files.

#### After the second calculations:

**i)** **`final_xy_water_O`**: Contain the calculated XY-dir. coordinate positions results.(The format similar to VASP **`XDATCAR`**)

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`POSCAR, XDATCAR`** from **`2_Split_Manually_Data_Processing`**. 

#### Scripts & submit files: 

**`Grap_Water_O_Position_All.sh, Grap_Water_O_Position_XYplane.sh, Submit_Toal.run, Submit_XY.run`**.

**We need to modify some parameters in Submit_Toal.run.**

```javascript
#The number of the last steps that will be needed in your data analysis
needed_step=`echo 15000` #you can modify
```

**Also, we need to modify some parameters in** **`Grap_Water_O_Position_All.sh `** and **`Grap_Water_O_Position_XYplane.sh`**

```javascript
#Definition of variables
##The O index in water 
##If the indexes have an order
WO_St=`echo 60`  #you can modify
WO_En=`echo 75`  #you can modify
interger_WO=`echo 1`  #you can modify 
##If the index does not have an order
#WaterO=(115,116,117,118,119,120,121,122,123,124,125,126)
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

The produced results **`final_Water_O_traj`** and **`final_xy_water_O`** can be used for the (mean square displacement) *MSD* analysis [R.I.N.G.S.]. *And for later calculating the proton (total) diffusion coefficient, the decomposed diffusion coefficient (XY-plane, Z-dir.).*  

****
