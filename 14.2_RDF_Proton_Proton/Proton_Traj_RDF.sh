#Making the Proton-traj 
#We need two files: Each_Proton_position from 14.1_Each_Proton_xyz_Identity_O, POSCAR from 2_Split_Manually_Data_Processing

#load the Python3 environment
module load python/3.6.0

#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 1`

sed '6,$d' POSCAR > head_POSCAR
rm POSCAR

for ((i=1;i<=${total_proton_num};i+=1))
do
  awk '{printf("%12.8f %12.8f %12.8f\n",$('${i}'*7-2),$('${i}'*7-1),$('${i}'*7));}' Each_Proton_position > proton_${i}
done

awk '{printf("%5d\n",$1);}' Each_Proton_position > index_proton
numline_steps=`wc -l index_proton | cut -d' ' -f1`
rm index_proton

for ((aa=1; aa<=${numline_steps}; aa++))
do
    echo "Direct configuration=  ${aa}" >> pro_traj_temp
    for ((bb=1; bb<=${total_proton_num};bb++))
    do
        sed -n ''${aa}'p' proton_${bb} >> pro_traj_temp
    done
done

echo "   H" >> head_POSCAR
echo "   ${total_proton_num}" >> head_POSCAR

cat head_POSCAR pro_traj_temp > Final_pro_traj_temp
rm head_POSCAR pro_traj_temp *proton_*
