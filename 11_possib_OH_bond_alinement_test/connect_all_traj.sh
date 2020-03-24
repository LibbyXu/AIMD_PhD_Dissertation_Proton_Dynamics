#connect all the trajectory file to the one file

ls -l  > num_XDATCAR
grep "File_XDATCAR_" num_XDATCAR > TEMP_XDATCAR
Num_Xfile=`wc -l TEMP_XDATCAR | cut -d' ' -f1`
rm num_XDATCAR TEMP_XDATCAR

mkdir Final_connected_traj_continues
mkdir Slurm_ALL

for ((a=1;a<=${Num_Xfile};a++))
do
cd File_XDATCAR_$a
cp final_WO_position final_WO_position_$a
cp *slurm* slurm_$a
mv final_WO_position_$a ../Final_connected_traj_continues
mv slurm_$a ../Slurm_ALL
cd ..
done

cd Final_connected_traj_continues

touch Final_total_traj
for ((a=1;a<=${Num_Xfile};a++))
do
cat Final_total_traj final_WO_position_$a > final_WO_position_temp
mv final_WO_position_temp Final_total_traj
done
rm *final_WO_position*





