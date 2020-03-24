#!/bin/bash

mv 1 AIMD_bader_1
mv 2 AIMD_bader_2
mv 3 AIMD_bader_3
mv 4 AIMD_bader_4
mv 5 AIMD_bader_5
mv 6 AIMD_bader_6
mv 7 AIMD_bader_7
mv 8 AIMD_bader_8
mv 9 AIMD_bader_9
mv 10 AIMD_bader_10

for file in *AIMD_bader_*;
    do
    filename="$(basename "$file")"
    job_name="${filename}"
    
    cp bader_diff_blocks.sh Submit.run ${filename}
    cd ${filename}
    mv Submit.run ${job_name}.run
    sed -i "s/ AIMD_bader/ Py_${job_name}/g" ${job_name}.run
    sbatch ${job_name}.run
    cd ..
done

