#Combine all results into one file
ls -l  > num_XDATCAR
grep "File_XDATCAR_" num_XDATCAR > TEMP_XDATCAR
Num_Xfile=`wc -l TEMP_XDATCAR | cut -d' ' -f1`
rm num_XDATCAR TEMP_XDATCAR

#Make the directories
mkdir Final_Conbined_OH_Degree_Results
mkdir Slurm_ALL

#Put all results file into the current folder
for ((a=1;a<=${Num_Xfile};a++))
do
  cd File_XDATCAR_$a
  cp final_WO_position final_WO_position_$a
  cp *slurm* slurm_$a
  mv final_WO_position_$a ../Final_Conbined_OH_Degree_Results
  mv slurm_$a ../Slurm_ALL
  cd ..
done

#Combine all results
cd Final_Conbined_OH_Degree_Results
touch Final_Total_OH_Degree_Results
for ((a=1;a<=${Num_Xfile};a++))
do
  cat Final_Total_OH_Degree_Results final_WO_position_$a > final_WO_position_temp
  mv final_WO_position_temp Final_Total_OH_Degree_Results
done
rm *final_WO_position*
