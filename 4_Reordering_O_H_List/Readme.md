# Reordering Proton-bonded O Trajectories Continuous 

**We need to reorganize the “Final_Combined_reduced_H_list” file to make the proton-bonded O trajectories continuous. (Identify each proton-bonded O transfer path)** 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Reordering_O_Proton_H_List.sh`**: The reordering data processing script

## About Outputs

The details of the format for each file are explained in the relevant coding file.

**i)** **`Final_proton_bonded_O_reorder_list_Final`**: Provide all continuous proton-bonded O index for each step along trajectories. 

**ii)** **`Final_proton_bonded_O_nearest_three_H_list_Final`**: Contain the H/proton indexes for each step along trajectories. 

3H if the proton bonds with water to form H<sub>3</sub>O<sup>+</sup> or 1H if the proton bonds with the surface-O to from -OH group. The corresponding O-H distances are also writien in this file. Inside the data file, each row corresponds to one step along trajectories. 

**iii)** **`Fourth_python.log`**: Check produced data file.

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`Final_Combined_reduced_H_list`**: Produced from the folder **`3_Proton_Bonded_O_index_Traj`** that contains all information related to the proton-bonded O. 

#### Scripts & submit files: 

**`Reordering_O_Proton_H_List.sh, Submit.run`**.

We need to modify one parameter in **`Reordering_O_Proton_H_List.sh`**.

```javascript
#####Number of the protons#####  
total_proton_num=`echo 2` #You can modify
```

****

**Typing the command**: **`sbatch Submit.run`** or **`./Reordering_O_Proton_H_List.sh > LOG`**

****
 







