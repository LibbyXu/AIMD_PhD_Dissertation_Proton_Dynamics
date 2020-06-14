#Separated & Averaged Bader charge and Standard deviation for different building blocks
#We need the all folder with the initial character "AIMD_bader_#"
#Inside each "AIMD_bader_#" folder: we need to have 

#load the Python3 environment
module load python/3.6.0

#Definition of variables
##Building blocks name and Num of atoms for each Building block
echo "MxeneloHalf,WaterProtonLo,MXeneupHalf" > B_name_temp #Name for each building block, you can modify
B_name_t=(`echo $(grep "," B_name_temp)`)
B_name=`echo ${B_name_t[@]} | sed 's/,/","/g'`
ls -l  > num_file
grep "AIMD_bader_" num_file > file_bader
Num_file_bader=`wc -l file_bader | cut -d' ' -f1`
rm num_file file_bader B_name_temp

#Making the folders
mkdir First_Python
mkdir Result_Python
mkdir Bader_Final
mkdir Slurm_all

#Put the needed files into the current folder(Production part)
for ((a=1;a<=${Num_file_bader};a++))
do 
  cd AIMD_bader_$a
  cp First_py.log First_py.log_$a
  cp Result_py.log Result_py.log_$a
  cp Charge_building_block Charge_building_block_$a
  cp *slurm* slurm_$a
  mv First_py.log_$a ../First_Python
  mv Result_py.log_$a ../Result_Python
  mv Charge_building_block_$a ../Bader_Final
  mv slurm_$a ../Slurm_all
  cd ..
done

#Dealing with the data in Bader_Final folder
cd Bader_Final
touch Final_bader_building_blocks
for ((bb=1;bb<=${Num_file_bader};bb++))
do
  paste Final_bader_building_blocks Charge_building_block_$bb > Final_bader_building_blocks_temp
  mv Final_bader_building_blocks_temp Final_bader_building_blocks
done
rm *Charge_building_block_*

################################################
#Python get charge for different building block#
################################################
cat << EOF > element_name.py

import numpy as np
import math

Ele_Eng=["${B_name[@]}"]
len_num_ele=len(Ele_Eng)
charge_B_blocks_temp=np.zeros(shape=(len_num_ele,1))
charge_B_blocks=charge_B_blocks_temp.tolist()

for i in range(0,len_num_ele):
    charge_B_blocks[i]=Ele_Eng[i]

np.savetxt("charge_name_B_blocks", charge_B_blocks, fmt="%s", delimiter='  ')

all_b_charge = np.genfromtxt('Final_bader_building_blocks', delimiter='')
row_num = len(all_b_charge)
column_num = len(all_b_charge[0])
average_charge_B = np.zeros(shape=(row_num,2))

for kk in range(0,row_num):
    average_charge_B[kk,0] = (sum(all_b_charge[kk,:]))/column_num
    average_charge_B[kk,1] = np.std(all_b_charge[kk,:])

np.savetxt("Average_Charge_Block", average_charge_B, fmt="%s", delimiter='  ')

EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
python element_name.py
awk '{printf("%s\n",$1)}' charge_name_B_blocks > charge_name_B_blocks_temp
awk '{printf("%15.8f %15.8f\n",$1,$2)}' Average_Charge_Block > final_average_temp
rm element_name.py

paste charge_name_B_blocks_temp Final_bader_building_blocks > Final_bader_diff_blocks_temp
paste charge_name_B_blocks_temp final_average_temp > Average_bader_charge_blocks_temp
rm Final_bader_building_blocks charge_name_B_blocks charge_name_B_blocks_temp final_average_temp Average_Charge_Block

awk '{printf("%15.13s %10.7f %10.7f %10.7f %10.7f %10.7f %10.7f %10.7f %10.7f %10.7f %10.7f\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)}' Final_bader_diff_blocks_temp > Final_bader_diff_blocks
awk '{printf("%15.13s %10.7f %10.7f\n",$1,$2,$3)}' Average_bader_charge_blocks_temp > Average_bader_charge_blocks
rm Average_bader_charge_blocks_temp Final_bader_diff_blocks_temp
cd ..
