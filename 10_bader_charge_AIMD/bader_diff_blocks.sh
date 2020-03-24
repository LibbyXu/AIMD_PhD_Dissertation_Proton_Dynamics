#We need two input scripts, the dirst is the CONTCAR nad the second is the corresponding ADF.dat (bader analysis)

#load the pyrhon3 environment
module load python/3.6.0

#Building blocks name and num atom
echo "MXeneupHalf,WaterProton,MXeneloHalf" > B_name_temp
B_name_t=(`echo $(grep "," B_name_temp)`)
B_name=`echo ${B_name_t[@]} | sed 's/,/","/g'`
B_num=(64,38,48)

rm B_name_temp
#we ge the elecment and the num of atoms inside the CONTCAR
sed '1,5d' CONTCAR > temp_CON_1
sed '2,$d' temp_CON_1 > elem
sed '1,6d' CONTCAR > temp_CON_2
sed '2,$d' temp_CON_2 > num

rm *temp_CON*

#Total Atom number
num_atoms=`awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}' num`
Element_t=(`echo $(grep " " elem)`)
Ele_num_t=(`echo $(grep " " num)`)
Element=`echo ${Element_t[@]} | sed 's/[ ][ ]*/","/g'`
Ele_num=`echo ${Ele_num_t[@]} | sed 's/[ ][ ]*/,/g'`

rm elem num
#################################################
#Python get the right element order
#################################################
cat << EOF > Right_element_order_one.py
import numpy as np
import math

num_line_right=${num_atoms}
Right_element_order_array=np.zeros(shape=(num_line_right,1))
Right_element_order=Right_element_order_array.tolist()   # array to list
Ele_num_order=[${Ele_num[@]}]
Ele_Eng=["${Element[@]}"]
len_num_ele=len(Ele_num_order)

tt=0
for i in range(0,len_num_ele):
    num_ele=Ele_num_order[i]
    for ii in range(0,num_ele):
        Right_element_order[tt]=Ele_Eng[i]
        tt=tt+1

electron_ele=np.zeros(len_num_ele)

for iii in range(0,len_num_ele):
    if Ele_Eng[iii]=="C":
        electron_ele[iii]=4
    elif Ele_Eng[iii]=="H":
        electron_ele[iii]=1
    elif Ele_Eng[iii]=="O":
        electron_ele[iii]=6
    elif Ele_Eng[iii]=="Ti":
        electron_ele[iii]=4

electron_chg_order=np.zeros(shape=(num_line_right,1))
uu=0
for a in range(0,len_num_ele):
    num_ele=Ele_num_order[a]
    ele_chg=electron_ele[a]
    for aa in range(0,num_ele):
        electron_chg_order[uu]=ele_chg
        uu=uu+1

np.savetxt("right_ele_order", Right_element_order, fmt="%s", delimiter='  ')
np.savetxt("right_chg_order", electron_chg_order, fmt="%s", delimiter='  ')
EOF
#################################################
#End of the first python file
#################################################
python Right_element_order_one.py > First_py.log

paste right_ele_order right_chg_order > ele_chg
rm right_ele_order right_chg_order Right_element_order_one.py

sed "1,2d" ACF.dat > Coor_CHG
for((i=1;i<=4;i++)); 
do 
sed -i '$d' Coor_CHG 
done 

awk '{printf("%4d %15.8f %15.8f %15.8f %15.8f\n",$1, $2, $3, $4, $5)}' Coor_CHG > Coor_CHG_order

paste ele_chg Coor_CHG_order > ele_coor_chg_temp
rm Coor_CHG Coor_CHG_order ele_chg

#Next we need to get the exact charge
awk '{printf("%4s %4s %15.8f %15.8f %15.8f %15.8f\n", $3, $1, $2 - $7, $4, $5, $6);}' ele_coor_chg_temp > ele_coor_chg
sort -n -k6 ele_coor_chg > ele_coor_chg_as
rm ele_coor_chg_temp ele_coor_chg


#################################################
#Python bader charge analysis
#################################################
cat << EOF > bader_charge_analysis_building_blocks.py
import numpy as np
import math

charge_coor = np.genfromtxt('ele_coor_chg_as', delimiter='')
Building_num_each = [${B_num[@]}]
Building_name = ["${B_name[@]}"]

num_Build = len(Building_num_each)
charge_sum_file = np.zeros(shape=(num_Build,1))

for nn in range(0,num_Build):
    num_Bblock = Building_num_each[nn]
    charge_sum_order = np.zeros(shape=(num_Bblock,1))
    for ss in range(0,num_Bblock):
        start_num=0
        if nn!=0:
             for y in range(0,nn):
                 start_num=Building_num_each[y]+start_num
        charge_sum_order[ss]=charge_coor[start_num+ss,2]
    charge_sum=sum(charge_sum_order)
    print('\nBuilding block is {} and the number of atom inside is {}:'.format(Building_name[nn],Building_num_each[nn]))
    print('The corresponding charge for that building block is {}.'.format(charge_sum))
    charge_sum_file[nn]=charge_sum

np.savetxt("Charge_building_block_temp", charge_sum_file, fmt="%s", delimiter='  ')
EOF
#################################################
#End of the second python file
#################################################
python bader_charge_analysis_building_blocks.py > Second_py.log
awk '{printf("%15.8f\n",$1)}' Charge_building_block_temp > Charge_building_block

rm bader_charge_analysis_building_blocks.py ele_coor_chg_as Charge_building_block_temp


