#All calculations were performed under the current folder
#We need two files: POSCAR and XDATACAR

#load Python3 environment
module load python/3.6.0

#######################################  
##########Setting parameters###########  
#######################################  
#####Number of the protons#####  
total_proton_num=`echo 2` #You can modify

#####O indexes on Surface#####  
###If indexes have order  
SO_St=`echo 33` #You can modify 
SO_En=`echo 64` #You can modify 
interger_SO=`echo 1` #You can modify 
echo "${Sur_O_St}" >> index_SO_temp  
for ((i=${Sur_O_St}+${interger_SO}; i<=${Sur_O_En}; i+=${interger_SO}))  
do  
  echo ",$i" >> index_SO_temp  
done  
cat index_SO_temp | xargs > index_SO  
SO_temp=(`echo $(grep "," index_SO)`)  
SurfaceO=`echo ${SO_temp[@]} | sed 's/ //g'`  
rm index_SO index_SO_temp  
###If indexes do not have an order  
#SurfaceO=(83,89,91,97,99,101,109,111,113)  #You can modify   

#####O indexes in water#####  
###If indexes have order  
Wat_O_St=`echo 65`   #You can modify   
Wat_O_En=`echo 76`   #You can modify   
interger_WO=`echo 1`  #You can modify   
echo "${Wat_O_St}" >> index_WO_temp  
for ((i=${Wat_O_St}+${interger_WO}; i<=${Wat_O_En}; i+=${interger_WO}))   #i+  
do  
  echo ",$i" >> index_WO_temp  
done  
cat index_WO_temp | xargs > index_WO  
WO_temp=(`echo $(grep "," index_WO)`)  
WaterO=`echo ${WO_temp[@]} | sed 's/ //g'`  
rm index_WO index_WO_temp  
###If indexes do not have an order  
#WaterO=(115,117,121,122,123,126)  #You can modify  

#####Initial index of Hydrogen (H)#####  
First_H_index=`echo 125`  #You can modify     
#####Total steps along trajectory (XDATCAR)#####  
num_XDATCAR=`echo 15000`  #You can modify   
#####Total number of water molecules#####  
num_water=`echo ${WaterO[0]} | awk -F "," '{print NF}'`    
#####Last index of Hydrogen (H)######  
Final_H_index=`echo ${First_H_index}'+'2'*'${num_water}'+'${total_proton_num}'-'1 | bc`  

########################  
###Python_one.py code###  
########################  
########################################################################  
###Sorted the distance between the O (Surface or Water) to the same H###  
########################################################################  
cat << EOF > Python_one.py
  
import numpy as np  
import math  
  
#Define water-O and surface-O indexes  
Surface_O_index=[${SurfaceO[@]}]  
Water_O_index=[${WaterO[@]}]  
#Load data  
data_H_temp_list = np.genfromtxt('H_temp_list', delimiter='')  
  
index_order = data_H_temp_list[:,0]  
atom_index_distance = data_H_temp_list[:,1:3]  
atom_index_position = data_H_temp_list[:,3:7]  
len_step = len(index_order)  
#The distance from 2nd-end rows are between the atom in that row and the 1st row--H position    
H_corres_index = atom_index_distance[0,0]  
H_corres_position = atom_index_position[0,:]  
  
#Obtain the nearest O atom to the H  
#O identity: surface-O: 0, water-O: 1  
ii = 0  
Two_O_connected = np.zeros(shape=((len_step-1),7))  
    
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
	  
#Format for Two_O_connected  
#H index, O index, O-H distance, O X-coord, O Y-coord, O Z-coord, O identity  
  
#Save datafile  
np.savetxt("near_O_list", Two_O_connected, fmt="%s", delimiter='  ') 

EOF
##########################  
###End of Python_one.py###  
##########################  

########################  
###Python_two.py code###  
########################  
###############################################################  
###Locate each H (water) and find the possible proton-like H###  
###############################################################  
cat << EOF > Python_two.py

import numpy as np  
import math  
  
#Define water-O and surface-O indexes  
Surface_O_index=[${SurfaceO[@]}]  
Water_O_index=[${WaterO[@]}]  
#Load data  
data_O_list = np.genfromtxt('Sorted_Two_O_list_current_step_final', delimiter='')  
iH_iO_dist = data_O_list[:, 0:3]  
H_position = data_O_list[:, 3:6]  
S_or_W_O = data_O_list[:, 6]  
length_file = len(S_or_W_O)  
  
