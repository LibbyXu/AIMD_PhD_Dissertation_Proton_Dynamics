#We calculate the OH orientation and dipole moment orientations for water molecules.
#We need three files: WO_position from previous Separate_1, [corres_O_W_num_second, final_H_list_step_second] from the previous data processing script "Data_processes_Corres_H_Posiitons_First".

#load Python3 environment
module load python/3.6.0

##Definition of variables
##Number of the protons
total_proton_num=`echo 2` #You can modify 

##The separate degrees
degree_for_all=`echo 45` #You can modify 

#The x y position for the area for calculating the area (from lattice constants)
AxisOxy=(10.0,0.0) #You can modify 
AxisTxy=(-5.0,10.0) #You can modify 
AxisRxy=(0.0,0.0) #You can modify 

##The O index from Water 
##If the indexes have an order
WO_St=`echo 65` #You can modify 
WO_En=`echo 76` #You can modify 
interger_WO=`echo 1` #You can modify 
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
#WaterO=(65,68,71,72,74)

##Some other parameters needed to be set
total_water_num=`echo ${WO_En}'-'${WO_St}'+'1 | bc`
##This script applied only for the system with 1 interface
Water_layer_num=`echo 1`

###########################################
#Python file to get directions and degrees#
#positive down; negative up################
###########################################
cat << EOF > Python_polarization_OH_water.py

import numpy as np
import math

total_step=${total_water_num}
x_axis = (${AxisOxy})
y_axis = (${AxisTxy})

#loading the dataset
Final_protnH_list = np.genfromtxt('final_H_list_step_second', delimiter='')
Current_O_inW = np.genfromtxt('corres_O_W_num_second', delimiter='')
Step_proton = np.genfromtxt('WO_position', delimiter='')
length_all=int(len(Step_proton))
length_all_H=int(len(Final_protnH_list))
lenngth_check=int(len(Current_O_inW))

if length_all != lenngth_check:
    print('Something wrong happened with the previous step!')

step_num_total=int(lenngth_check/total_step)
polarization_file = np.zeros(shape=(length_all_H,30))
position_WATER_O = np.zeros(shape=(1,4))

line_num=0
for a in range(0,step_num_total):
    for b in range(0,total_step):
        num_proton = int(Current_O_inW[a*total_step+b,1])
        position_WATER_O[0,0] = Step_proton[a*total_step+b,1]
        position_WATER_O[0,1:4] = Step_proton[a*total_step+b,3:6]
        if num_proton == 0:
	        num_H = 2
        elif num_proton == 1:
	        num_H = 0
        if num_H == 2:
            for c in range(0,num_H):
                polarization_file[line_num,c*15]=Current_O_inW[a*total_step+b,0]
                polarization_file[line_num,(c*15+1):(c*15+6)]=Final_protnH_list[line_num,(c*5):(c*5+5)]
                polarization_file[line_num,(c*15+6):(c*15+9)]=position_WATER_O[0,1:4]
                temp_direction=np.zeros(shape=(1,3))
                temp_direction[0,0:3]=Final_protnH_list[line_num,(c*5+2):(c*5+5)]-position_WATER_O[0,1:4]
                temp_jud=0
                if temp_direction[0,0] < 0:
                    if abs(temp_direction[0,0]) > 1.5:
                        temp_X=temp_direction[0,0]+y_axis[0]+x_axis[0]
                        if abs(temp_X) < 1.5 and temp_direction[0,1] < 0:
                            temp_direction[0,0]=temp_X
                            temp_direction[0,1]=temp_direction[0,1]+y_axis[1]
                        elif abs(temp_X) > 1.5 or temp_direction[0,1] > 0:
                            temp_jud=1
                elif temp_direction[0,0] > 0:
                    if abs(temp_direction[0,0]) > 1.5:
                        temp_X=temp_direction[0,0]-y_axis[0]-x_axis[0]   
                        if abs(temp_X) < 1.5 and temp_direction[0,1] > 0:  
                            temp_direction[0,0]=temp_X
                            temp_direction[0,1]=temp_direction[0,1]-y_axis[1]
                        elif abs(temp_X) > 1.5 or temp_direction[0,1] < 0:
                            temp_jud=1
                if temp_jud==1:
                    if temp_direction[0,0] < 0:
                        temp_X=temp_direction[0,0]-y_axis[0]+x_axis[0]
                        if abs(temp_X) < 1.5:
                            temp_direction[0,0]=temp_X
                            temp_direction[0,1]=temp_direction[0,1]-y_axis[1]
                            temp_jud=0
                    elif temp_direction[0,0] > 0:   
                        temp_X=temp_direction[0,0]+y_axis[0]-x_axis[0]
                        if abs(temp_X) < 1.5:
                            temp_direction[0,0]=temp_X
                            temp_direction[0,1]=temp_direction[0,1]+y_axis[1]
                            temp_jud=0
                if temp_jud==1:
                    if abs(temp_direction[0,0]) > 1.5 and abs(temp_direction[0,1]) < 1.5:
                        if temp_direction[0,0] < 0:
                           temp_direction[0,0]=temp_direction[0,0]+x_axis[0]
                        elif temp_direction[0,0] > 0:
                           temp_direction[0,0]=temp_direction[0,0]-x_axis[0]
                    elif abs(temp_direction[0,1]) > 1.5:
                        if temp_direction[0,1] < 0:
                           temp_direction[0,1]=temp_direction[0,1]+y_axis[1]
                           temp_direction[0,0]=temp_direction[0,0]+y_axis[0]
                        elif temp_direction[0,1] > 0:
                            temp_direction[0,1]=temp_direction[0,1]-y_axis[1]
                            temp_direction[0,0]=temp_direction[0,0]-y_axis[0]
                polarization_file[line_num,(c*15+9):(c*15+12)]=temp_direction[0,0:3] 
            line_num=line_num+1    

