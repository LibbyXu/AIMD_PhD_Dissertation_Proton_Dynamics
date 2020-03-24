#!/bin/bash

for file in *File_XDATCAR_*;
do
    filename="$(basename "$file")"
    job_name="${filename}"

    cd ${filename}
    rm Hlist_proton.sh *.run* 
    rm CONTCAR *py* *python.log* *slurm* neighdist.dat final_Hlist_temp all_O_list H_temp_list *.dat* CONTCAR
    cd ..
done