#H2O in water, -OH on surface, or others  
twoH_water_O = np.zeros(shape=(length_file,7))  
oneH_surf_O = np.zeros(shape=(length_file,7))  
OtherH_O = np.zeros(shape=(length_file,7))  
i_s = 0  
i_w = 0  
i_other = 0  
  
for i in range(0,length_file):  
    temp_O_index = int(iH_iO_dist[i,1])  #In comparison with the previous one  
    ###Surface-O  
    if temp_O_index in Surface_O_index:   
        oneH_surf_O[i_s,0:3] = iH_iO_dist[i,0:3]  
        oneH_surf_O[i_s,3] = S_or_W_O[i]  
        oneH_surf_O[i_s,4:7] = H_position[i,0:3]  
        i_s = i_s+1  
    ###Water-O  
    elif temp_O_index in Water_O_index: #Water-O  
        if (i-1) != -1: #i is not the first line  
            temp_Oi = int(iH_iO_dist[(i-1),1])  
            if temp_O_index != temp_Oi:  
                twoH_water_O[i_w,0:3] = iH_iO_dist[i,0:3]  
                twoH_water_O[i_w,3] = S_or_W_O[i]  
                twoH_water_O[i_w,4:7] = H_position[i,0:3]  
                i_w = i_w+1  
                num_wO = 1  
            elif temp_O_index == temp_Oi:  
                if num_wO < 2:  #Grab two H that corresponding to the water-O  
                    twoH_water_O[i_w,0:3] = iH_iO_dist[i,0:3]  
                    twoH_water_O[i_w,3] = S_or_W_O[i]  
                    twoH_water_O[i_w,4:7] = H_position[i,0:3]  
                    i_w = i_w+1  
                    num_wO = num_wO+1  
                elif num_wO >= 2:  #Others H   
                    OtherH_O[i_other,0:3] = iH_iO_dist[i,0:3]  
                    OtherH_O[i_other,3] = S_or_W_O[i]  
                    OtherH_O[i_other,4:7] = H_position[i,0:3]  
                    i_other = i_other+1  
                    num_wO = num_wO+1  
        elif (i-1) == -1:  #i is the first line  
            twoH_water_O[i_w,0:3] = iH_iO_dist[i,0:3]  
            twoH_water_O[i_w,3] = S_or_W_O[i]  
            twoH_water_O[i_w,4:7] = H_position[i,0:3]  
            i_w = i_w+1  
            num_wO = 1  
  
#Delete all-0 rows  
oneH_surf_O_temp = np.delete(oneH_surf_O,[i for i in range(i_s,length_file)],0)  
OtherH_O_temp = np.delete(OtherH_O,[i for i in range(i_other,length_file)],0)  
twoH_water_O_temp = np.delete(twoH_water_O,[i for i in range(i_w,length_file)],0)  
  
#Possible proton-like index and positions  
surface_other_Combin = np.vstack((oneH_surf_O_temp,OtherH_O_temp))  
  
#Format for surface_other_Combin and twoH_water_O_temp  
#H Iindex, O index, H-O distance, O-identity surface-O(0)/water-O(1), O X-coord, O Y-coord, O Z-coord,  
  
#Save datafiles  
np.savetxt('Sur_Other_O_binding_H', surface_other_Combin, fmt="%s", delimiter='   ')  
np.savetxt('Water_O_binding_2H', twoH_water_O_temp, fmt="%s", delimiter='   ') 

EOF
##########################  
###End of Python_two.py###  
##########################  
  
##########################  
###Python_three.py code###  
##########################  
################################################################  
###Finding all the proton-bonded O indexes and bonded H index###  
###(3 for H3O+/1 for -OH) as well as each O-H distance##########
################################################################  
cat << EOF > Python_three.py  

import numpy as np  
import math  
  
#Define water-O and surface-O indexes  
Surface_O_index=[${SurfaceO[@]}]  
Water_O_index=[${WaterO[@]}]  
proton_A=${total_proton_num}  
Water_num = ${num_water}  
First_H_fixed = ${First_H_index}  
First_H = ${First_H_index}  
#Load data  
Water_O_Hd_data = np.genfromtxt('Water_O_Hd', delimiter='')  
Water_O_Od_data = np.genfromtxt('Water_O_Od', delimiter='')  
SaOther_O_data = np.genfromtxt('SaOther_O', delimiter='')  
len_WH = len(Water_O_Hd_data[:,0])  
  
