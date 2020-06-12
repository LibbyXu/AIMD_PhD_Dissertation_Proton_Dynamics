#Please give the path to the folder or you can comment ths following line and use this in the current folder
#cd /rhome/lxu013/bigdata/Projects/AIMD_MXene_graphene/AIMD_MXene_G/C_layer_optimization/scripts/grapping_protons_script/test_results

#For this work, we need two files, the first is the POSCAR, and the second is the XDATACAR file

#load the pyrhon3 environment
module load python/3.6.0

#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`
#Define the index num for the O in water and Surface, if your index has certain order, you cam create a loop
SO_St=`echo 33`
SO_En=`echo 64`
interger_SO=`echo 1`
echo "${SO_St}" >> index_SO_temp
for ((i=${SO_St}+${interger_SO}; i<=${SO_En}; i+=${interger_SO}))   #i+
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
for ((i=${WO_St}+${interger_WO}; i<=${WO_En}; i+=${interger_WO}))   #i+
do
echo ",$i" >> index_WO_temp
done
cat index_WO_temp | xargs > index_WO
WO_temp=(`echo $(grep "," index_WO)`)
WaterO=`echo ${WO_temp[@]} | sed 's/ //g'`
rm index_WO index_WO_temp
#WaterO=(115,116,117,118,119,120,121,122,123,124,125,126)

#The first index num of H
First_H_index=`echo 125`
#How many steps included in the current XDATCAR file
num_XDATCAR=`echo 500`

#Some other variables that is convenient to use
num_water=`echo ${WaterO[0]} | awk -F "," '{print NF}'`
Final_H_index=`echo ${First_H_index}'+'2'*'${num_water}'+'${total_proton_num}'-'1 | bc`


########################################################################################################################
# Python dealing with the atom list, finding the most nearest two O atoms for the corresponding H
########################################################################################################################
cat << EOF > Python_getting_twoO_distance_one.py
import numpy as np
import math

# Define the index num for the O in water and Surface
Surface_O_index=[${SurfaceO[@]}]
Water_O_index=[${WaterO[@]}]

# Load data
data_H_temp_list = np.genfromtxt('H_temp_list', delimiter='')

index_order = data_H_temp_list[:,0]
atom_index_distance = data_H_temp_list[:,1:3]
atom_index_position = data_H_temp_list[:,3:7]

# total len_step lines, but first is the index for the H in calculation 
len_step = len(index_order)
H_corres_index = atom_index_distance[0,0]
H_corres_position = atom_index_position[0,:]

# Finding the corresponding two nearest O atom
# Surface O: 1; Water O: 2
# create a array that the O index, distance, position, Surface or water O

Two_O_connected = np.zeros(shape=((len_step-1),7))
ii = 0
for i in range(1,len_step):
    temp_one = int(atom_index_distance[i,0])
    if temp_one in Surface_O_index:
        Two_O_connected[ii,0] = H_corres_index
        Two_O_connected[ii,1:3] = atom_index_distance[i,:]
        Two_O_connected[ii,3:6] = atom_index_position[i,:]
        Two_O_connected[ii,6] = 0
        ii = ii+1
    elif temp_one in Water_O_index:
        Two_O_connected[ii,0] = H_corres_index
        Two_O_connected[ii,1:3] = atom_index_distance[i,:]
        Two_O_connected[ii,3:6] = atom_index_position[i,:]
        Two_O_connected[ii,6] = 1
        ii = ii+1

# Save the Two_O_connected matrix into an '.dat' file
np.savetxt("all_O_list", Two_O_connected, fmt="%s", delimiter='  ')
EOF
##################################################################################################################
#First Python script end
##################################################################################################################

##################################################################################################################
#dealing with finding the appropriate proton in each step
##################################################################################################################
cat << EOF > connected_H_to_each_O_and_finding_proton_two.py
# in water finding the nearest two H 
import numpy as np
import math

# Define the index_num_for the O in water and Surface
Surface_O_index=[${SurfaceO[@]}]
Water_O_index=[${WaterO[@]}]

