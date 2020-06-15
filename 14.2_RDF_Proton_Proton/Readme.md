# Creating Proton-Proton RDF

**We obtain the XYZ-coordinate positions of protons each step along paths.** 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Proton_Traj_RDF.sh`**: The data processing script.

## About Outputs

**i)** **`Final_pro_traj_temp`**: The combined XYZ-position file for proton. (The format of the file is similar to that of the VASP output **`XDATCAR`**) 

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`Each_Proton_position`** from **`14.1_Each_Proton_xyz_Identity_O`**, **`POSCAR`** from **`2_Split_Manually_Data_Processing`**

#### Scripts & submit files: 

**`Proton_Traj_RDF.sh, Submit.run`**.

**We also need to modify some parameters in** **`Proton_Traj_RDF.sh`**.

```javascript
#Definition of variables
##Number of the protons  
total_proton_num=`echo 2` #You can modify
```

****

**Typing the command**: **`sbatch Submit.run`** 

****

## Notes:

The produced trajectory file **`Final_pro_traj_temp`** will be used for *the radial distribution function (RDF)* analysis using the **`R.I.N.G.S. software`**. 

****