#Finding the proton indexes first  
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
    print('Problem! Water amount and 2*H amount are not match!')  
  
#Finding the index and position for proton bonded O  
len_other=len(SaOther_O_data[:,0])  
Proton_O=np.zeros(proton_A)  
Proton=np.zeros(proton_A)  
  
for ww in range(0,len_other):  
    Proton_temp = SaOther_O_data[ww,0]  
    if Proton_temp in lack_H_index:  
        start_st=ww  
        break  
  
Proton_temp_all=np.zeros(proton_A)  
Proton_temp_all[0]=Proton_temp  
Proton_O[0]=SaOther_O_data[start_st,1]  
Proton[0]=SaOther_O_data[start_st,0]  
right_sever_position=np.zeros(shape=(proton_A,7))  
right_sever_position[0,:]=SaOther_O_data[start_st,:]  
tem_num=start_st+1  
  
for pp in range(1,proton_A):  
    for yy in range(tem_num,len_other):  
        Proton_t = SaOther_O_data[yy,0]  
        if (Proton_t not in Proton_temp_all) and (Proton_t in lack_H_index) :  
            Proton_O[pp]=SaOther_O_data[yy,1]  
            Proton[pp]=SaOther_O_data[yy,0]  
            Proton_temp_all[pp] = SaOther_O_data[yy,0]  
            right_sever_position[pp,:]=SaOther_O_data[yy,:]  
            tem_num=1+tem_num  
            break  
  
#Obtain the H index and position to proton-bonded O  
#3H in H30+ in water molecules  
#1H in -OH on surface, other 2H are empty  
proton_writen_infile = np.zeros(shape=(proton_A*3,7))  
  
iii = 0  
if np.array_equal(lack_H_index,sorted(Proton)) == True:  
    for aa in range(0,proton_A):   
        temp_O_index = Proton_O[aa]  
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
elif np.array_equal(lack_H_index,sorted(Proton)) == False:  
    print("Problem! Please recheck the proton indexes!")  
  
#Format for H_and_corresponding_O:  
#3-row form a group and corresponds to the same proton-bonded O;  
#In each group, the first row is alwasy the proton related row   
#H Iindex, O index, H-O distance, O-identity surface-O(0)/water-O(1), O X-coord, O Y-coord, O Z-coord,  
  
#Save datafile  
np.savetxt('H_and_corresponding_O', proton_writen_infile, fmt="%s", delimiter='   ')  
  
EOF
############################  
###End of Python_three.py###  
############################  


#########################################################################  
##########Linux commands used to connect different Python codes##########  
#########################################################################  
  
#########################################  
#####The two nearest O to the same H#####  
######################################### 
for ((s=1; s<=${num_XDATCAR}; s++))  
do  
  ###Handle trajectory step by step  
  xdat2pos.pl 1 $s  #xdat2pos.pl from VTSTSCRIPTS-933, the output is POSCAR$s.out  
  mv POSCAR$s.out CONTCAR  
    
  ###Handling with all H indexes  
  for ((a=${First_H_index}; a<=${Final_H_index}; a++))  
  do  
    neighbors.pl CONTCAR $a  #neighbors.pl from VTSTSCRIPTS-933, the output is neighdist.dat  
    ###Format: index, atom_index, distace, X-coord, Y-coord, Z-coord  
    awk '{printf("%4d %4d %15.8f %15.8f %15.8f %15.8f\n",$1, $2, $7, $3, $4, $5)}' neighdist.dat > H_temp_list    
    sed -i '10,$d' H_temp_list  
    ###Python3 environment  
    python Python_one.py >> First_python.log    
    sed '3,$d' near_O_list >> Two_O_list_current_step  
    rm H_temp_list neighdist.dat near_O_list   
  done  
    
  ###Format: index, atom_index, distace, X-coord, Y-coord, Z-coord, surface-O(0)/water-O(1)  
  awk '{printf("%4d %4d %15.8f %15.8f %15.8f %15.8f %4d\n", $1, $2, $3, $4, $5, $6, $7)}' Two_O_list_current_step > Two_O_list_current_step_final    
  ###Sorted firstly by O index and secondly by the H-O distance  
  sort -n -k2 -k3 Two_O_list_current_step_final > Sorted_Two_O_list_current_step_final  
  rm Two_O_list_current_step Two_O_list_current_step_final  

