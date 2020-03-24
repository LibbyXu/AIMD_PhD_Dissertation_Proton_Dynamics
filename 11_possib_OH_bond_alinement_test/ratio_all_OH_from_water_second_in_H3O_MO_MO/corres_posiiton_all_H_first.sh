#We need three file: Final_O_uporder_list_Final, WOH_position, WO_position

#For each step in trajectory, how many H atoms does that has?
module load python/3.6.0

#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`

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

total_water_num=`echo ${WO_En}'-'${WO_St}'+'1 | bc`
total_H_num=`echo ${total_water_num}'*'2'+'${total_proton_num} | bc`

#######################################################################
# Python file to count the number of the H bonding to the O in water (inclduing the bprotons) for each step
#######################################################################
cat << EOF > Python_NUM_H_AND_positioni_First.py
import numpy as np
import math

total_step=${total_water_num}
Water_O_index=[${WaterO[@]}]
proton_num_whole=${total_proton_num}

# loading the dataset
if int(proton_num_whole)!=0:
    data_protn_binded_O_list = np.genfromtxt('Final_O_uporder_list_Final', delimiter='')
    length_data=int(len(data_protn_binded_O_list))
    data_OH_bonding_each_step=np.zeros(shape=(length_data,proton_num_whole+3))
    for i in range(0,length_data):
        data_OH_bonding_each_step[i,0]=i+1
        wholeP_ct=0
        for ii in range(0,proton_num_whole):
            if data_protn_binded_O_list[i,ii+1] in Water_O_index:
                wholeP_ct=wholeP_ct+1
                if wholeP_ct != 0:
                    data_OH_bonding_each_step[i,wholeP_ct+1]=data_protn_binded_O_list[i,ii+1]
                elif data_protn_binded_O_list[i,ii+1] not in Water_O_index:
                    data_OH_bonding_each_step[i,ii+2]=0
        data_OH_bonding_each_step[i,1] = wholeP_ct
        data_OH_bonding_each_step[i,-1] = wholeP_ct+total_step*2
elif int(proton_num_whole)==0:
    just_line = np.genfromtxt('WO_position',delimiter='')
    just_num = int(len(just_line)/total_step)
    data_protn_binded_O_list=np.zeros(shape=(just_num,1))
    length_data=int(len(data_protn_binded_O_list))
    for pa in range(0,length_data):
        data_protn_binded_O_list[pa,0]=pa+1
    np.savetxt('Final_O_uporder_list_Final',data_protn_binded_O_list, fmt="%s", delimiter='   ')
    data_OH_bonding_each_step=np.zeros(shape=(length_data,proton_num_whole+3))
    for pb in range(0,length_data):
        data_OH_bonding_each_step[pb,0]=pb+1
        data_OH_bonding_each_step[pb,1]=0
        data_OH_bonding_each_step[pb,-1] = total_step*2

np.savetxt('PWOH_bonding_each_step_first', data_OH_bonding_each_step, fmt="%s", delimiter='   ')
EOF
#######################################################################
#First Python script end
#######################################################################

#######################################################################
#At the same time, create the list of the H positions for each step
#######################################################################
cat << EOF > Python_H_Position_each_step_second.py
import numpy as np
import math

total_step=${total_water_num}
proton_num_whole=${total_proton_num}

# loading the dataset
data_H_list = np.genfromtxt('WOH_position', delimiter='')
num_each_step = np.genfromtxt('final_PWOH_bonding_each_step_first', delimiter='')
each_WO_position = np.genfromtxt('WO_position', delimiter='')
length_data=int(len(num_each_step))

H_list_step = np.zeros(shape=(${total_H_num}*length_data,5))
corres_O_W_num = np.zeros(shape=(total_step*length_data,2))

line_name=0
for aa in range(0,length_data):
    step_H_total = 0
    for bb in range(0,total_step):
        corres_O_W_num[aa*total_step+bb,0] = each_WO_position[aa*total_step+bb,1]
        step_H_total = step_H_total+2
        for dd in range(0,2):
            H_list_step[line_name,0:5] = data_H_list[aa*total_step+bb,6*dd+1:6*(dd+1)]
            line_name = line_name+1
        if int(proton_num_whole)!=0:
            for cc in range(0,proton_num_whole):
                if int(num_each_step[aa,2+cc]) == each_WO_position[aa*total_step+bb,1]:
                    H_list_step[line_name,0:5]=data_H_list[aa*total_step+bb,(6*2+1):(6*(2+1))]
                    line_name=line_name+1
                    corres_O_W_num[aa*total_step+bb,1] = 1
                    step_H_total = step_H_total+1

llll=0
for rr in range(0,${total_H_num}*length_data):
    if H_list_step[rr,0]!=0:
        llll=llll+1
    elif H_list_step[rr,0]==0:
        break

if llll != ${total_H_num}*length_data:
    for ll in range(llll,${total_H_num}*length_data):
        H_list_step=np.delete(H_list_step,llll,0)

np.savetxt('H_list_step_second', H_list_step, fmt="%s", delimiter='   ')
np.savetxt('corres_O_W_num_second', corres_O_W_num, fmt="%s", delimiter='   ')

check_list=np.zeros(shape=(length_data,2))
for ff in range(0,length_data):
    check_list[ff,0]=ff+1
    H_estep=0
    for gg in range(0,total_step):
        if int(corres_O_W_num[ff*total_step+gg,1]) == 1:
                H_estep=H_estep+1
                check_list[ff,1]=H_estep
    if check_list[ff,1] != num_each_step[ff,1]:
        print("The Proton num doesn't match each other in step {}!".format(ff+1))

EOF
#######################################################################
#Second Python script end
#######################################################################

#######################################################################
#######################################################################
python Python_NUM_H_AND_positioni_First.py >> Python_first.log
rm Python_NUM_H_AND_positioni_First.py

total_column=`echo ${total_proton_num}'+'3 | bc`
touch final_PWOH_bonding_each_step_first
for ((s=1; s<=${total_column}; s++))
do
awk '{printf("%5d\n",$('${s}'))}' PWOH_bonding_each_step_first > temp
paste final_PWOH_bonding_each_step_first temp > final_PWOH_bonding_each_step_first_temp
mv final_PWOH_bonding_each_step_first_temp final_PWOH_bonding_each_step_first
done
rm PWOH_bonding_each_step_first temp

########################################################################
########################################################################
python Python_H_Position_each_step_second.py >> Python_first.log
rm Python_H_Position_each_step_second.py

awk '{printf("%5d %15.8f %15.8f %15.8f %15.8f\n",$1,$2,$3,$4,$5)}' H_list_step_second > final_H_list_step_second
rm H_list_step_second

rm WOH_position Final_O_uporder_list_Final


