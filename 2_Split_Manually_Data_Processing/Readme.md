# Split File for Fast & High-volume Data Processing

**The parallel programming version will be warranted in the future.**

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Cut_and_Split.sh`**: Code processing file for splitting trajectory purpose

The script file in this folder is for cutting/splitting the trajectories (**"XDATCAR"**: with >15000 simulation steps; >350 atomic coordinate positions per step.) files into smaller trajectory files with 500-step per file. *Hence, the data processing process would be much faster.*

## About Outputs

**i)** Generating numerous **`File_XDATCAR_#`** **folders**.

**ii)** In each **`File_XDATCAR_#`** folder: we have **`XDATCAR`** (containing 500 trajectory steps), **`POSCAR`** (mainly provided the lattice information)

## Processing Scripts

#### Files needed to be put in the same (current) folder before typing commands:

**`POSCAR`**: The initial coordination file for processing the **AIMD** simulations using VASP software.

**`XDATCAR`**: This script is from folder **`1_Combine_XDATCAR_Pre_Analysis`**. 

#### Scripts & submit files: 

**`Cut_and_Split.sh, Submit.run`**

****

**Typing the command**: **`sbatch Submit.run`** or **`./Cut_and_Split.sh > LOG`**

****




