#!/bin/bash
# the fiels we need are Final_hydronium_O_corr and XDATCAR and POSCAR
# load needed environment
module load python/3.6.0

#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`

# reading file into arrays
numline_file=`wc -l Final_Proton_binded_O_two_list | cut -d' ' -f1`

rm XDATCAR POSCAR

awk '{printf("%6d\n",$1)}' data_proton_in_water_exact > index
paste index Final_Proton_binded_O_two_list > Final_Proton_binded_O_two_list_temp
rm Final_Proton_binded_O_two_list index
mv Final_Proton_binded_O_two_list_temp Final_Proton_binded_O_two_list

###################################################################
# Python for proton nearest O water
###################################################################
cat << EOF > Python_real_script_only_water_layer.py
# load needed python environment
import numpy as np
import math

# load data
data_file=np.genfromtxt('Final_Proton_binded_O_two_list', delimiter='')

total_proton_num=${total_proton_num}
previou_len=${numline_file}
real_proton_H_boding=np.zeros(shape=(previou_len,5))

real_row=0
for i in range(0,previou_len):
    total_surface=0
    for ii in range(0,2):
        if data_file[i,4*(ii+1)]!=0:
            total_surface=total_surface+1
            print('The step {} is the one between O from the surface and O from water, step {}!'.format(i+1,data_file[i,0]))
    if total_surface == 0:
        real_proton_H_boding[real_row,0]=data_file[i,0]
        real_proton_H_boding[real_row,1:5]=data_file[i,5:9]
        real_row=real_row+1
        
if real_row == previou_len:
    print('The real_row is {} matches tha length {} of the file.'.format(real_row,previou_len))
elif real_row != previou_len:
    print('The real row does not match the length of the file!')
    print('The real row is {}.'.format(real_row))
    print('The length of the file is {}.'.format(previou_len))

print('If we do not distinguish the proton at the surface or water layer, ther should be {} lines!'.format(15000*total_proton_num))

if real_row != previou_len:
    for ii in range(real_row,previou_len):
        real_proton_H_boding=np.delete(real_proton_H_boding,real_row,0)

np.savetxt('real_proton',real_proton_H_boding, fmt="%s", delimiter='   ')

EOF
###################################################################
# End of the python file
###################################################################
python Python_real_script_only_water_layer.py > Third_python.log
rm Python_real_script_only_water_layer.py

awk '{printf("%6d %6d %6d %12.8f %6d\n",$1,$2,$3,$4,$5)}' real_proton > Final_real_proton_H_bonding_distance
rm real_proton
sort -n -k 4 Final_real_proton_H_bonding_distance > Sorted_Final_real_proton_H_bonding_distance





