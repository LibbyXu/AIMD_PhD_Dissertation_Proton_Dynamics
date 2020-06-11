# Preliminary Treatment of Output Files

Before we start to analyze different features for the ion/proton dynamic behaviors, we need to process the combination & cleaning of the high-volume data.

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submmit file

**ii)** **`Pre_Traj_check.sh`**: Code processing file

This script aims to combine the separated **"vasp_#.out" & "XDATCAR_#"** files (due to the limited simulation time to perform **_Ab-initio_ molecular dynamic "AIMD"** each time). 

After executing the commands, we will get the ouput files: **"T_E.dat"**, the combined **"XDATCAR" & "vasp.out"**. 

## About Outputs

**i)** **`T_E.dat`**: Contained the information: *step number, temperature, total free energy.*

**ii)** **`XDATCAR`**: The combined whole trajectory file. 

**iii)** **`vasp.out`**: The combined whole “OSZICAR” file.

## Processing Scripts

#### Files needed to be put in the same (current) folder before typing commands:

Separated vasp.out files (more than 2 files): **`vasp_1.out, vasp_2.out, vasp_2.out, ……`**

Separated trajectory file (more than 2 files): **`XDATCAR_1, XDATCAR_2, XDATCAR_3, ……`**

Scripts & submit files: **`Pre_Traj_check.sh, Submit.run`**

****

**Typing the command**: **`sbatch Submit.run`** or **`./Pre_Traj_check.sh > LOG`**

****
