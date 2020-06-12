#Calculating surface redox rate constant
#We need the Final_proton_bonded_O_reorder_list_Final from 4_Reording_O_Proton_H_List

#load the pyrhon3 environment
module load python/3.6.0

#######################################  
##########Setting parameters###########  
#######################################  
#####Number of the protons#####  
total_proton_num=`echo 2`  #You can modify   
  
#####time per step#####  
time_step=`echo 1`  #fs (femto second) and You can modify   

#####O indexes on Surface#####  
###If indexes have order  
Sur_O_St=`echo 30`  #You can modify   
Sur_O_En=`echo 60`  #You can modify   
interger_SO=`echo 1`  #You can modify   
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
Wat_O_St=`echo 70`   #You can modify   
Wat_O_En=`echo 80`   #You can modify   
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
  
#####Unit-cell parameters#####  
#The a-,b-,c-lattice directions  
AxisO=(10.0,0.00,0.00)  #You can modify 
AxisT=(5.0,10.0,0.00)  #You can modify 
AxisR=(0.00,0.00,10.0)  #You can modify 
  
#####Unit-cell C-lattice constant#####  
#Without water and protons C-lattice constant  
No_water_hight=`echo 9.5`  #You can modify   
#With water and protons C-lattice constant  
With_WP_hight=`echo 12.0`  #You can modify   
  
#####Total number of water molecules#####  
num_water=`echo ${WaterO[0]} | awk -F "," '{print NF}'`  
  
#####Total time for the trajectory in pico seconds#####  
Num_traj=`wc -l Final_proton_bonded_O_reorder_list_Final | cut -d' ' -f1`  
time_period=`echo ${Num_traj}$'*'${time_step}'/'1000 | bc`  # ps (pico second)  

##########################  
###Python_fifth.py code###  
##########################  
########################################################  
###Reorder proton-bonded O list, making it continuous###  
########################################################  
cat << EOF > Python_fifth.py  

import numpy as np  
import math  
  
#Define parameters  
proton_num = ${total_proton_num}  
Surface_O_index = [${SurfaceO[@]}]  
Water_O_index =[${WaterO[@]}]  
  
#Load data  
data_proton=np.genfromtxt('Final_proton_bonded_O_reorder_list_Final', delimiter='')
  
#Calculate the surface redox rate constants  
len_step=len(data_proton[:,0])  
proton_total = data_proton[:,1:(proton_num+1)]  
print('The total steps invovled in our calculations is: ', len_step)  
   
#We have the following cases:  
#1: ss; 2: sw; 3: ws; 4: ww; 0: no change     
ss_total = np.zeros(proton_num)  
sw_total = np.zeros(proton_num)  
ws_total = np.zeros(proton_num)  
ww_total = np.zeros(proton_num)  
nochange_stayW = np.zeros(proton_num)  
nochange_stayS = np.zeros(proton_num)  
count_num_proton = np.zeros(shape=(len_step-1,proton_num))  
  
for nn in range(0,proton_num):      
    for i in range(0,len_step-1):  
        temp_proton_cal_f = int(proton_total[i,nn])  
        temp_proton_cal_s = int(proton_total[i+1,nn])  
        if (temp_proton_cal_f in Surface_O_index) and (temp_proton_cal_s in Water_O_index):  
             count_num_proton[i,nn] = 2  
             sw_total[nn] = sw_total[nn]+1  
        elif (temp_proton_cal_f in Water_O_index) and (temp_proton_cal_s in Surface_O_index):  
             count_num_proton[i,nn] = 3  
             ws_total[nn] = ws_total[nn]+1  
        elif (temp_proton_cal_f in Surface_O_index) and (temp_proton_cal_s in Surface_O_index):  
            if temp_proton_cal_f != temp_proton_cal_s:  
                count_num_proton[i,nn] = 1  
                ss_total[nn] = ss_total[nn]+1  
            else:  
                count_num_proton[i,nn] = 0  
                nochange_stayS[nn] = nochange_stayS[nn]+1  
        elif (temp_proton_cal_f in Water_O_index) and (temp_proton_cal_s in Water_O_index):  
            if temp_proton_cal_f != temp_proton_cal_s:   
                count_num_proton[i,nn] = 4  
                ww_total[nn] = ww_total[nn]+1  
            else:  
                count_num_proton[i,nn] = 0  
                nochange_stayW[nn] = nochange_stayW[nn]+1  
      
    if ws_total[nn]+sw_total[nn]+ww_total[nn]+ss_total[nn]+nochange_stayS[nn]+nochange_stayW[nn] == len_step-1:  
        print('\nCalculations for proton number {} are right!'.format(nn+1))  
    else:  
        print('\nError happened for proton number {}!'.format(nn+1))  
      
   #print('The matrix for the transfer of proton {} is: {}'.format(nn+1,count_num_proton[:,nn]))  
    print('Count  times for the transfer of proton number {} : '.format(nn+1))  
    print('Surface-Surface number: {}'.format(int(ss_total[nn])))  
    print('Water-Surface number: {}'.format(int(ws_total[nn])))  
    print('Surface-Water number: {}'.format(int(sw_total[nn])))  
    print('Water-Water number: {}'.format(int(ww_total[nn])))  
    print('Stay in same water-O: {}'.format(int(nochange_stayW[nn])))  
    print('Stay in same surface-O: {}'.format(int(nochange_stayS[nn])))  
  
#############################################     
#Calculate the rate constant for all protons#  
#############################################  
#Define parameters  
Avogadro_constant = 6.022140857*10**23  
one_axis = (${AxisO})  
two_axis = (${AxisT})  
three_axis = (${AxisR})  
no_water_lattice = ${No_water_hight}  
With_water_lattice = ${With_WP_hight}  
Lactice_z_change = With_water_lattice-no_water_lattice  
  
#The area of the surface  
def calc_area(p1, p2, p3):  
        (x1, y1, z1),(x2, y2, z2),(x3, y3, z3) = p1,p2,p3  
        return abs(x1*y2-x2*y1+x2*y3-x3*y2+x3*y1-x1*y3)   
area_angstrom = calc_area(one_axis, two_axis, three_axis)  
area_m = area_angstrom*(10**-10)**2  
  
#Total proton surface redox times  
time_total_surface_redox = sum(sw_total)   
time_redox = time_total_surface_redox/Avogadro_constant  
proton_mol = proton_num/Avogadro_constant  
fs_total_s = len_step*10**(-15)  #unit:s  
  
#Proton concentration  
volumn = Lactice_z_change*area_m*(10**-10)  #unit m^3  
concentration_proton = proton_mol/volumn  
  
#Water density  
water_density = ${num_water}/Avogadro_constant*18.0153/volumn/1000000   
print('\nWater density in my system (g*cm-3) is: ',water_density)     
#Surface redox rate constant  
rate = time_redox/(2*area_m)/fs_total_s/concentration_proton  
print('\nThe surface redox rate constant (unit: m*s-1) is: ',rate) 	
	
EOF
############################  
###End of Python_fifth.py###  
############################ 

#######################################################################  
#####Performing Python script and get surface redox rate constants#####  
#######################################################################  
python Python_fifth.py > Fifth_python.log    
rm Python_fifth.py 