# loading the dataset
data_O_list = np.genfromtxt('sorted_H_O_list_for_current_step', delimiter='')
#print('The data set has the following look: \n', data_O_list)

# 0: Surface O; 1: Water O
iH_iO_dist = data_O_list[:, 0:3]
H_position = data_O_list[:, 3:6]
S_or_W_O = data_O_list[:, 6]

#Length of the file
length_file = len(S_or_W_O)
twoH_water_O = np.zeros(shape=(length_file,7))
oneH_surf_O = np.zeros(shape=(length_file,7))
OtherH_O = np.zeros(shape=(length_file,7))

i_s = 0
i_w = 0
i_other = 0
for i in range(0,length_file):
    temp_O_index = int(iH_iO_dist[i,1])
    if temp_O_index in Surface_O_index: # if the O in water, than grap it, grap 2 corresponding nearest H 
        oneH_surf_O[i_s,0:3] = iH_iO_dist[i,0:3]
        oneH_surf_O[i_s,3] = S_or_W_O[i]
        oneH_surf_O[i_s,4:7] = H_position[i,0:3]
        i_s = i_s+1
    elif temp_O_index in Water_O_index:
        if (i-1) != -1:
            temp_Oi = int(iH_iO_dist[(i-1),1])
            if temp_O_index != temp_Oi:
                twoH_water_O[i_w,0:3] = iH_iO_dist[i,0:3]
                twoH_water_O[i_w,3] = S_or_W_O[i]
                twoH_water_O[i_w,4:7] = H_position[i,0:3]
                i_w = i_w+1
                num_wO = 1
            elif temp_O_index == temp_Oi:
                if num_wO < 2:
                    twoH_water_O[i_w,0:3] = iH_iO_dist[i,0:3]
                    twoH_water_O[i_w,3] = S_or_W_O[i]
                    twoH_water_O[i_w,4:7] = H_position[i,0:3]
                    i_w = i_w+1
                    num_wO = num_wO+1
                elif num_wO >= 2:
                    OtherH_O[i_other,0:3] = iH_iO_dist[i,0:3]
                    OtherH_O[i_other,3] = S_or_W_O[i]
                    OtherH_O[i_other,4:7] = H_position[i,0:3]
                    i_other = i_other+1
                    num_wO = num_wO+1
        elif (i-1) == -1:
#           iH_iO_dist[(i-1),1] = int(iH_iO_dist[0,1])
            twoH_water_O[i_w,0:3] = iH_iO_dist[i,0:3]
            twoH_water_O[i_w,3] = S_or_W_O[i]
            twoH_water_O[i_w,4:7] = H_position[i,0:3]
            i_w = i_w+1
            num_wO = 1

oneH_surf_O_temp = np.delete(oneH_surf_O,[i for i in range(i_s,length_file)],0)
OtherH_O_temp = np.delete(OtherH_O,[i for i in range(i_other,length_file)],0)
twoH_water_O_temp = np.delete(twoH_water_O,[i for i in range(i_w,length_file)],0)
#combine surface and other binding H to get the closest H
surface_other_Combin = np.vstack((oneH_surf_O_temp,OtherH_O_temp))

np.savetxt('SaOther_O_binding_H', surface_other_Combin, fmt="%s", delimiter='   ')
np.savetxt('Water_O_binding_2H', twoH_water_O_temp, fmt="%s", delimiter='   ')
EOF
##############################################################################################################################
# Second Python end file
##############################################################################################################################

###############################################################################################################################
# grab the O index and coordination as well as if it is surface O or not and the corresponding Proton inside
###############################################################################################################################
cat << EOF > Eachstep_O_threeH_twoO_three.py

#load data into the script
import numpy as np
import math

# Define the index num for the O in water and Surface
Surface_O_index=[${SurfaceO[@]}]
Water_O_index=[${WaterO[@]}]
proton_A=${total_proton_num}

# Loading dataset
Water_O_Hd_data = np.genfromtxt('Water_O_Hd', delimiter='')
Water_O_Od_data = np.genfromtxt('Water_O_Od', delimiter='')
SaOther_O_data = np.genfromtxt('SaOther_O', delimiter='')

