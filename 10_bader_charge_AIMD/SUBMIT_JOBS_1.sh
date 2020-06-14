#!/bin/bash

###In the current folder, we have different calculated Bader Charge foders with the following style of names
##1 AIMD_bader_1
##2 AIMD_bader_2
##3 AIMD_bader_3
##4 AIMD_bader_4
##5 AIMD_bader_5
##6 AIMD_bader_6
##7 AIMD_bader_7
##8 AIMD_bader_8
##9 AIMD_bader_9
##10 AIMD_bader_10
##......

#Conducting the scripts in each "AIMD_bader_#" folder 
for file in *AIMD_bader_*;
  do
  filename="$(basename "$file")"
  job_name="${filename}"
  
  cp Bader_Diff_Blocks.sh Submit.run ${filename}
  cd ${filename}
  mv Submit.run ${job_name}.run
  sed -i "s/ Bader_Diff_Blocks/ Py_Bader_Diff_Blocks_${job_name}/g" ${job_name}.run
  sbatch ${job_name}.run
  cd ..
done

