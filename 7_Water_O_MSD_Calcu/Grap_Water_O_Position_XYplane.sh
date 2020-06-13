#If your z lattice are perpendicular to the xy plane, you can use this script to extraxt the xy-plane Water-O MSD
#We need two files: position_O_traj_temp & head_XDATCAR from the previous step.

#load the Python3 environment
module load python/3.6.0

#Definition of variables
##The O index in water 
##If the indexes have an order
WO_St=`echo 60`  #you can modify
WO_En=`echo 75`  #you can modify
interger_WO=`echo 1`  #you can modify
echo "${WO_St}" >> index_WO_temp
for ((i=${WO_St}+${interger_WO}; i<=${WO_En}; i+=${interger_WO}))
do
echo ",$i" >> index_WO_temp
done
cat index_WO_temp | xargs > index_WO
WO_temp=(`echo $(grep "," index_WO)`)
WaterO=`echo ${WO_temp[@]} | sed 's/ //g'`
rm index_WO index_WO_temp
##If the index does not have an order
#WaterO=(115,116,117,118,119,120,121,122,123,124,125,126)

IFS=', ' read -r -a water_num <<< "${WaterO[@]}"

##########################################
#Python proton-bonded O position XY-plane#
##########################################
cat << EOF > grab_O_posi_xy.py

import numpy as np
import math

water_index = [${WaterO[@]}]
water_n = len(water_index)
data_xyz = np.genfromtxt('pos_Water_O_traj_temp', delimiter='')

len_total=len(data_xyz[:,0])
position_xy=np.zeros(shape=(len_total,3))
position_xy[:,0:2]=data_xyz[:,0:2]

np.savetxt('xy_plane_water_O', position_xy, fmt="%s", delimiter='   ')

EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
python grab_O_posi_xy.py > python.log
rm *.py*

awk '{printf("%12.8f %12.8f %12.8f\n", $1,$2,$3)}' xy_plane_water_O > xy_plane_water_O_temp
rm xy_plane_water_O pos_Water_O_traj_temp

Num_lines_xy=`wc -l xy_plane_water_O_temp | cut -d' ' -f1`
Num_step_xy=`echo ${Num_lines_xy}'/'${#water_num[@]} | bc`

for ((aa=1; aa<=${Num_step_xy}; aa++))
do
    echo "Direct configuration=  $aa" >> final_xy_water_O_temp
    start_line=`echo '('$aa'-'1')*'${#water_num[@]}'+'1 | bc`
    end_line=`echo $aa'*'${#water_num[@]} | bc`
    sed -n ''${start_line}','${end_line}'p' xy_plane_water_O_temp >> final_xy_water_O_temp
done

cat head_XDATCAR final_xy_water_O_temp > final_xy_water_O
rm  head_XDATCAR final_xy_water_O_temp xy_plane_water_O_temp
