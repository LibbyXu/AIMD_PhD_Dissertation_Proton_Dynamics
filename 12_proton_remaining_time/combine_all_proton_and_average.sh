#Combine all the proton files and get the average value
#load the needed Python environment
module load python/3.6.0

#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`

mkdir final_combine_average

for ((ii=1;ii<=${total_proton_num};ii++))
do
cd proton_id_${ii}
cp result_total_integration result_total_integration_${ii}
mv result_total_integration_${ii} ../final_combine_average
cd ..
done

cd final_combine_average
touch final_total_proton 
for ((oo=1;oo<=${total_proton_num};oo++))
do
paste final_total_proton result_total_integration_${oo} > final_total_proton_temp
mv final_total_proton_temp final_total_proton
done

############################################################################
#Python code on average the relaxation time value along all time 
############################################################################
cat << EOF > Python_average_value_for_all_protons_time_period.py
#load the needed python environment
import numpy as np
import math

data_total_final=np.genfromtxt('final_total_proton', delimiter='')
len_column=len(data_total_final[0,:])
proton_num=int(len_column/4)
len_row=len(data_total_final)

data_result=np.zeros(shape=(len_row,4))
for uu in range(0,len_row):
    data_result[uu,0]=uu+1
    total=0
    water=0
    surface=0
    for nn in range(0,proton_num):
        total=total+data_total_final[uu,4*nn+1]
        water=water+data_total_final[uu,4*nn+2]
        surface=surface+data_total_final[uu,4*nn+3]        
    for nu in range(1,4):
        if nu == 1:
            data_result[uu,nu]=total/proton_num
        elif nu == 2:
            data_result[uu,nu]=water/proton_num
        elif nu ==3:
            data_result[uu,nu]=surface/proton_num
print("The averaged total proton relaxation time is {}.".format(sum(data_result[:,1])))
print("The averaged water proton relaxation time is {}.".format(sum(data_result[:,2])))
print("The averaged surface proton relaxation time is {}.".format(sum(data_result[:,3])))

np.savetxt('final_averaged_total_water_surface_temp', data_result, fmt="%s", delimiter='   ')
EOF
############################################################################
#End of the python file
############################################################################
python Python_average_value_for_all_protons_time_period.py > pyrhon_third.log

rm Python_average_value_for_all_protons_time_period.py
awk '{printf("%8d %15.8f %15.8f %15.8f\n",$1,$2,$3,$4)}' final_averaged_total_water_surface_temp > final_averaged_total_water_surface
rm final_averaged_total_water_surface_temp
cd ..

