#!/bin/bash

#Remove all related (produced) "AIMD_bader_" folders and files
for file in *AIMD_bader_*;
  do
  filename="$(basename "$file")"
  job_name="${filename}"

  cd ${filename}
  rm Bader_Diff_Blocks.sh *.run* 
  rm *py* Charge_building_block *slurm*
  cd ..
done
