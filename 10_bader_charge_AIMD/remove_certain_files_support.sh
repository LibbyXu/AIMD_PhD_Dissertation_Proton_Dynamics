#!/bin/bash

for file in *AIMD_bader_*;
    do
    filename="$(basename "$file")"
    job_name="${filename}"

    cd ${filename}
    rm bader_diff_blocks.sh *.run* 
    rm *py* Charge_building_block *slurm*
    cd ..
done

mv AIMD_bader_1 1
mv AIMD_bader_2 2
mv AIMD_bader_3 3
mv AIMD_bader_4 4
mv AIMD_bader_5 5
mv AIMD_bader_6 6
mv AIMD_bader_7 7
mv AIMD_bader_8 8
mv AIMD_bader_9 9
mv AIMD_bader_10 10

