#Only extract the path of the water-O from interfaces
#We need two files: POSCAR, XDATCAR from 2_Split_Manually_Data_Processing

#load the pyrhon3 environment
module load python/3.6.0

#Definition of variables
##The O index from Water 
##If the indexes have an order
WO_St=`echo 65`  #you can modify
WO_En=`echo 76`  #you can modify
interger_WO=`echo 1`  #you can modify
echo "${WO_St}" >> index_WO_temp
for ((i=${WO_St}+${interger_WO}; i<=${WO_En}; i+=${interger_WO}))   #i+
do
  echo ",$i" >> index_WO_temp
done
cat index_WO_temp | xargs > index_WO
WO_temp=(`echo $(grep "," index_WO)`)
WaterO=`echo ${WO_temp[@]} | sed 's/ //g'`
rm index_WO index_WO_temp
##If the index does not have an order
#WaterO=(65,68,71,72,74)

#The total number of Water-O at interfaces
IFS=', ' read -r -a num_WO <<< "${WaterO[@]}"
#The total number of lines (xyz-coordinate positions) for each time-step
total_O_line=`echo ${#num_WO[@]}`

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
cat << EOF > grab_all_WO_traj.py

import numpy as np
import math

step_atom = ${num_atoms}
step_lines = step_atom+1

data_WOi = [${WaterO[@]}]
num_WOi = ${#num_WO[@]}

total_i = num_WOi
num_steps = ${total_numstep}
Whole_traj = np.genfromtxt('XDATCAR_final', delimiter='')

pos_SO_WO=np.zeros(shape=(num_steps*total_i,3))

t=0
for i in range(0,num_steps):
    #Second obtain all needed proton and H from water layer position
    for iii in range(0,num_WOi):
        num_index_WO=int(data_WOi[iii])
        pos_SO_WO[t,:]=Whole_traj[(i*step_lines+num_index_WO),:]
        t = t+1

np.savetxt('pos_WO', pos_SO_WO, fmt="%s", delimiter='   ')

EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
python grab_all_WO_traj.py > python.log
rm *.py*

awk '{printf("%12.8f %12.8f %12.8f\n", $1,$2,$3)}' pos_WO > pos_WO_temp
rm pos_WO

for ((aa=1; aa<=${total_numstep}; aa++))
do
  echo "Direct configuration=  $aa" >> final_pos_WO_temp
  start_line=`echo '('$aa'-'1')*'${total_O_line}'+'1 | bc`
  end_line=`echo $aa'*'${total_O_line} | bc`
  sed -n ''${start_line}','${end_line}'p' pos_WO_temp >> final_pos_WO_temp
done

sed -i '6,7d' head_XDATCAR
echo "   O" >> head_XDATCAR #Surface O and Water O
echo "   ${#num_WO[@]}   " >> head_XDATCAR

cat head_XDATCAR final_pos_WO_temp > final_pos_WO
rm final_pos_WO_temp XDATCAR_final head_XDATCAR pos_WO_temp
