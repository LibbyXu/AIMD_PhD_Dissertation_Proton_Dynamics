# Proton Relaxation Time When Bonding with The Same O

**Calculating the proton relaxation time. This code works about up to 3 protons in system. If you have more protons, you can modify the codes by yourself.** 

## Main Scripts & Functions

**i)** **`Submit_First.run, Submit_Second.run, Submit_Third.run`**: Linux submit files

**ii)** **`Get_Segment_All_Protons_First.sh, Separated_Each_Proton_And_Combine_Second.sh, Combine_all_Proton_and_Average_Third.sh`**: The data processing scripts.

## About Final Outputs

#### Outputs from `final_combine_average`:

**i)** **`final_averaged_total_water_surface`**: Combined final Time-correlation function results. (as a function of time)

**ii)** **`final_total_proton`**: Averaged value to each proton from result **`final_averaged_total_water_surface`**.

**iii)** **`result_total_integration_#`**: Time-correlation function results for each proton as a function of time.

**iv)** **`python_Third.log`**: Averaged Total, Water, Surface, proton relaxation time.

#### Outputs from `proton_id_#`:

**i)** **`Final_Surface_proton_time_period`**: Total: Step, proton-bonded O index, binding time.

**ii)** **`Final_Total_proton_time_period`**: Surface: Step, proton-bonded O index, binding time.

**iii)** **`Final_Water_proton_time_period`**: Water: Step, proton-bonded O index, binding time.

**iv)** **`proton_id_1`**: Total, Water, Surface, proton relaxation time.

**v)** **`result_total_integration`**: Time-correlation function results. (as a function of time)

**vi)** **`time_proton`**: Proton index for each step.

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`Final_proton_bonded_O_reorder_list_Final`** from **`4_Reordering_O_H_List`**.

****

### Scripts & submit files for the First-step calculations: 

**`Submit_First.run, Submit_Second.run, Submit_Third.run, Get_Segment_All_Protons_First.sh, Separated_Each_Proton_And_Combine_Second.sh, Combine_all_Proton_and_Average_Third.sh`**

You need to modify some parameters in file **`Get_Segment_All_Protons_First.sh`**:

```javascript
#Definition of variables
#The number of protons in the system
total_proton_num=`echo 2`  #You can modify.

##The O index from Surface
##If the indexes have an order
SO_St=`echo 30`  #You can modify.
SO_En=`echo 65`  #You can modify.
interger_SO=`echo 1`  #You can modify.
##If the index does not have an order
#SurfaceO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)

##The O index from water 
##If the indexes have an order
WO_St=`echo 69`  #You can modify.
WO_En=`echo 72`  #You can modify.
interger_WO=`echo 1`  #You can modify.
##If the index does not have an order
#WaterO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)
```

You need to modify some parameters in file **`Separated_Each_Proton_And_Combine_Second.sh`**:

```javascript
#Definition of variables
#The number of protons in the system
total_proton_num=`echo 2`  #You can modify.

#echo "   15000      0      0" >> Final_Surface_proton_time_period   #You can modify 15000
echo "   15000      0      0" >> Final_Total_proton_time_period   #You can modify 15000
#echo "   15000      0      0" >> Final_Water_proton_time_period   #You can modify 15000

##The O index from Surface
##If the indexes have an order
SO_St=`echo 33`  #You can modify.
SO_En=`echo 64`  #You can modify.
interger_SO=`echo 1`  #You can modify.
##If the index does not have an order
#SurfaceO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)

##The O index from Water
##If the indexes have an order
WO_St=`echo 65`  #You can modify.
WO_En=`echo 76`  #You can modify.
interger_WO=`echo 1`  #You can modify.
##If the index does not have an order
#WaterO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)
```

You need to modify some parameters in file **`Combine_all_Proton_and_Average_Third.sh`**:

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