# check if all vector component value smaller than 1.5
length_new_file=int(len(polarization_file))
for oo in range(0,length_new_file):
    for pp in range(0,2):
        for uu in range(0,3):
            if abs(polarization_file[oo,pp*15+9+uu]) >= 1.5 and abs(polarization_file[oo,pp*15+9+uu]) == 0:
                print('The line num {} in the file, the {} H, the {} [x1, y2, z3], has the problem!'.format(oo+1,pp+1,uu+1))
down_dir=[0,0,-1]
abs_down_dir=math.sqrt(down_dir[0]**2+down_dir[1]**2+down_dir[2]**2)
for d in range(0,length_all_H):
    for ddd in range(0,2):
        abs_OH=math.sqrt(polarization_file[d,ddd*15+9]**2+polarization_file[d,ddd*15+10]**2+polarization_file[d,ddd*15+11]**2)
        OH_M_dir=down_dir[0]*polarization_file[d,ddd*15+9]+down_dir[1]*polarization_file[d,ddd*15+10]+down_dir[2]*polarization_file[d,ddd*15+11]
        COS_theta=OH_M_dir/(abs_down_dir*abs_OH)
        polarization_file[d,ddd*15+12]=COS_theta
        theta=np.arccos(COS_theta)/math.pi*180
        polarization_file[d,ddd*15+13]=theta
        if theta > 90:
            polarization_file[d,ddd*15+14]=-1
        elif theta <= 90:
            polarization_file[d,ddd*15+14]=1

np.savetxt('final_polarization_file', polarization_file, fmt="%s", delimiter='   ')
EOF
############
#Python end#
############

#################################
#Python, get ratio for each area#
#################################
cat << EOF > Python_ratio_OH.py

import numpy as np
import math

degree=${degree_for_all}
#line_separate=${Water_layer_thikness}
total_step=${total_water_num}

water_layer_num=${Water_layer_num}

#loading the dataset
position_angle=np.genfromtxt('final_polarization_file', delimiter='')
protonH_step=np.genfromtxt('final_PWOH_bonding_each_step_first', delimiter='')

length_step=int(len(protonH_step))
results_num_OH=np.zeros(shape=(length_step,water_layer_num+1))

line_rwo=0
for na in range(0,length_step):
    results_num_OH[na,0]=na+1
    num_line=int(total_step-protonH_step[na,1])
    for nb in range(0,num_line):
        for nc in range(0,2):
            if position_angle[line_rwo,(15*nc+13)] > (180-degree) or position_angle[line_rwo,(15*nc+13)] < degree:
                results_num_OH[na,1]=results_num_OH[na,1]+1
        line_rwo=line_rwo+1

np.savetxt('num_OH', results_num_OH, fmt="%s", delimiter='   ')

EOF
############
#Python end#
############

############################################
#Python, find the number of H per unit area#
############################################
cat << EOF > Python_OH_num_per_unitarea.py

