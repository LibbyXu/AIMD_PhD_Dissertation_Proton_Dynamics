#!/bin/bash
#In case that, if some problems happened during calculations.
#This script will help to remove all produced files and make the filder return to its original input state.

for file in *File_XDATCAR_*;
do
  filename="$(basename "$file")"
  job_name="${filename}"

  cd ${filename}
  rm Pro_O_coores_H.sh *.run* CONTCAR *py* *python.log* *slurm* neighdist.dat final_Hlist_temp near_O_list H_temp_list *.dat*
  cd ..
done

