# We need files: Final_hydronium_O_corr from Ratio_OH_Water_in_H2O_No_Hydro_2_1 in 11_Possibility_OH_Bond_Alinement, [XDATCAR, POSCAR] from 2_Split_Manually_Data_Processing

# load needed environment
module load python/3.6.0

#Definition of variables
#The number of protons in the system
total_proton_num=`echo 2`  #You can modify.

#Reading file into arrays
numline_file=`wc -l data_proton_in_water_exact | cut -d' ' -f1`

##The O index from water 
##If the indexes have an order
WO_St=`echo 65`  #You can modify.
WO_En=`echo 76`  #You can modify.
interger_WO=`echo 1`  #You can modify.
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
#WaterO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)

##The O index from Surface
##If the indexes have an order
SO_St=`echo 33`  #You can modify.
SO_En=`echo 64`  #You can modify.
interger_SO=`echo 1`  #You can modify.
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
#SurfaceO=(83,85,109,111,113)

################################
#Python, proton nearest O water#
################################
cat << EOF > Python_proton_nearest_O_water.py

import numpy as np
import math

#Define the index num for the O in water and Surface
Surface_O_index=[${SurfaceO[@]}]
Water_O_index=[${WaterO[@]}]

#Load data
Proton_H_temp_list = np.genfromtxt('Proton_temp_list', delimiter='')

index_order = Proton_H_temp_list[:,0]
atom_index_distance = Proton_H_temp_list[:,1:3]

# total len_step lines, but first is the index for the H in calculation
len_step = len(index_order)
proton_corres_index = atom_index_distance[0,0]

#Surface O-1, wATER O-0
result_proton_binded_O=np.zeros(shape=(2,4))

O_num=0
for i in range(1,len_step):
    if atom_index_distance[i,0] in Surface_O_index:
        result_proton_binded_O[O_num,0]=int(proton_corres_index)
        result_proton_binded_O[O_num,1:3]=atom_index_distance[i,0:2]
        result_proton_binded_O[O_num,3]=1
        O_num=O_num+1
    elif atom_index_distance[i,0] in Water_O_index:
        result_proton_binded_O[O_num,0]=int(proton_corres_index)
        result_proton_binded_O[O_num,1:3]=atom_index_distance[i,0:2]
        result_proton_binded_O[O_num,3]=0
        O_num=O_num+1        
    if O_num == 2:
        break

np.savetxt("corres_two_O", result_proton_binded_O, fmt="%s", delimiter='  ')

EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
touch Proton_binded_O_two_list
for ((i=1; i<=${numline_file}; i+=1))
#for ((i=1; i<=1; i+=1))
do
  read -a arr < temp
  step=`echo ${arr[0]}`
  proton_Hi=`echo ${arr[1]}`
  xdat2pos.pl 1 ${step}
  mv POSCAR${step}.out CONTCAR
  neighbors.pl CONTCAR ${proton_Hi}
  awk '{printf("%4d %4d %15.8f %15.8f %15.8f %15.8f\n",$1, $2, $7, $3, $4, $5)}' neighdist.dat > Proton_temp_list
  sed -i '6,$d' Proton_temp_list
  python Python_proton_nearest_O_water.py >> Second_python.log
  cat Proton_binded_O_two_list corres_two_O >>  Proton_binded_O_two_list_temp
  mv Proton_binded_O_two_list_temp Proton_binded_O_two_list
  rm Proton_temp_list neighdist.dat corres_two_O CONTCAR
  sed -i '1d' temp
done
rm temp Python_proton_nearest_O_water.py

awk '{printf("%6d %6d %15.8f %4d\n", $1, $2, $3, $4)}' Proton_binded_O_two_list > Final_Proton_binded_O_two_list
rm Proton_binded_O_two_list
awk 'ORS=NR%2?" ":"\n"{print}' Final_Proton_binded_O_two_list > Final_Proton_binded_O_two_list_t
mv Final_Proton_binded_O_two_list_t Final_Proton_binded_O_two_list
