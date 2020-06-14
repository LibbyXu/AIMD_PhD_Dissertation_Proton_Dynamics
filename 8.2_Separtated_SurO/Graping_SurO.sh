#Extracting the positions for surface-O at interfaces.  
#We need two files: POSCAR, XDATCAR from 2_Split_Manually_Data_Processing

#load the Python3 environment
module load python/3.6.0

#Definition of variables
##The surface-O index at interfaces
##If the indexes have an order
SO_St=`echo 30`  #you can modify
SO_En=`echo 65`  #you can modify
interger_SO=`echo 1`  #you can modify
echo "${SO_St}" >> index_SO_temp
for ((i=${SO_St}+${interger_SO}; i<=${SO_En}; i+=${interger_SO}))   #i+
do
  echo ",$i" >> index_SO_temp
done
cat index_SO_temp | xargs > index_SO
SO_temp=(`echo $(grep "," index_SO)`)
SurfaceO=`echo ${SO_temp[@]} | sed 's/ //g'`
rm index_SO index_SO_temp
##If the index does not have an order
#SurfaceO=(126,131,132,135,137,140,141,143,145)

#No H/proton during our data analysis
WaterHP=()
#The total number of H/proton at interfaces
num_HP=`echo 0`
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

###############################################
#Python interfacial Surface-O position XYZ-dir#
###############################################
cat << EOF > grab_SO_traj.py

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

pos_SO=np.zeros(shape=(num_steps*total_i,3))

t=0
for i in range(0,num_steps):
    #first obtain all needed Surface-O atom position
    for ii in range(0,num_SOi):
        num_index_SO=int(data_SOi[ii])
        pos_SO[t,:]=Whole_traj[(i*step_lines+num_index_SO),:]
        t = t+1
    #Second obtain all needed proton & H from water layer position
    for iii in range(0,num_HPWi):
        num_index_HPW=int(data_HPWi[iii])
        pos_SO[t,:]=Whole_traj[(i*step_lines+num_index_HPW),:]
        t = t+1

np.savetxt('pos_SO', pos_SO, fmt="%s", delimiter='   ')

EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
python grab_SO_traj.py > python.log
rm *.py*

awk '{printf("%12.8f %12.8f %12.8f\n", $1,$2,$3)}' pos_SO > pos_SO_temp
mv pos_SO_temp position_Surface_O_all
rm pos_SO XDATCAR_final head_XDATCAR 
