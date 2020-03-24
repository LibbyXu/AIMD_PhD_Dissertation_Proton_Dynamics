#For this work, we need one file Final_O_uporder_list_Final 

#load the pyrhon3 environment
#module load python/3.6.0

#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`
time_period=`echo 15`  # ps (pico second)
#Define the index num for the O in water and Surface, if your index has certain order, you cam create a loop
#SurfaceO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)
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

#WaterO=(115,116,117,118,119,120,121,122,123,124,125,126)
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

#The x y position for the area for calculating the area 
AxisOxy=(12.1003999709999999,0.0000000000000000)
AxisTxy=(-6.0494949460000003,10.4798920380999991)
AxisRxy=(0.0000000000000000,0.0000000000000000)
#With water or no water lattice
No_w_hight=`echo 9.75`
No_w_middle_Mxene=`echo 0`
With_w_hight=`echo 13.0`
With_w_middle_Mxene=`echo 0`

#Some other variables that is convenient to use
num_water=`echo ${WaterO[0]} | awk -F "," '{print NF}'`

########################################################################################################################
# Python dealing with calculting the proton transfer rate
########################################################################################################################
cat << EOF > calculate_the_proton_transfer_rate_plots.py
# Load the two Proton binede Oxygen files
import numpy as np
import math

proton_num = ${total_proton_num}
data_proton = np.genfromtxt('Final_O_uporder_list_Final', delimiter='')
#print('The data set has the following look: ', data_proton)

step_num = data_proton[:,0]   # steps assigned to step_num
proton_total = data_proton[:,1:(proton_num+1)] # proton_one num assigned to proton_one
#print(step_num)
#print(proton_total)
len_step=len(step_num)      #number of steps
len_proton_total=len(proton_total[:,0])

if len_step==len_proton_total:
    print('The total steps invovled in our calculations is: ', len_step)
else:    
    print('The total steps for your scripts is Wrong')
    print('The number of steps: ', len_step)
    print('The number of steps for proton: ', len_proton_total)
    
# calculate the cases: ss, sw, ws, and ww
# The oxygen in water has the following index: 83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113
# The oxygen on surface has the following index: 115,116,117,118,119,120,121,122,123,124,125,126
Surface_O_index = [${SurfaceO[@]}]
Water_O_index =[${WaterO[@]}]

# We have the following cases:
# 1: ss; 2: sw; 3: ws; 4: ww; 0: no change   
count_num_proton = np.zeros(shape=(len_step-1,proton_num))

ss_total = np.zeros(proton_num)
sw_total = np.zeros(proton_num)
ws_total = np.zeros(proton_num)
ww_total = np.zeros(proton_num)
nochange_stayW = np.zeros(proton_num)
nochange_stayS = np.zeros(proton_num)

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
        print('\nCalculations for proton {} are right!'.format(nn+1))
    else:
        print('\nError happened for proton {} calculation!'.format(nn+1))
    
    print('The dance of the proton {} is: {}'.format(nn+1,count_num_proton[:,nn]))
    print('For the #{} proton: '.format(nn+1))
    print('Surface-Surface number is: {}'.format(int(ss_total[nn])))
    print('Water-Surface number is: {}'.format(int(ws_total[nn])))
    print('Surface-Water number is: {}'.format(int(sw_total[nn])))
    print('Water-Water number is: {}'.format(int(ww_total[nn])))
    print('Stay in same water num: {}'.format(int(nochange_stayW[nn])))
    print('Stay in same surface-O num: {}'.format(int(nochange_stayS[nn])))

	
# Calculate the rate
Avogadro_constant = 6.022140857*10**23
#time_total_surface_redox = sw_total_two+ws_total_two+sw_total_one+ws_total_two # unit:s
time_total_surface_redox = sum(sw_total) # unit:s
time_redox = time_total_surface_redox/Avogadro_constant
time_total_water_trasfer = sum(ww_total)
time_water = time_total_water_trasfer/Avogadro_constant

def calc_area(p1, p2, p3):
        (x1, y1),(x2, y2),(x3, y3) = p1,p2,p3
        return 0.5*abs(x1*y2-x2*y1+x2*y3-x3*y2+x3*y1-x1*y3) 
one_axis = (${AxisOxy})
two_axis = (${AxisTxy})
three_axis = (${AxisRxy})
area_angstrom = calc_area(one_axis, two_axis, three_axis)  # m square
#print('\nThe area calculated are (Angstrom square): ',area_angstrom)
area_m = 2*area_angstrom*(10**-10)**2

proton_mol = proton_num/Avogadro_constant
fs_total_s = len_step*10**(-15)

