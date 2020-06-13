#This is used to grap the xyz coordinate postitions of all water-O each step.
#We need two files: POSCAR, XDATCAR from 2_Split_Manually_Data_Processing

#load the pyrhon3 environment
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

#Some data preparations
##without Selective option when doing AIMD using VASP
sed '8,$d' POSCAR > head_XDATCAR
sed '1,6d' head_XDATCAR > NUMA
##with Selective option when doing AIMD using VASP
#sed '9,$d' POSCAR > head_XDAT
#sed '1,6d' head_XDAT > NUMA

#obtinaing the right loop files
sed '1,7d' XDATCAR > XDATCAR_final
rm XDATCAR POSCAR

#Obatin the last $1 of steps
num_atoms=`awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}' NUMA`
delet_line=`echo '('${num_atoms}'+'1')*'$1 | bc`
sed -i '1,'${delet_line}'d' XDATCAR_final
rm NUMA

grep 'Direct' XDATCAR_final > line_D
total_numstep=`wc -l line_D | cut -d' ' -f1`
rm line_D

#################################
#Python Water-O position XYZ-dir#
#################################
cat << EOF > grab_water_O_MSD.py
#water O position traj
import numpy as np
import math

step_atom = ${num_atoms}
step_lines = step_atom+1
data_O_index = [${WaterO[@]}]
num_O=len(data_O_index) 
num_steps=${total_numstep}
Whole_traj = np.genfromtxt('XDATCAR_final', delimiter='')

posW_O=np.zeros(shape=(num_steps*num_O,3))

for i in range(0,num_steps):
    for ii in range(0,num_O):
        num_index=int(data_O_index[ii])
        posW_O[(num_O*i+ii),:]=Whole_traj[(i*step_lines+num_index),:]
        
np.savetxt('pos_Water_O_traj', posW_O, fmt="%s", delimiter='   ')

EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
python grab_water_O_MSD.py > python.log
rm *.py*

awk '{printf("%12.8f %12.8f %12.8f\n", $1,$2,$3)}' pos_Water_O_traj > pos_Water_O_traj_temp
rm pos_Water_O_traj

Num_lines=`wc -l pos_Water_O_traj_temp | cut -d' ' -f1`
Num_water=`echo ${Num_lines}'/'${total_numstep} | bc`

for ((aa=1; aa<=${total_numstep}; aa++))
do
  echo "Direct configuration=  $aa" >> final_Water_O_traj_temp
  start_line=`echo '('$aa'-'1')*'${Num_water}'+'1 | bc`
  end_line=`echo $aa'*'${Num_water} | bc`
  sed -n ''${start_line}','${end_line}'p' pos_Water_O_traj_temp >> final_Water_O_traj_temp
done

sed -i '6,7d' head_XDATCAR
echo "   O" >> head_XDATCAR
echo "   ${Num_water}" >> head_XDATCAR

cat head_XDATCAR final_Water_O_traj_temp > final_Water_O_traj
rm final_Water_O_traj_temp XDATCAR_final

mkdir xy_plane_MSD
mv head_XDATCAR pos_Water_O_traj_temp xy_plane_MSD
cp Submit_XY.run Grap_Water_O_Position_XYplane.sh xy_plane_MSD
