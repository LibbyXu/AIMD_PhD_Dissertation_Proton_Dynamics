# Obtian the Averaged Time Period Value for Proton-bonded O

**Calculating the Averaged Time period when the proton is bonding with the surface O or the water O or the combined cases.** 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Separate_Time_Water_Surface_Total.sh`**: The data processing script.

## About Outputs

**i)** **`position_Surface_O_all`**: 

**ii)** **`python`**: Total, Surface, Water average binding time.

**iii)** **`Sorted_Surface_whole_time_binding_final`**: If we have the case that the proton is binding with the surface, we will get the sorted time periods when it binds with differnet proton-bonded O.

**iv)** **`Sorted_Total_whole_time_binding_final`**: Combined the surface and water cases.

**v)** **`Sorted_Water_whole_time_binding_final`**: If we have the case that the proton is binding with the water, we will get the sorted time periods when it binds with differnet proton-bonded O.

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`proton_id_#`** folder from **`12_Proton_Remaining_Time`**.

#### Scripts & submit files: 

**`Separate_Time_Water_Surface_Total.sh, Submit.run`**.

**We need to modify some parameters in** **`Separate_Time_Water_Surface_Total.sh`**.

```javascript
#Definition of variables
#The number of protons in the system
total_proton_num=`echo 2`  #You can modify.
```

****

**Typing the command**: **`sbatch Submit.run`** 

****