len_WH = len(Water_O_Hd_data[:,0])
Water_num = ${num_water}

# Define the first H atom index (Modify)
First_H_fixed = ${First_H_index}
First_H = ${First_H_index}
lack_H_index = np.zeros(proton_A)

ii = 0
if len_WH == Water_num*2:
    for i in range(0,len_WH):
        if Water_O_Hd_data[i,0] == First_H:
            First_H = First_H + 1
        elif Water_O_Hd_data[i,0] != First_H:
            temp_nss=int(Water_O_Hd_data[i,0]-First_H)
            for iii in range(0,temp_nss):
                lack_H_index[ii] = First_H+iii
                ii = ii+1
            First_H = Water_O_Hd_data[i,0] + 1
    time_left = int((First_H_fixed+2*Water_num+proton_A-1) - Water_O_Hd_data[len_WH-1,0])
    if time_left <= proton_A and time_left > 0:
        for t in range(0,time_left):
	        lack_H_index[(proton_A-time_left+t)] = First_H_fixed+2*Water_num+proton_A-time_left+t
elif len_WH != 2*Water_num:
    print('Water amount and 2*H amount are not match!')


len_other=len(SaOther_O_data[:,0])
two_proton_O=np.zeros(proton_A)
two_proton=np.zeros(proton_A)

for ww in range(0,len_other):
    two_proton_temp = SaOther_O_data[ww,0]
    if two_proton_temp in lack_H_index:
        start_st=ww
        break

two_proton_temp_all=np.zeros(proton_A)
two_proton_temp_all[0]=two_proton_temp
two_proton_O[0]=SaOther_O_data[start_st,1]
two_proton[0]=SaOther_O_data[start_st,0]

right_sever_position=np.zeros(shape=(proton_A,7))
right_sever_position[0,:]=SaOther_O_data[start_st,:]
tem_num=start_st+1
for pp in range(1,proton_A):
    for yy in range(tem_num,len_other):
        ts=0
        two_proton_t = SaOther_O_data[yy,0]
        if (two_proton_t not in two_proton_temp_all) and (two_proton_t in lack_H_index) :
            two_proton_O[pp]=SaOther_O_data[yy,1]
            two_proton[pp]=SaOther_O_data[yy,0]
            two_proton_temp_all[pp] = SaOther_O_data[yy,0]
            right_sever_position[pp,:]=SaOther_O_data[yy,:]
            ts=ts+1
            if ts==1:
                tem_num=1+tem_num
                break

proton_writen_infile = np.zeros(shape=(proton_A*3,7))
iii = 0
if np.array_equal(lack_H_index,sorted(two_proton)) == True:
    for aa in range(0,proton_A): 
        temp_O_index = two_proton_O[aa]
        proton_writen_infile[iii,:] = right_sever_position[aa,:]
        iii = iii + 1
        if temp_O_index in Water_O_index:
            for bb in range(0,len_WH):
                if Water_O_Od_data[bb,1] == temp_O_index:
                    proton_writen_infile[iii,:] = Water_O_Od_data[bb,:]
                    iii = iii + 1
        elif temp_O_index in Surface_O_index:
            for cc in range(0,2):
                proton_writen_infile[iii,:] = np.zeros(7)
                iii = iii + 1
elif np.array_equal(lack_H_index,sorted(two_proton)) == False:
    print("Problem happened for the two input files!")

# For every corresponding O, the first H is the proton, the other two is the 2H in water
np.savetxt('H_and_corresponding_O', proton_writen_infile, fmt="%s", delimiter='   ')
EOF
##############################################################################################################################
# Third Python end file
##############################################################################################################################

####################################################################################################################################

for ((s=1; s<=${num_XDATCAR}; s++))
do
xdat2pos.pl 1 $s # obtaining the index num for all atoms in water and Surface
mv POSCAR$s.out CONTCAR

