#In this script, we need two files, the first is the whole XDATCAR and the second is the corresponding POSCAR

#load the pyrhon3 environment
module load python/3.6.0

#Definition of variables
SurfaceO=()

#For the index of proton or H in water layer
#if the index has an order
H_St=`echo 125`
H_En=`echo 150`
interger_H=`echo 1`
echo "${H_St}" >> index_HPWater_temp
for ((i=${H_St}+${interger_H}; i<=${H_En}; i+=${interger_H}))   #i+=3
do
   echo ",$i" >> index_HPWater_temp
done
cat index_HPWater_temp | xargs > index_HP_Water
WaterHP_temp=(`echo $(grep "," index_HP_Water)`)
WaterHP=`echo ${WaterHP_temp[@]} | sed 's/ //g'`
rm index_HP_Water

#We could know the number of the H and proton inside water layer
num_HP=`wc -l index_HPWater_temp | cut -d' ' -f1`
rm index_HPWater_temp
#We could also know the # of O at the interfacial surface
IFS=', ' read -r -a num_SO <<< "${SurfaceO[@]}"
#Total num lines (xyz) writen in each step
total_HPO_line=`echo ${#num_SO[@]}'+'${num_HP} | bc`

#First we need to get the head of the script
sed '8,$d' POSCAR > head_XDATCAR
sed '1,6d' head_XDATCAR > NUMA
#obtinaing the right loop files
sed '1,7d' XDATCAR > XDATCAR_final

rm XDATCAR POSCAR

#Get ride of the first 5000 steps
num_atoms=`awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}' NUMA`
delet_line=`echo '('${num_atoms}'+'1')*'$1 | bc`
sed -i '1,'${delet_line}'d' XDATCAR_final
rm NUMA

grep 'Direct' XDATCAR_final > line_D
total_numstep=`wc -l line_D | cut -d' ' -f1`
rm line_D

########################################################################################################################
# Python dealing with the O position in list for MSD
########################################################################################################################
cat << EOF > grab_SO_HPW_traj.py
#interfacial surface O and proton/H from water position traj
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

pos_SO_HPW=np.zeros(shape=(num_steps*total_i,3))

t=0
for i in range(0,num_steps):
    #first obtain all needed Surface O atom position
    for ii in range(0,num_SOi):
        num_index_SO=int(data_SOi[ii])
        pos_SO_HPW[t,:]=Whole_traj[(i*step_lines+num_index_SO),:]
        t = t+1
    #Second obtain all needed proton and H from water layer position
    for iii in range(0,num_HPWi):
        num_index_HPW=int(data_HPWi[iii])
        pos_SO_HPW[t,:]=Whole_traj[(i*step_lines+num_index_HPW),:]
        t = t+1

np.savetxt('pos_SO_HPW', pos_SO_HPW, fmt="%s", delimiter='   ')

EOF
########################################################################################################################
# End of the python file
########################################################################################################################
python grab_SO_HPW_traj.py > python.log
rm *.py*

awk '{printf("%12.8f %12.8f %12.8f\n", $1,$2,$3)}' pos_SO_HPW > pos_SO_HPW_temp
rm pos_SO_HPW

mv pos_SO_HPW_temp position_H_all