###############################################################  
#####Locate each H (water) and find possible proton-like H#####  
############################################################### 
  python Python_two.py >> Second_python.log  
  
  ###Format: H Iindex, O index, H-O distance, O-identity surface-O(0)/water-O(1), O X-coord, O Y-coord, O Z-coord,  
  awk '{printf("%4d %4d %15.8f %4d %15.8f %15.8f %15.8f\n", $1, $2, $3, $4, $5, $6, $7)}' Sur_Other_O_binding_H > Sur_Other_O_binding_H_temp  
  awk '{printf("%4d %4d %15.8f %4d %15.8f %15.8f %15.8f\n", $1, $2, $3, $4, $5, $6, $7)}' Water_O_binding_2H > Water_O_Od  #Sorted by O index  
  sort -n -k3 Sur_Other_O_binding_H_temp > SaOther_O  #Sorted by O index  
  sort -n -k1 Water_O_Od > Water_O_Hd  #Sorted by H index  
  rm Sur_Other_O_binding_H_temp Sur_Other_O_binding_H Water_O_binding_2H Sorted_Two_O_list_current_step_final   
  
##################################################################  
#####Find proton-bonded O index，bonded H index, O-H distance#####  
################################################################## 
  python Python_three.py >> Third_python.log  
  rm Water_O_Hd Water_O_Od SaOther_O  
  
  numL_combine=`echo 3'*'${total_proton_num} | bc`  
  #Format: Proton-bonded O index, O odentity surface-O(0)/water-O(1), bonded Proton/H index, H-O distance  
  awk '{printf("%4d %4d %4d %12.8f\n", $2, $4, $1, $3)}' H_and_corresponding_O > Order_list  
  #Combine same Proton-bonded O index into one row  
  awk 'ORS=NR%'${numL_combine}'?"   ":"\n"{print}' Order_list >> final_Hlist_temp  
  rm H_and_corresponding_O Order_list CONTCAR  
done  

#############################  
#####The final datafiles#####  
#############################  
total_co=`echo 12`  
  
##################################################  
###With O identity surface-O(0)/water-O(1) list###  
  
#Format for with_proton_bonded_Oid_H_list  
#i) each row represents each step  
#ii) every 8-column have the information for same proton-bonded O  
#iii) 1st column: Proton-bonded O index  
#     2nd column: The identity of this O surface-O(0)/water-O(1)  
#     3-4th columns：proton index and O-H distance  
#     5-8th columns：The other 2H bonding with the O index (empty means surface O)

touch with_Proton_bonded_Oid_H_list  
for ((On=1; On<=${total_proton_num}; On++))  
do  
  awk '{printf("%4d %2d\n",$('${total_co}'*('$On'-1)+1),$('${total_co}'*('$On'-1)+2));}' final_Hlist_temp > Oxygen_$On  
  awk '{printf("%4d %12.8f %4d %12.8f %4d %12.8f\n",$('${total_co}'*('$On'-1)+3),$('${total_co}'*('$On'-1)+4),$('${total_co}'*('$On'-1)+7),$('${total_co}'*('$On'-1)+8),$('${total_co}'*('$On'-1)+11),$('${total_co}'*('$On'-1)+12));}' final_Hlist_temp > proton_$On  
  paste Oxygen_$On proton_$On > with_Oid_H_list_temp_$On   
  paste with_Proton_bonded_Oid_H_list with_Oid_H_list_temp_$On > with_Oid_H_list_temp  
  cp with_Oid_H_list_temp with_Proton_bonded_Oid_H_list  
  rm with_Oid_H_list_temp  
done  
rm *Oxygen_* *with_Oid_H_list_temp_*  

#############################  
###Without O identity list###  
  
#Format for proton_bonded_O_H_list  
#i) each row represents each step  
#ii) every 7-column have the information for same proton-bonded O  
#iii) 1st column: Proton-bonded O index  
#     2-3rd columns：proton index and O-H distance  
#     4-7th columns：The other 2H bonding with the O index (empty means surface O)  
  
touch Proton_bonded_O_H_list  
for ((On=1; On<=${total_proton_num}; On++))  
do  
  awk '{printf("%4d\n",$('${total_co}'*('$On'-1)+1));}' final_Hlist_temp > Oxygen_$On  
  paste Oxygen_$On proton_$On > H_list_temp_$On  
  paste Proton_bonded_O_H_list H_list_temp_$On > H_list_temp  
  cp H_list_temp Proton_bonded_O_H_list  
  rm H_list_temp  
done  
rm *H_list_temp_* *proton_* *Oxygen_* *.py* final_Hlist_temp  