import numpy as np
import math

water_layer_num=${Water_layer_num}

# load the file needed
NUM_OH=np.genfromtxt('num_OH_${Water_layer_num}_${degree_for_all}',delimiter='')
length_file=int(len(NUM_OH))

def calc_area(p1, p2, p3):
        (x1, y1),(x2, y2),(x3, y3) = p1,p2,p3
        return abs(x1*y2-x2*y1+x2*y3-x3*y2+x3*y1-x1*y3)

one_axis = (${AxisOxy})
two_axis = (${AxisTxy})
three_axis = (${AxisRxy})
area_angstrom = calc_area(one_axis, two_axis, three_axis)  # m square
area_nm=area_angstrom*10**(-2)*2   # using nm as the unit

final_num_OH=np.zeros(shape=(length_file,water_layer_num*2+1))
for ma in range(0,length_file):
    final_num_OH[ma,0:2]=NUM_OH[ma,0:2]
    for mb in range(0,water_layer_num):
        final_num_OH[ma,water_layer_num+mb+1]=NUM_OH[ma,mb+1]/area_nm

averaged_OH_PM=np.zeros(shape=(2,water_layer_num+1))
for mc in range(0,water_layer_num):
    averaged_OH_PM[0,mc]=np.mean(final_num_OH[:,water_layer_num+1+mc])
    averaged_OH_PM[1,mc]=np.std(final_num_OH[:,water_layer_num+1+mc])
    print("The {}st layer of water has averaged {} number of the OH directing towareds the O surface from MXene\n".format(mc+1,averaged_OH_PM[0,mc]))
    print("The {}st layer of water has standard deviation {} number of the OH directing towareds the O surface from MXene\n".format(mc+1,averaged_OH_PM[1,mc]))

averaged_OH_PM[0,-1]=np.mean(averaged_OH_PM[0,0:water_layer_num])
averaged_OH_PM[1,-1]=averaged_OH_PM[1,0]
print("The averaged {} number of the OH directing towareds the O surface from MXene\n".format(averaged_OH_PM[0,-1]))
print("The standard deviation {} number of the OH directing towareds the O surface from MXene\n".format(averaged_OH_PM[1,-1]))

np.savetxt('final_num_OH_ratio',final_num_OH,fmt="%s", delimiter='   ')

EOF
############
#Python end#
############

################  
#Linux commands#  
################ 
#Perform the first Python script 
python Python_polarization_OH_water.py >> Python_second.log
rm Python_polarization_OH_water.py

awk '{printf("%4d %4d %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %4d %4d %4d %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %4d\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30)}' final_polarization_file > final_polarization_file_temp
mv final_polarization_file_temp final_polarization_file
rm WO_position

#Perform the second Python script 
python Python_ratio_OH.py >> Python_second.log
rm Python_ratio_OH.py

t_col=`echo ${Water_layer_num}'+'1 | bc`
touch num_OH_temp
for ((u=1; u<=${t_col};u++))
do
  awk '{printf("%5d\n",$('${u}'))}' num_OH > temp
  paste num_OH_temp temp > final_num_OH
  mv final_num_OH num_OH_temp
done
rm temp num_OH
mv num_OH_temp num_OH_${Water_layer_num}_${degree_for_all}

#Perform the third Python script 
python Python_OH_num_per_unitarea.py >> Python_second.log
rm Python_OH_num_per_unitarea.py

tt_col=`echo ${Water_layer_num}'+'2 | bc`
ttt_col=`echo ${Water_layer_num}'*'2'+'1 | bc`
touch num_OH_ratio
for ((u=${tt_col}; u<=${ttt_col};u++))
do
  awk '{printf("%15.8f\n",$('${u}'))}' final_num_OH_ratio > temp
  paste num_OH_ratio temp > num_OH_ratio_temp
  mv num_OH_ratio_temp num_OH_ratio
done
rm temp final_num_OH_ratio
mv num_OH_ratio num_OH_ratio_${Water_layer_num}_${degree_for_all}
paste num_OH_${Water_layer_num}_${degree_for_all} num_OH_ratio_${Water_layer_num}_${degree_for_all} > final_num_OH_ratio_${Water_layer_num}_${degree_for_all}
rm num_OH_${Water_layer_num}_${degree_for_all} num_OH_ratio_${Water_layer_num}_${degree_for_all} final_H_list_step_second