# Without concentration_proton 
rate_temp = time_redox/(area_m*2)/fs_total_s
#print('\nWithout concentration: ',rate_temp)

# With concentration_proton 
no_water_lattice = ${No_w_hight}-${No_w_middle_Mxene}
With_water_lattice = ${With_w_hight}-${With_w_middle_Mxene}
Lactice_z_change = With_water_lattice-no_water_lattice
volumn = Lactice_z_change*2*area_angstrom*(10**-10)**3  # unite m3
concentration_proton = proton_mol/volumn
rate = time_redox/(2*area_m)/fs_total_s/concentration_proton
rate_water = time_water/(2*area_m)/fs_total_s/concentration_proton
print('\nThe rate constant of the redox reaction (unit: m*s-1) is: ',rate)
print('\nThe rate constant of the proton transfer from one water to another water (unit: m*s-1) is: ',rate_water)

# WATER density
water_density = ${num_water}/Avogadro_constant*18.0153/volumn/1000000 
print('\nWater density in my system (g*cm-3): ',water_density)	
	
EOF
##################################################################################################################
#Python script end
##################################################################################################################
python3 calculate_the_proton_transfer_rate_plots.py > python.log

rm *.py*


########################################################################################################################
# Python dealing with calculting the proton transfer rate
########################################################################################################################
cat << EOF > calculate_the_proton_transfer_rate_plots_Windows.py
# Load the two Proton binede Oxygen files
import numpy as np
import math

proton_num = ${total_proton_num}
data_proton = np.genfromtxt('Final_O_uporder_list_Final', delimiter='')

step_num = data_proton[:,0]   # steps assigned to step_num
proton_total = data_proton[:,1:(proton_num+1)] # proton_one num assigned to proton_one
len_step=len(step_num)      #number of steps
len_proton_total=len(proton_total[:,0])

if len_step==len_proton_total:
    print('The total steps invovled in our calculations is: ', len_step)
else:    
    print('The total steps for your scripts is Wrong')
    print('The number of steps: ', len_step)
    print('The number of steps for proton: ', len_proton_total)
    
# calculate the cases: ss, sw, ws, and ww
# The oxygen in water has the following index: 83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113
# The oxygen on surface has the following index: 115,116,117,118,119,120,121,122,123,124,125,126
Surface_O_index = [${SurfaceO[@]}]
Water_O_index =[${WaterO[@]}]

# We have the following cases:
# 1: ss; 2: sw; 3: ws; 4: ww; 0: no change   
count_num_proton = np.zeros(shape=(len_step-1,proton_num))

ss_total = np.zeros(proton_num)
sw_total = np.zeros(proton_num)
ws_total = np.zeros(proton_num)
ww_total = np.zeros(proton_num)
nochange_stayW = np.zeros(proton_num)
nochange_stayS = np.zeros(proton_num)

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
        print('\nCalculations for proton {} are right!'.format(nn+1))
    else:
        print('\nError happened for proton {} calculation!'.format(nn+1))
    
    print('The dance of the proton {} is: {}'.format(nn+1,count_num_proton[:,nn]))
    print('For the #{} proton: '.format(nn+1))
    print('Surface-Surface number is: {}'.format(int(ss_total[nn])))
    print('Water-Surface number is: {}'.format(int(ws_total[nn])))
    print('Surface-Water number is: {}'.format(int(sw_total[nn])))
    print('Water-Water number is: {}'.format(int(ww_total[nn])))
    print('Stay in same water num: {}'.format(int(nochange_stayW[nn])))
    print('Stay in same surface-O num: {}'.format(int(nochange_stayS[nn])))

	
# Calculate the rate
Avogadro_constant = 6.022140857*10**23
#time_total_surface_redox = sw_total_two+ws_total_two+sw_total_one+ws_total_two # unit:s
time_total_surface_redox = sum(sw_total) # unit:s
time_redox = time_total_surface_redox/Avogadro_constant
time_total_water_trasfer = sum(ww_total)
time_water = time_total_water_trasfer/Avogadro_constant

def calc_area(p1, p2, p3):
        (x1, y1),(x2, y2),(x3, y3) = p1,p2,p3
        return 0.5*abs(x1*y2-x2*y1+x2*y3-x3*y2+x3*y1-x1*y3) 
one_axis = (${AxisOxy})
two_axis = (${AxisTxy})
three_axis = (${AxisRxy})
area_angstrom = calc_area(one_axis, two_axis, three_axis)  # m square
area_m = 2*area_angstrom*(10**-10)**2

proton_mol = proton_num/Avogadro_constant
fs_total_s = len_step*10**(-15)

