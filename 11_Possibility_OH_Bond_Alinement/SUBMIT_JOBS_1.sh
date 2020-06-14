#!/bin/bash

#Put the needed input files into the folder and conduct the calculations
for file in *File_XDATCAR_*;
  do
  filename="$(basename "$file")"
  job_name="${filename}"
  
  cp possibility_OH_tilting.sh Submit.run ${filename}
  cd ${filename}
  mv Submit.run ${job_name}.run
  sed -i "s/ bash/ Py_${job_name}/g" ${job_name}.run
  sbatch ${job_name}.run
  cd ..
done
