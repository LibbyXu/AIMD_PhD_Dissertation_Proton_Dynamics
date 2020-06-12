#!/bin/bash
#Put the needed "Submit.run" file into each folder. And conduct the calculation.

for file in *File_XDATCAR_*; 
do
  filename="$(basename "$file")"
  job_name="${filename}"
    
  cp Pro_O_coores_H.sh Submit.run ${filename}
  cd ${filename}
  mv Submit.run ${job_name}.run
  sed -i "s/ bash/ Py_${job_name}/g" ${job_name}.run
  sbatch ${job_name}.run
  cd ..
done