# Without concentration_proton 
rate_temp = time_redox/(2*area_m)/fs_total_s

# With concentration_proton 
no_water_lattice = ${No_w_hight}-${No_w_middle_Mxene}
With_water_lattice = ${With_w_hight}-${With_w_middle_Mxene}
Lactice_z_change = With_water_lattice-no_water_lattice
volumn = Lactice_z_change*2*area_angstrom*(10**-10)**3  # unite m3
concentration_proton = proton_mol/volumn
rate = time_redox/(2*area_m)/fs_total_s/concentration_proton
rate_water = time_water/(2*area_m)/fs_total_s/concentration_proton
print('\nThe rate constant of the redox reaction (unit: m*s-1) is: ',rate)
print('\nThe rate constant of the proton transfer from one water to another water (unit: m*s-1) is: ',rate_water)

# WATER density
water_density = ${num_water}/Avogadro_constant*18.0153/volumn/1000000 
print('\nWater density in my system (g*cm-3): ',water_density)	


#Plotting
count_proton_ww = np.zeros(shape=(len_step-1,proton_num))
count_proton_ws = np.zeros(shape=(len_step-1,proton_num))

for uu in range(0,proton_num):
    for i in range(0,len_step-1):
        temp_proton_cal_f = int(proton_total[i,uu])
        temp_proton_cal_s = int(proton_total[i+1,uu])
        if (temp_proton_cal_f in Surface_O_index) and (temp_proton_cal_s in Water_O_index):
             count_proton_ws[i,uu] = 1        
        elif (temp_proton_cal_f in Water_O_index) and (temp_proton_cal_s in Surface_O_index):
             count_proton_ws[i,uu] = 1
        elif (temp_proton_cal_f in Water_O_index) and (temp_proton_cal_s in Water_O_index):
            if temp_proton_cal_f != temp_proton_cal_s: 
                count_proton_ww[i,uu] = 1

total_proton_transfer_ww = np.zeros(len_step-1)
total_proton_transfer_ws = np.zeros(len_step-1)

for i in range(0,len_step-1):
    total_proton_transfer_ws[i] = sum(count_proton_ws[i,:])
    total_proton_transfer_ww[i] = -(sum(count_proton_ww[i,:]))
 
print('total transfer between water and surface: ',total_proton_transfer_ws)    
print('total transfer between water and water: ',total_proton_transfer_ww)    

import matplotlib
import matplotlib.pyplot as plt
from IPython.core.pylabtools import figsize

font1 = {'family':'Times New Roman','weight':'normal','size': 12} 
fs_to_ps = np.zeros(len_step-1)
for a in range(0,len_step-1):
    fs_to_ps[a] = a/1000
temp_zeros = np.zeros(len_step-1)

plt.plot(fs_to_ps, total_proton_transfer_ws, marker='.', color='green',markerfacecolor='green', markersize=4, linewidth=0.3,label = 'surface redox reaction',alpha=0.4)
hl=plt.legend(loc='upper right', prop=font1, frameon=False)  
plt.plot(fs_to_ps, total_proton_transfer_ww, marker='.', color='orange',markerfacecolor='orange', markersize=4,linewidth=0.3,label = 'in-water transfer',alpha=0.4)
h2=plt.legend(loc='upper right', prop=font1, frameon=False)  

plt.xticks(np.arange(0, 21, 1))
plt.yticks(np.arange(-5, 5, 1))
plt.ylim(-3.2, 3.2)                                              
plt.xlim(0, ${time_period})
plt.xlabel('Time [ps]',font1)
plt.yticks([-3,-2,-1,0,1,2,3],["3","2","1","0","1","2","3"])
plt.ylabel('Number of proton transfer events',font1)
plt.rcParams['savefig.dpi'] = 300
plt.rcParams['figure.dpi'] = 300

plt.tick_params(axis="x",direction="in")
plt.tick_params(axis="y",direction="in")
plt.rcParams['xtick.labelsize']=8
plt.rcParams['ytick.labelsize']=8
figgca=plt.gca()
figgca.spines['bottom'].set_linewidth(1.2)
figgca.spines['top'].set_linewidth(1.2)
figgca.spines['left'].set_linewidth(1.2)
figgca.spines['right'].set_linewidth(1.2)
figgca.tick_params(width=1.2)

fig = plt.gcf()
fig.set_size_inches(6, 4)
fig.show()
fig.savefig('${total_proton_num}_proton_${num_water}_water_MO_G.png', dpi=300)	
	
EOF
##################################################################################################################
#Python script end
##################################################################################################################
