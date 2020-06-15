# All Distance Between The Proton (ALL H) And Its Nearest O

**The distances between the Proton and The nearest O. We will also record the distance between the H and the nearest O. ** 

## Main Scripts & Functions

**i)** **`Submit_First.run, Submit_Second.run, Submit_Third.run`**: Linux submit files

**ii)** **`Grab_Proton_H_Bonding_Dis_O_First.sh, Grab_Proton_H_Bonding_Dis_O_Second.sh, Grab_Proton_H_Bonding_Dis_O_Third.sh`**: The data processing scripts.

## About Final Outputs

**i)** **`data_proton_in_water_exact`**: Step, proton index, distance between the proton and the nearest O.

**ii)** **`data_proton_in_water_selection`**: Step, proton index, distance between the proton and the nearest O. (Hydronium ion)

**iii)** **`Final_Proton_binded_O_two_list`**: The two nearest O with respect to the proton. Step, proton index, O index, distance. 

**iv)** **`Final_real_proton_H_bonding_distance`**: Proton index, Proton-bonded O index, distance.

**v)** **`Sorted_Final_real_proton_H_bonding_distance`**: Sorted the **`Final_real_proton_H_bonding_distance`** according from the distance.

**vi)** **`First_python.log, Second_python.log, Third_python.log`**: Check files.

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`Final_hydronium_O_corr`** from **`Ratio_OH_Water_in_H2O_No_Hydro_2_1`** in **`11_Possibility_OH_Bond_Alinement`**, **`XDATCAR, POSCAR`** from **`2_Split_Manually_Data_Processing`**.

****

### Scripts & submit files for the First-step calculations: 

**`Submit_First.run, Submit_Second.run, Submit_Third.run, Grab_Proton_H_Bonding_Dis_O_First.sh, Grab_Proton_H_Bonding_Dis_O_Second.sh, Grab_Proton_H_Bonding_Dis_O_Third.sh`**

You need to modify parameters in file **`Submit_First.run`**:

```javascript
#The number of the last steps that will be needed in your data analysis
needed_step=`echo 15000` #You can modify  
```

You need to modify some parameters in file **`Grab_Proton_H_Bonding_Dis_O_First.sh`**:

```javascript
#Definition of variables
#The number of protons in the system
total_proton_num=`echo 2`  #You can modify.

##The O index from water 
##If the indexes have an order
WO_St=`echo 65`  #You can modify.
WO_En=`echo 76`  #You can modify.
interger_WO=`echo 1`  #You can modify.
##If the index does not have an order
#WaterO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)
```

You need to modify some parameters in file **`Grab_Proton_H_Bonding_Dis_O_Second.sh`**:

```javascript
#Definition of variables
#The number of protons in the system
total_proton_num=`echo 2`  #You can modify.

##The O index from water 
##If the indexes have an order
WO_St=`echo 65`  #You can modify.
WO_En=`echo 76`  #You can modify.
interger_WO=`echo 1`  #You can modify.
##If the index does not have an order
#WaterO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)

##The O index from Surface
##If the indexes have an order
SO_St=`echo 33`  #You can modify.
SO_En=`echo 64`  #You can modify.
interger_SO=`echo 1`  #You can modify.
##If the index does not have an order
#SurfaceO=(83,85,109,111,113)
```

You need to modify some parameters in file **`Grab_Proton_H_Bonding_Dis_O_Third.sh`**:

```javascript
#Definition of variables
#The number of protons in the system
total_proton_num=`echo 2`  #You can modify.
```

****

**1. Typing the command**: **`sbatch Submit_First.run`** [When finished, perform 2]

****

**2. Typing the command**: **`sbatch Submit_Second.run`** [When finished, perform 3]

****

**3. Typing the command**: **`sbatch Submit_Third.run`**

****
