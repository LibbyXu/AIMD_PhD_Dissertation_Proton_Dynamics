#This is used to grap the xyz coordinate postitions of the protn-bonded O each step.
#We need three files: [POSCAR, XDATCAR] from 2_Split_Manually_Data_Processing, Final_proton_bonded_O_reorder_list_Final from 4_Reordering_O_H_List

#load the Python3 environment
module load python/3.6.0

#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2` #you can modify

#Some data preparations
##without Selective option when doing AIMD using VASP
sed '8,$d' POSCAR > head_XDATCAR
sed '1,6d' head_XDATCAR > NUMA
##with Selective option when doing AIMD using VASP
#sed '9,$d' POSCAR > head_XDAT
#sed '1,6d' head_XDAT > NUMA

##obtinaing the right loop files
sed '1,7d' XDATCAR > XDATCAR_final
rm XDATCAR POSCAR

#Obatin the last $1 of steps
num_atoms=`awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}' NUMA`
delet_line=`echo '('${num_atoms}'+'1')*'$1 | bc`
sed -i '1,'${delet_line}'d' XDATCAR_final
rm NUMA

#########################################
#Python proton-bonded O position XYZ-dir#
#########################################
cat << EOF > grab_Proton_binded_O_position_for_MSD_calcu.py
#Grab proton binded O position to this file
import numpy as np
import math

step_atom = ${num_atoms}
step_lines = step_atom+1
proton_n = ${total_proton_num}
data_O = np.genfromtxt('Final_proton_bonded_O_reorder_list_Final', delimiter='')
Whole_traj = np.genfromtxt('XDATCAR_final', delimiter='')

num_steps=len(data_O[:,0])
position_O=np.zeros(shape=(num_steps*proton_n,3))

for i in range(0,num_steps):
    for ii in range(0,proton_n):
        num_index=int(data_O[i,ii+1])
        position_O[(proton_n*i+ii),:]=Whole_traj[(i*step_lines+num_index),:]
        
np.savetxt('position_O_traj', position_O, fmt="%s", delimiter='   ')

EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
python grab_Proton_binded_O_position_for_MSD_calcu.py > python.log
rm *.py*

awk '{printf("%12.8f %12.8f %12.8f\n", $1,$2,$3)}' position_O_traj > position_O_traj_temp
rm position_O_traj

Num_lines=`wc -l position_O_traj_temp | cut -d' ' -f1`
Num_step=`echo ${Num_lines}'/'${total_proton_num} | bc`

for ((aa=1; aa<=${Num_step}; aa++))
do
    echo "Direct configuration=  $aa" >> final_O_position_traj_temp
    start_line=`echo '('$aa'-'1')*'${total_proton_num}'+'1 | bc`
    end_line=`echo $aa'*'${total_proton_num} | bc`
    sed -n ''${start_line}','${end_line}'p' position_O_traj_temp >> final_O_position_traj_temp
done

sed -i '6,7d' head_XDATCAR
echo "   O" >> head_XDATCAR
echo "   ${total_proton_num}" >> head_XDATCAR

cat head_XDATCAR final_O_position_traj_temp > final_O_position_traj
rm  final_O_position_traj_temp XDATCAR_final

mkdir xy_plane_MSD
mv head_XDATCAR position_O_traj_temp xy_plane_MSD
cp Grap_Proton_Binded_O_Position_XYplane.sh xy_plane_MSD
mv Submit_XY.run xy_plane_MSD
