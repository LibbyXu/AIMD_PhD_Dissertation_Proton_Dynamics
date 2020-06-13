#Extracting the positions for H and protons at interfaces.  
#We need two files: POSCAR, XDATCAR from 2_Split_Manually_Data_Processing

#load the pyrhon3 environment
module load python/3.6.0

#Definition of variables
##The O index from surface 
##If the indexes have an order
H_St=`echo 125`  #you can modify
H_En=`echo 150`  #you can modify
interger_H=`echo 1`  #you can modify
echo "${H_St}" >> index_HPWater_temp
for ((i=${H_St}+${interger_H}; i<=${H_En}; i+=${interger_H}))   #i+=3
do
   echo ",$i" >> index_HPWater_temp
done
cat index_HPWater_temp | xargs > index_HP_Water
WaterHP_temp=(`echo $(grep "," index_HP_Water)`)
WaterHP=`echo ${WaterHP_temp[@]} | sed 's/ //g'`
rm index_HP_Water
##If the index does not have an order
#WaterHP=(126,131,132,135,137,140,141,143,145)

#The total number of H & proton at interfaces
num_HP=`wc -l index_HPWater_temp | cut -d' ' -f1`
rm index_HPWater_temp

#No surface O during our data analysis
SurfaceO=()
#The total number of surface-O at interfaces
IFS=', ' read -r -a num_SO <<< "${SurfaceO[@]}"
#The total number of lines (xyz-coordinate positions) for each time-step
total_HPO_line=`echo ${#num_SO[@]}'+'${num_HP} | bc`

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

##############################################
#Python interfacial H/proton position XYZ-dir#
##############################################
cat << EOF > grab_HPW_traj.py

import numpy as np
import math

step_atom = ${num_atoms}
step_lines = step_atom+1
data_SOi = [${SurfaceO[@]}]
num_SOi = ${#num_SO[@]}
data_HPWi = [${WaterHP[@]}]
num_HPWi = ${num_HP}
total_i = num_SOi+num_HPWi
num_steps = ${total_numstep}
Whole_traj = np.genfromtxt('XDATCAR_final', delimiter='')

pos_HPW=np.zeros(shape=(num_steps*total_i,3))

t=0
for i in range(0,num_steps):
    #first obtain all needed Surface O atom position
    for ii in range(0,num_SOi):
        num_index_SO=int(data_SOi[ii])
        pos_HPW[t,:]=Whole_traj[(i*step_lines+num_index_SO),:]
        t = t+1
    #Second obtain all needed proton and H from water layer position
    for iii in range(0,num_HPWi):
        num_index_HPW=int(data_HPWi[iii])
        pos_HPW[t,:]=Whole_traj[(i*step_lines+num_index_HPW),:]
        t = t+1

np.savetxt('pos_HPW', pos_HPW, fmt="%s", delimiter='   ')

EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
python grab_HPW_traj.py > python.log
rm *.py*

awk '{printf("%12.8f %12.8f %12.8f\n", $1,$2,$3)}' pos_HPW > pos_HPW_temp
mv pos_HPW_temp position_H_Proton_Water_all
rm pos_HPW head_XDATCAR XDATCAR_final
