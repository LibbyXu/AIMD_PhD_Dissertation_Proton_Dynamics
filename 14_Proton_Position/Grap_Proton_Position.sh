#Obtain the proton positions (XYZ)
#We need files: [XDATCAR, POSCAR] from 2_Split_Manually_Data_Processing, [Final_proton_bonded_O_reorder_list_Final, Final_proton_bonded_O_nearest_three_H_list_Final] from 4_Reordering_O_H_List

# load needed environment
module load python/3.6.0

#Definition of variables
##Number of the protons  
total_proton_num=`echo 2` #You can modify

#Some data preparations
##without Selective option when doing AIMD using VASP
sed '8,$d' POSCAR > head_POSCAR
sed '1,6d' head_POSCAR > NUMA
##with Selective option when doing AIMD using VASP
#sed '9,$d' POSCAR > head_XDAT
#sed '1,6d' head_XDAT > NUMA

#obtinaing the right loop files
sed '1,7d' XDATCAR > split_XDAT
rm XDATCAR

#Obatin the last $1 of steps
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

#########################
#Python for proton index#
#########################
cat << EOF > Check_proton_position_files.py

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
    
if check==0:
    H_to_proton_index=np.genfromtxt('Final_proton_bonded_O_nearest_three_H_list_Final', delimiter='')
    proton_O_index=np.genfromtxt('Final_proton_bonded_O_reorder_list_Final', delimiter='')
    for i in range(0,numline_steps):
        for ii in range(0,total_proton_num):
            cc=0
            if H_to_proton_index[i,6*ii+2]>H_to_proton_index[i,6*ii+4] and H_to_proton_index[i,6*ii+2]>H_to_proton_index[i,6*ii+6]:
                cc=1
            if cc==0:
                print('The order of the H distance are wrong for step {}, the {} proton number!'.format(i+1,ii+1))
    proton_index=np.zeros(shape=(numline_steps,3*total_proton_num+1))
    proton_index[:,0]=H_to_proton_index[:,0]
    for iii in range(0,total_proton_num):
        proton_index[:,(3*iii+2):(3*iii+4)]=H_to_proton_index[:,(6*iii+1):(6*iii+3)]
    unique_index=np.zeros(total_proton_num)
    for oo in range(0,numline_steps):
        for oi in range(0,total_proton_num):
            unique_index[oi]=proton_index[oo,3*oi+2]
        num_value=np.unique(unique_index)
        if len(num_value)!=total_proton_num:
            print('The proton check has some problem at step {}.'.format(oo+1))
    for f in range(0,total_proton_num):
        proton_index[:,3*f+1]=proton_O_index[:,f+1]
        
np.savetxt('Proton_index_corres', proton_index, fmt="%s", delimiter='   ')            

EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
python Check_proton_position_files.py >> Python.log
rm Final_proton_bonded_O_nearest_three_H_list_Final Final_proton_bonded_O_reorder_list_Final Check_proton_position_files.py

awk '{printf("%6d\n",$1)}' Proton_index_corres > first_column_index
touch Final_Proton_index_corres
for ((i=1;i<=${total_proton_num};i+=1))
do
  awk '{printf("%6d %6d %12.8f\n",$(3*('${i}'-1)+2),$(3*('${i}'-1)+3),$(3*('${i}'-1)+4))}' Proton_index_corres > temp_p
  paste Final_Proton_index_corres temp_p > Final_Proton_index_corres_temp
  mv Final_Proton_index_corres_temp Final_Proton_index_corres
  rm temp_p
done

paste first_column_index Final_Proton_index_corres > Final_Proton_index_corres_right
mv Final_Proton_index_corres_right Final_Proton_index_corres
rm first_column_index POSCAR Proton_index_corres

##########################################
#Python for the proton position each step#
##########################################
cat << EOF > Position_Protons.py

import numpy as np
import math

all_traj_position=np.genfromtxt('split_XDAT', delimiter='')
index_proton=np.genfromtxt('Final_Proton_index_corres', delimiter='')

total_proton_num=${total_proton_num}
len_file=len(index_proton)
total_atom_num=${num_atoms}

position_proton=np.zeros(shape=(len_file*total_proton_num,6))

line_file=0
for i in range(0,len_file):
    for ii in range(0,total_proton_num):
        position_proton[line_file,0]=index_proton[i,0]
        position_proton[line_file,1:3]=index_proton[i,(3*ii+1):(3*ii+3)]
        right_line=int(total_atom_num*(index_proton[i,0]-1)+index_proton[i,3*ii+2]-1)
        position_proton[line_file,3:6]=all_traj_position[right_line,0:3]
        line_file=line_file+1

if line_file!=int(total_proton_num*len_file):
    print('The files have some problems! the length does not match each other!')
        
np.savetxt('Proton_position', position_proton, fmt="%s", delimiter='   ')  

EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
python Position_Protons.py  >>  Python.log
rm Position_Protons.py

awk '{printf("%8d %6d %6d %12.8f %12.8f %12.8f\n",$1,$2,$3,$4,$5,$6)}' Proton_position > Final_Proton_position
rm Proton_position split_XDAT
