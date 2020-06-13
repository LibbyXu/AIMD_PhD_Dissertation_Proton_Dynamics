#If your z lattice are perpendicular to the xy plane, you can use this script to extraxt the xy-plane proton-bonded O MSD
#We need two files:position_O_traj_temp & head_XDATCAR both from the previous step.

#load the Python3 environment
module load python/3.6.0

#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2` #you can modify

##########################################
#Python proton-bonded O position XY-plane#
##########################################
cat << EOF > grab_Proton_binded_O_position_for_XYPlane_MSD_calcu.py

import numpy as np
import math

proton_n = ${total_proton_num}
data_xyz = np.genfromtxt('position_O_traj_temp', delimiter='')

len_total=len(data_xyz[:,0])
position_xy=np.zeros(shape=(len_total,3))
position_xy[:,0:2]=data_xyz[:,0:2]

for i in range(0,len_total):
    position_xy[i,2]=0
        
np.savetxt('xy_plane_position', position_xy, fmt="%s", delimiter='   ')
EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
python grab_Proton_binded_O_position_for_XYPlane_MSD_calcu.py > python.log
rm *.py*

awk '{printf("%12.8f %12.8f %12.8f\n", $1,$2,$3)}' xy_plane_position > position_xy_temp
rm xy_plane_position position_O_traj_temp

Num_lines_xy=`wc -l position_xy_temp | cut -d' ' -f1`
Num_step_xy=`echo ${Num_lines_xy}'/'${total_proton_num} | bc`

for ((aa=1; aa<=${Num_step_xy}; aa++))
do
    echo "Direct configuration=  $aa" >> final_xy_O_position_temp
    start_line=`echo '('$aa'-'1')*'${total_proton_num}'+'1 | bc`
    end_line=`echo $aa'*'${total_proton_num} | bc`
    sed -n ''${start_line}','${end_line}'p' position_xy_temp >> final_xy_O_position_temp
done

cat head_XDATCAR final_xy_O_position_temp > final_xy_O_position
rm  head_XDATCAR final_xy_O_position_temp position_xy_temp

