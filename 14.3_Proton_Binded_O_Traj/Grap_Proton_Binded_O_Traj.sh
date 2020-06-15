#We need three files, the Final_Proton_index_corres from 14, the XDATCAR and POSCAR from 2

module load python/3.6.0

#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`

sed '8,$d' POSCAR > head_POSCAR
sed '1,7d' XDATCAR > split_XDAT
sed '1,6d' head_POSCAR > NUMA
rm XDATCAR

num_atoms=`awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}' NUMA`
delet_line=`echo '('${num_atoms}'+'1')*'$1 | bc`
sed -i '1,'${delet_line}'d' split_XDAT
rm NUMA head_POSCAR
grep 'Direct' split_XDAT > numlines
numline_steps=`wc -l numlines | cut -d' ' -f1`
rm numlines
echo ${numline_steps}
sed -i '/Direct/d' split_XDAT
No_Dir_file=`wc -l split_XDAT | cut -d' ' -f1`


##################################################################
# Python for the proton index
##################################################################
cat << EOF > Check_proton_corresponding_position.py
# load right python environment
import numpy as np
import math

total_proton_num=${total_proton_num}
No_Dir_file=${No_Dir_file}
numline_steps=${numline_steps}
Total_atom=${num_atoms}

check=0
if int(numline_steps*Total_atom)!=int(No_Dir_file):
    print('The file has problems! You need to check!')
    check=check+1

# 1 upper layer water layer, -1 lower water layer
if check==0:
    proton_O_index=np.genfromtxt('Final_Proton_index_corres', delimiter='') 
    traj_position=np.genfromtxt('split_XDAT', delimiter='')
    proton_pos=np.zeros(shape=(numline_steps,7*total_proton_num+1))
    proton_pos[:,0]=proton_O_index[:,0]
    for ii in range(0,total_proton_num):
        proton_pos[:,(7*ii+1):(7*ii+4)]=proton_O_index[:,(3*ii+1):(3*ii+4)]
    for i in range(0,numline_steps):
        for pp in range(0,total_proton_num):
            line=proton_O_index[i,3*pp+1]
            line_num=proton_O_index[i,0]
            proton_pos[i,(7*pp+4):(7*pp+7)]=traj_position[int((line_num-1)*Total_atom+line-1),0:3]
            if proton_pos[i,7*pp+6] > 0:
                proton_pos[i,7*pp+7]=1
            elif proton_pos[i,7*pp+6] < 0:
                proton_pos[i,7*pp+7]=-1

#Check the updated scripts
for u in range(0,total_proton_num):
    proton_temp=proton_pos[0,7*u+7]
    for uu in range(1,numline_steps):
        if proton_pos[uu,7*u+7] != proton_temp:
            print('The {}st Proton is not continues within traj. ar step {}.'.format(u+1,uu+1))

np.savetxt('Each_Proton_binded_O_position', proton_pos, fmt="%s", delimiter='   ')  

EOF
##################################################################
# End of the python file
##################################################################
python Check_proton_corresponding_position.py >> python.log
rm Check_proton_corresponding_position.py split_XDAT POSCAR 