# H atom num from 175 to 200
for ((a=${First_H_index}; a<=${Final_H_index}; a++))
do
neighbors.pl CONTCAR $a # getting he neighdist.dat
#index atom_index, distace, position X, Y, Z
awk '{printf("%4d %4d %15.8f %15.8f %15.8f %15.8f\n",$1, $2, $7, $3, $4, $5)}' neighdist.dat > H_temp_list
sed -i '10,$d' H_temp_list
#module load python/3.6.0
python3 Python_getting_twoO_distance_one.py >> First_python.log
sed '3,$d' all_O_list >> H_O_list_for_current_step_temp.dat
rm H_temp_list neighdist.dat all_O_list 
done

awk '{printf("%4d %4d %15.8f %15.8f %15.8f %15.8f %4d\n", $1, $2, $3, $4, $5, $6, $7)}' H_O_list_for_current_step_temp.dat > H_O_list_for_current_step
sort -n -k2 -k3 H_O_list_for_current_step > sorted_H_O_list_for_current_step
rm H_O_list_for_current_step_temp.dat H_O_list_for_current_step

######################################################################################################################################################
python3 connected_H_to_each_O_and_finding_proton_two.py >> Second_python.log
 
awk '{printf("%4d %4d %15.8f %4d %15.8f %15.8f %15.8f\n", $1, $2, $3, $4, $5, $6, $7)}' SaOther_O_binding_H > SaOther_O_binding_H_temp
awk '{printf("%4d %4d %15.8f %4d %15.8f %15.8f %15.8f\n", $1, $2, $3, $4, $5, $6, $7)}' Water_O_binding_2H > Water_O_Od

sort -n -k3 SaOther_O_binding_H_temp > SaOther_O
sort -n -k1 Water_O_Od > Water_O_Hd 
rm SaOther_O_binding_H_temp sorted_H_O_list_for_current_step SaOther_O_binding_H Water_O_binding_2H

###########################################################################################################################
python3 Eachstep_O_threeH_twoO_three.py >> third_python.log
rm Water_O_Hd Water_O_Od SaOther_O

# Oder: O, Surface(0) or Water(1), proton, two water H (s-l),
numL_combine=`echo 3'*'${total_proton_num} | bc`
awk '{printf("%4d %4d %4d %12.8f\n", $2, $4, $1, $3)}' H_and_corresponding_O > Order_list
awk 'ORS=NR%'${numL_combine}'?"   ":"\n"{print}' Order_list >> final_Hlist_temp

rm H_and_corresponding_O Order_list
rm CONTCAR
done

#binded Oxygen, the proton, the two water Oxygen (index order in following script)
#Libby Proton and three H list
#three_H_to_O, columns belong to same O binded H
total_co=`echo 12`
touch Libby_H_list
for ((On=1; On<=${total_proton_num}; On++))
do
awk '{printf("%4d %2d\n",$('${total_co}'*('$On'-1)+1),$('${total_co}'*('$On'-1)+2));}' final_Hlist_temp > Oxygen_$On
awk '{printf("%4d %12.8f %4d %12.8f %4d %12.8f\n",$('${total_co}'*('$On'-1)+3),$('${total_co}'*('$On'-1)+4),$('${total_co}'*('$On'-1)+7),$('${total_co}'*('$On'-1)+8),$('${total_co}'*('$On'-1)+11),$('${total_co}'*('$On'-1)+12));}' final_Hlist_temp > proton_$On
paste Oxygen_$On proton_$On > Libby_H_list_temp_$On 
paste Libby_H_list Libby_H_list_temp_$On > Libby_H_list_temp
cp Libby_H_list_temp Libby_H_list
rm Libby_H_list_temp
done
rm *Oxygen_*

# Maria Proton and three H list
touch reduced_H_list
for ((On=1; On<=${total_proton_num}; On++))
do
awk '{printf("%4d\n",$('${total_co}'*('$On'-1)+1));}' final_Hlist_temp > Oxygen_$On
paste Oxygen_$On proton_$On > reduced_H_list_temp_$On
paste reduced_H_list reduced_H_list_temp_$On > reduced_H_list_temp
cp reduced_H_list_temp reduced_H_list
rm reduced_H_list_temp
done
rm *reduced_H_list_temp_* *Libby_H_list_temp_*

rm  *proton_* *Oxygen_*
rm final_Hlist_temp *.py*

