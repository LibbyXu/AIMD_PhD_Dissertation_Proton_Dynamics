# Creating Surface(O)-Proton/H RDF

**We obtain the XYZ-coordinate positions of Sueface-O and proton/H each step along paths.** 

## Main Scripts & Functions

**i)** **`Submit.run`**: Linux submit file

**ii)** **`Grap_SO_Proton_H.sh`**: The data processing script.

## About Outputs

**i)** **`final_pos_SO_HPW`**: The combined XYZ-position file for surface-O and H/protons. (The format of the file is similar to that of the VASP output **`XDATCAR`**) 

## Processing Scripts

#### Files/folders needed to be put into the current folder before typing commands:

**`POSCAR, XDATCAR`** from **`2_Split_Manually_Data_Processing`**

#### Scripts & submit files: 

**`Grap_SO_Proton_H.sh, Submit.run`**.

**We need to modify one parameter in ** **`Submit.run`**

```javascript
#The number of the last steps that will be needed in your data analysis
needed_step=`echo 15000` #You can modify 
```

**We also need to modify some parameters in** **`Grap_SO_Proton_H.sh`**.

```javascript
#Definition of variables
##The O index from surface 
##If the indexes have an order
SO_St=`echo 30`  #you can modify
SO_En=`echo 65`  #you can modify
interger_SO=`echo 1`  #you can modify#Definition of variables
##If the index does not have an order
#SurfaceO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)

##H index from interfaces 
##If the indexes have an order
H_St=`echo 125`  #you can modify
H_En=`echo 150`  #you can modify
interger_H=`echo 1`  #you can modify
##If the index does not have an order
#WaterHP=(126,131,132,135,137,140,141,143,145)
```

****

**Typing the command**: **`sbatch Submit.run`** 

****

## Notes:

The produced trajectory file **`final_pos_SO_HPW`** will be used for *the radial distribution function (RDF)* analysis using the **`R.I.N.G.S. software`**. 

****
