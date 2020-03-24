#In this script, we need two files, the first is the whole XDATCAR and the second is the corresponding POSCAR

#load the pyrhon3 environment
module load python/3.6.0

#Definition of variables
#The O index at interfaical surface

SO_St=`echo 33`
SO_En=`echo 64`
interger_SO=`echo 1`
echo "${SO_St}" >> index_SO_temp
for ((i=${SO_St}+${interger_SO}; i<=${SO_En}; i+=${interger_SO}))
do
echo ",$i" >> index_SO_temp
done
cat index_SO_temp | xargs > index_SO
SO_temp=(`echo $(grep "," index_SO)`)
SurfaceO=`echo ${SO_temp[@]} | sed 's/ //g'`
rm index_SO index_SO_temp
#SurfaceO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)

WO_St=`echo 65`
WO_En=`echo 76`
interger_WO=`echo 1`
echo "${WO_St}" >> index_WO_temp
for ((i=${WO_St}+${interger_WO}; i<=${WO_En}; i+=${interger_WO}))
do
echo ",$i" >> index_WO_temp
done
cat index_WO_temp | xargs > index_WO
WO_temp=(`echo $(grep "," index_WO)`)
WaterO=`echo ${WO_temp[@]} | sed 's/ //g'`
rm index_WO index_WO_temp


#We could also know the # of O at the interfacial surface and Water
IFS=', ' read -r -a num_SO <<< "${SurfaceO[@]}"
IFS=', ' read -r -a num_WO <<< "${WaterO[@]}"
#Total num lines (xyz) writen in each step
total_O_line=`echo ${#num_SO[@]}'+'${#num_WO[@]} | bc`

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
cat << EOF > grab_allO_SW_traj.py
#interfacial surface O and proton/H from water position traj
import numpy as np
import math

step_atom = ${num_atoms}
step_lines = step_atom+1
data_SOi = [${SurfaceO[@]}]
num_SOi = ${#num_SO[@]}

data_WOi = [${WaterO[@]}]
num_WOi = ${#num_WO[@]}
total_i = num_SOi+num_WOi
num_steps = ${total_numstep}
Whole_traj = np.genfromtxt('XDATCAR_final', delimiter='')

pos_SO_WO=np.zeros(shape=(num_steps*total_i,3))

t=0
for i in range(0,num_steps):
    #first obtain all needed Surface O atom position
    for ii in range(0,num_SOi):
        num_index_SO=int(data_SOi[ii])
        pos_SO_WO[t,:]=Whole_traj[(i*step_lines+num_index_SO),:]
        t = t+1
    #Second obtain all needed proton and H from water layer position
    for iii in range(0,num_WOi):
        num_index_WO=int(data_WOi[iii])
        pos_SO_WO[t,:]=Whole_traj[(i*step_lines+num_index_WO),:]
        t = t+1

np.savetxt('pos_SO_WO', pos_SO_WO, fmt="%s", delimiter='   ')

EOF
########################################################################################################################
# End of the python file
########################################################################################################################
python grab_allO_SW_traj.py > python.log
rm *.py*

awk '{printf("%12.8f %12.8f %12.8f\n", $1,$2,$3)}' pos_SO_WO > pos_SO_WO_temp
rm pos_SO_WO

for ((aa=1; aa<=${total_numstep}; aa++))
do
    echo "Direct configuration=  $aa" >> final_pos_SO_WO_temp
    start_line=`echo '('$aa'-'1')*'${total_O_line}'+'1 | bc`
    end_line=`echo $aa'*'${total_O_line} | bc`
    sed -n ''${start_line}','${end_line}'p' pos_SO_WO_temp >> final_pos_SO_WO_temp
done

sed -i '6,7d' head_XDATCAR
echo "   S   W" >> head_XDATCAR
echo "   ${#num_SO[@]}   ${#num_WO[@]}" >> head_XDATCAR

cat head_XDATCAR final_pos_SO_WO_temp > final_pos_SO_WO
rm final_pos_SO_WO_temp XDATCAR_final head_XDATCAR pos_SO_WO_temp

