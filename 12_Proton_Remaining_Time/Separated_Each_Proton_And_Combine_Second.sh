#Separated all of the traj to the proton

#load the Python3 environment
module load python/3.6.0

#Definition of variables
#The number of protons in the system
total_proton_num=`echo 2`  #You can modify.

for ((o=1;o<=${total_proton_num};o++))
do
   cd proton_id_${o}
   #echo "   15000      0      0" >> Final_Surface_proton_time_period   #You can modify 15000
   echo "   15000      0      0" >> Final_Total_proton_time_period   #You can modify 15000
   #echo "   15000      0      0" >> Final_Water_proton_time_period   #You can modify 15000
   cd ..
done

##The O index from Surface
##If the indexes have an order
SO_St=`echo 33`  #You can modify.
SO_En=`echo 64`  #You can modify.
interger_SO=`echo 1`  #You can modify.
echo "${SO_St}" >> index_SO_temp
for ((i=${SO_St}+${interger_SO}; i<=${SO_En}; i+=${interger_SO}))   #i+
do
  echo ",$i" >> index_SO_temp
done
cat index_SO_temp | xargs > index_SO
SO_temp=(`echo $(grep "," index_SO)`)
SurfaceO=`echo ${SO_temp[@]} | sed 's/ //g'`
rm index_SO index_SO_temp
##If the index does not have an order
#SurfaceO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)

##The O index from Water
##If the indexes have an order
WO_St=`echo 65`  #You can modify.
WO_En=`echo 76`  #You can modify.
interger_WO=`echo 1`  #You can modify.
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
#WaterO=(83,85,87,93,95,97,99,05,107,113)

#######################################
#Python, get integrated along the time#
#######################################
cat << EOF > get_integration.py
# obtain the integrations
# load the right environments
import numpy as np
import math

initial_step=1
final_step=15000
Surface_O_index=[${SurfaceO[@]}]
Water_O_index=[${WaterO[@]}]

data_total=np.genfromtxt('Final_Total_proton_time_period', delimiter='')
max_row_total=len(data_total)

result_total=np.zeros(shape=(final_step,4))

limit_total=0
relax_time_total=0

for y in range(1,final_step):
    right_line_total=0
    num_time_total=0
    result_total[y-1,0]=y
    for yy in range(initial_step,final_step+1):
        temp_tfin=yy+y
        if temp_tfin > final_step:
            break
        num_time_total=num_time_total+1
        if yy >= data_total[right_line_total+1,0]:
            right_line_total=right_line_total+1
        if temp_tfin <  data_total[right_line_total+1,0]:
            result_total[y-1,1]=result_total[y-1,1]+1
    if result_total[y-1,1] == 0:
        limit_total=limit_total+1
    if limit_total == 400:
        break
    result_total[y-1,1]=result_total[y-1,1]/num_time_total
    relax_time_total=relax_time_total+result_total[y-1,1]

print("The relaxation time for this proton total is {}".format(relax_time_total))

limit_water=0
limit_surface=0
relax_time_surface=0
relax_time_water=0

for y in range(1,final_step):
    right_line_total=0
    num_time_total=0
    for yy in range(initial_step,final_step+1):
        temp_tfin=yy+y
        if temp_tfin > final_step:
            break
        num_time_total=num_time_total+1
        if yy >= data_total[right_line_total+1,0]:
            right_line_total=right_line_total+1
        if temp_tfin <  data_total[right_line_total+1,0] and (data_total[right_line_total,1] in Water_O_index):
            result_total[y-1,2]=result_total[y-1,2]+1
        elif temp_tfin <  data_total[right_line_total+1,0] and (data_total[right_line_total,1] in Surface_O_index):
            result_total[y-1,3]=result_total[y-1,3]+1
    if result_total[y-1,2] == 0:
        limit_water=limit_water+1
    if result_total[y-1,3] == 0:
        limit_surface=limit_surface+1
    if limit_water >= 50 and limit_surface >= 50:
        break
    result_total[y-1,2]=result_total[y-1,2]/num_time_total
    result_total[y-1,3]=result_total[y-1,3]/num_time_total
    relax_time_water=relax_time_water+result_total[y-1,2]
    relax_time_surface=relax_time_surface+result_total[y-1,3]

print("The relaxation time for this proton water is {}".format(relax_time_water))
print("The relaxation time for this proton surface is {}".format(relax_time_surface))

np.savetxt('result_total_integration_temp', result_total, fmt="%s", delimiter='   ')
EOF
########################
#End of the python file#
########################

#############################
#Linux data processing codes#
#############################
for ((pp=1;pp<=${total_proton_num};pp++))
do
  cp get_integration.py proton_id_${pp}
  cd proton_id_${pp}
  python get_integration.py >> proton_id_${pp}.log
  awk '{printf("%8d %15.8f %15.8f %15.8f\n",$1,$2,$3,$4)}' result_total_integration_temp > result_total_integration
  rm result_total_integration_temp
  rm get_integration.py
  cd ..
done

rm get_integration.py
