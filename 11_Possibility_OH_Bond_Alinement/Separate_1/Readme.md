# Producing Several Important Files Necessary for The Post-treatment of Data 

**Some files that need to be produced for the latter analysis on the OH and Dipole orientation of water molecules.** 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Separate_for_Necessary_files.sh`**: The data processing script for obtaining water-O(and 3 nearest H) positions each step along trajectories. Get the separate water-O and Water-H(3 closest to the water-O) files.

## About Outputs

**i)** **`Final_Each_Step_in_Traj`**: Obtain water-O(& 3 nearest H) positions each step along trajectories. 

**ii)** **`WO_position`**: The whole Water-O positions for all steps.

**iii)** **`WOH_position`**: The whole H(3 nearest H towards the corresponding water-O) positions for all steps.

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`Final_Total_OH_Degree_Results`** from the previous **`Final_Conbined_OH_Degree_Results`** folder in **`11_Possibility_OH_Bond_Alinement`**.

#### Scripts & submit files: 

**`Separate_for_Necessary_files.sh.sh, Submit.run`**.

****

**Typing the command**: **`sbatch Submit.run`** 

****
