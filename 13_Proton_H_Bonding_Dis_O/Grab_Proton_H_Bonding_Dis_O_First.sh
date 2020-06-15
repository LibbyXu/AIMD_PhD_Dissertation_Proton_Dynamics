# We need files: Final_hydronium_O_corr from Ratio_OH_Water_in_H2O_No_Hydro_2_1 in 11_Possibility_OH_Bond_Alinement, [XDATCAR, POSCAR] from 2_Split_Manually_Data_Processing

# load needed environment
module load python/3.6.0

#Definition of variables
#The number of protons in the system
total_proton_num=`echo 2`

#Definition of variables
##The O index from water 
##If the indexes have an order
WO_St=`echo 65`
WO_En=`echo 76`
interger_WO=`echo 1`
echo "${WO_St}" >> index_WO_temp
for ((i=${WO_St}+${interger_WO}; i<=${WO_En}; i+=${interger_WO}))   #i+
do
  echo ",$i" >> index_WO_temp
done
cat index_WO_temp | xargs > index_WO
WO_temp=(`echo $(grep "," index_WO)`)
WaterO=`echo ${WO_temp[@]} | sed 's/ //g'`
IFS=', ' read -r -a num_WO <<< "${WaterO[@]}"
rm index_WO index_WO_temp
##If the index does not have an order
#WaterO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)

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
delet_line=`echo '('${num_atoms}'+'1')*'5000 | bc`
sed -i '1,'${delet_line}'d' split_XDAT
cat head_POSCAR split_XDAT > XDATCAR
rm NUMA head_POSCAR

grep 'Direct' split_XDAT > numlines
numline_steps=`wc -l numlines | cut -d' ' -f1`
rm numlines
echo ${numline_steps}
rm split_XDAT

##############
#Python codes#
##############
cat << EOF > Proton_water_corresponding_each_step.py

import numpy as np
import math

water_proton_data = np.genfromtxt('Final_hydronium_O_corr', delimiter='')
num_WO = ${#num_WO[@]}
num_true_steps=${numline_steps}
total_proton_number=${total_proton_num}

file_length=len(water_proton_data)

if num_true_steps != int(file_length/num_WO):
    print('The true water O num does not mathc the records!')

data_proton_waterL=np.zeros(shape=(num_true_steps*total_proton_number,7))

line_row=0
for i in range(0,num_true_steps):
    for ii in range(0,num_WO):
        if water_proton_data[num_WO*i+ii,0]!=0:
            data_proton_waterL[line_row,0]=i+1
            data_proton_waterL[line_row,1:3]=water_proton_data[num_WO*i+ii,0:2]
            data_proton_waterL[line_row,3:5]=water_proton_data[num_WO*i+ii,5:7]
            data_proton_waterL[line_row,5:7]=water_proton_data[num_WO*i+ii,10:12]
            line_row=line_row+1

for iii in range(line_row,num_true_steps*total_proton_number):
    data_proton_waterL=np.delete(data_proton_waterL,line_row,0)    

for iiii in range(0,line_row):
    if data_proton_waterL[iiii,2]<data_proton_waterL[iiii,4] and data_proton_waterL[iiii,4]<data_proton_waterL[iiii,6]:
        continue
    else:
        print('The H distance order does not match at the step {}'.format(iiii+1))

np.savetxt('data_proton_in_water_selection_temp', data_proton_waterL, fmt="%s", delimiter='   ')

EOF
################### 
#End of the python# 
################### 

#############################
#Linux data processing codes#
#############################
python Proton_water_corresponding_each_step.py >> First_python.log
rm Proton_water_corresponding_each_step.py

awk '{printf("%8d %6d %12.8f %6d %12.8f %6d %12.8f\n", $1,$2,$3,$4,$5,$6,$7)}' data_proton_in_water_selection_temp > data_proton_in_water_selection
rm data_proton_in_water_selection_temp

awk '{printf("%8d %6d %12.8f\n", $1,$6,$7)}' data_proton_in_water_selection > data_proton_in_water_exact
awk '{printf("%8d %6d %12.8f\n", $1,$6,$7)}' data_proton_in_water_selection > temp
rm Final_hydronium_O_corr
