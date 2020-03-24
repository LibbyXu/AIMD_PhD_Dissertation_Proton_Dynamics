# The script we only need are the final_pos_WO from the 9.1 (first folder)
# Another file we need is the POSCAR file from the 2_split_manually_parallal 
# First we need to get the head of the script

#load the pyrhon3 environment
module load python/3.6.0

sed '8,$d' final_pos_WO > head_XDATCAR
sed '1,6d' head_XDATCAR > NUMA
sed '6,$d' POSCAR > head_XDATCAR_temp
sed '1,4d' head_XDATCAR_temp > NUMA_temp
#obtinaing the right loop files
sed '1,7d' final_pos_WO > final_pos_WO_temp

rm head_XDATCAR POSCAR head_XDATCAR_temp

#Get ride of the first 5000 steps
num_O_atoms=`awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}' NUMA`
Z_lattice=`awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}' NUMA_temp`
rm NUMA NUMA_temp

grep 'Direct' final_pos_WO_temp > line_D
total_numstep=`wc -l line_D | cut -d' ' -f1`
rm line_D

sed -i '/Direct/d' final_pos_WO_temp

#######################################################################
# Python obtain the O position for all traj
#######################################################################
cat << EOF > obtain_all_traj_four_Z_carCor.py
# load the needed python environment
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
#######################################################################
# End of the python file
#######################################################################
python obtain_all_traj_four_Z_carCor.py > python.log
rm obtain_all_traj_four_Z_carCor.py

awk '{printf("%12.8f %12.8f %12.8f %12.8f\n", $1,$2,$3,$4)}' Water_O_POS_FcaXYZ_temp > Water_O_POS_FcaXYZ
rm Water_O_POS_FcaXYZ_temp final_pos_WO final_pos_WO_temp

sort -n -k 4 Water_O_POS_FcaXYZ > Water_O_POS_FcaXYZ_sorted






























