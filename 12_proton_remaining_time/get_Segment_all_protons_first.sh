#Get the segment for different proton within the trajectory
#The whole and then separated to surface O and water O
#All three parts (whole,surface,water) will be remaining here

#load the pyrhon3 environment
module load python/3.6.0

#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`
#Define the index num for the O in water and Surface, if your index has an order
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

for ((i=1;i<=${total_proton_num};i++))
do
mkdir proton_id_${i}
awk '{printf("%8d %6d\n"),$1,$('${i}'+1)}' Final_O_uporder_list_Final > temp_time_proton_${i}
mv temp_time_proton_${i} proton_id_${i}
cd proton_id_${i}
mv temp_time_proton_${i} time_proton
cd ..
done

#######################################################################
# get the time segment for different protons in traj 
#######################################################################
cat << EOF > Python_get_time_seg_proton_one.py
# Writing script to get the timeperiod that the proton will bind to the smae O
# The O here no matter it is from water or from the surface O from the MXene
import numpy as np
import math

num_protons=${total_proton_num}
Surface_O_index=[${SurfaceO[@]}]
Water_O_index=[${WaterO[@]}]

# load the data file
data_pro_t_idx=np.genfromtxt('time_proton', delimiter='')
len_total=len(data_pro_t_idx)

result_tp=np.zeros(shape=(len_total,2))
temp_index=np.zeros(2)

temp_index=data_pro_t_idx[0,:]
result_tp[0,:]=data_pro_t_idx[0,:]

line_row_idx=1
for i in range(1,len_total):
    if data_pro_t_idx[i,1] != temp_index[1]:
        result_tp[line_row_idx,:] = data_pro_t_idx[i,:]
        line_row_idx=line_row_idx+1
        temp_index=data_pro_t_idx[i,:]

for ii in range(line_row_idx,len_total):
    result_tp=np.delete(result_tp,line_row_idx,0)
    
change_time=line_row_idx
#create time period
each_period=np.zeros(shape=(change_time-1,3))

for iii in range(0,change_time-1): 
    each_period[iii,0:2]=result_tp[iii,0:2]
    each_period[iii,2]=result_tp[iii+1,0]-result_tp[iii,0]

np.savetxt('Total_proton_time_period', each_period, fmt="%s", delimiter='   ')

water_O_TP=np.zeros(shape=(change_time-1,3))
surface_O_TP=np.zeros(shape=(change_time-1,3))

l_water=0
l_surface=0
for aa in range(0,change_time-1):
    if each_period[aa,1] in Surface_O_index:
        surface_O_TP[l_surface,:]=each_period[aa,:]
        l_surface=l_surface+1
    elif each_period[aa,1] in Water_O_index:
        water_O_TP[l_water,:]=each_period[aa,:]
        l_water=l_water+1
    else:
        print("Something Wrong happened, total transfer file step {} it is not an Oxygen from the surface O of the MXene or water".format(aa+1))

for o in range(l_surface,change_time-1):
    surface_O_TP=np.delete(surface_O_TP,l_surface,0)
    
for oo in range(l_water,change_time-1):
    water_O_TP=np.delete(water_O_TP,l_water,0)

np.savetxt('Water_proton_time_period', water_O_TP, fmt="%s", delimiter='   ')
np.savetxt('Surface_proton_time_period', surface_O_TP, fmt="%s", delimiter='   ')

EOF
#######################################################################
# First Python script end
#######################################################################
for ((ii=1;ii<=${total_proton_num};ii++))
do
cp Python_get_time_seg_proton_one.py proton_id_${ii}
cd proton_id_${ii}
python Python_get_time_seg_proton_one.py > proton_id_${ii}.log
rm Python_get_time_seg_proton_one.py
awk '{printf("%8d %6d %6d\n",$1,$2,$3)}' Total_proton_time_period > Final_Total_proton_time_period
awk '{printf("%8d %6d %6d\n",$1,$2,$3)}' Water_proton_time_period > Final_Water_proton_time_period
awk '{printf("%8d %6d %6d\n",$1,$2,$3)}' Surface_proton_time_period > Final_Surface_proton_time_period
rm Total_proton_time_period Water_proton_time_period Surface_proton_time_period
cd ..
done

rm Python_get_time_seg_proton_one.py










