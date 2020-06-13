# Combined the Water-O positions fpr every step along the whole trajectories
# We need two files file: final_pos_WO from the 9.1_RDF_Water_O, and POSCAR from 2_Split_Manually_Data_Processing

#load the pyrhon3 environment
module load python/3.6.0

#Some data preparations
##without Selective option when doing AIMD using VASP
sed '8,$d' final_pos_WO > head_XDATCAR
sed '1,6d' head_XDATCAR > NUMA
sed '6,$d' POSCAR > head_XDATCAR_temp
sed '1,4d' head_XDATCAR_temp > NUMA_temp
##with Selective option when doing AIMD using VASP
#sed '9,$d' POSCAR > head_XDAT
#sed '1,6d' head_XDAT > NUMA
#sed '6,$d' POSCAR > head_XDATCAR_temp
#sed '1,4d' head_XDATCAR_temp > NUMA_temp

#obtinaing the right loop files
sed '1,7d' final_pos_WO > final_pos_WO_temp
rm head_XDATCAR POSCAR head_XDATCAR_temp

#Obatin the last $1 of steps
num_O_atoms=`awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}' NUMA`
Z_lattice=`awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}' NUMA_temp`
rm NUMA NUMA_temp

grep 'Direct' final_pos_WO_temp > line_D
total_numstep=`wc -l line_D | cut -d' ' -f1`
rm line_D

sed -i '/Direct/d' final_pos_WO_temp

###############################################
#Python obtain Water-O positions from all traj#
###############################################
cat << EOF > obtain_all_traj_four_Z_carCor.py

import numpy as np
import math

# load the needed file
data_position_O_WATER=np.genfromtxt('final_pos_WO_temp', delimiter='')

step_from_traj=${total_numstep}
Z_laVal=${Z_lattice}
water_O_num=${num_O_atoms}
len_file = len(data_position_O_WATER)

if int(step_from_traj)!=int(len_file/water_O_num):
    print('The # of the step does not match the real one!')

real_Water_O=np.zeros(shape=(len_file,4))
real_Water_O[:,0:3]=data_position_O_WATER[:,0:3]
real_Water_O[:,3]=data_position_O_WATER[:,2]*Z_laVal

np.savetxt('Water_O_POS_FcaXYZ_temp', real_Water_O, fmt="%s", delimiter='   ')

EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
python obtain_all_traj_four_Z_carCor.py > python.log
rm obtain_all_traj_four_Z_carCor.py

awk '{printf("%12.8f %12.8f %12.8f %12.8f\n", $1,$2,$3,$4)}' Water_O_POS_Z_temp > Water_O_POS_Z
rm Water_O_POS_Z_temp final_pos_WO final_pos_WO_temp

#Sort the Water-O positions (Z-dir. position) for the latter calculations on the O density along Z-dir.
sort -n -k 4 Water_O_POS_Z > Water_O_POS_Z_sorted
