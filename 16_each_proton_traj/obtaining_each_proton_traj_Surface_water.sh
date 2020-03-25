# The only file we need is the Final_O_uporder_list_Final

#load the pyrhon3 environment
module load python/3.6.0

#Definition of variables
total_proton_num=`echo 2`
#The O index at interfaical surface

SO_St=`echo 33`
SO_En=`echo 64`
interger_SO=`echo 1`
echo "${SO_St}" >> index_SO_temp
for ((i=${SO_St}+${interger_SO}; i<=${SO_En}; i+=${interger_SO}))
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
for ((i=${WO_St}+${interger_WO}; i<=${WO_En}; i+=${interger_WO}))
do
echo ",$i" >> index_WO_temp
done
cat index_WO_temp | xargs > index_WO
WO_temp=(`echo $(grep "," index_WO)`)
WaterO=`echo ${WO_temp[@]} | sed 's/ //g'`
rm index_WO index_WO_temp

#WaterO=(115,116,117,118,119,120,121,122,123,124,125,126)

###################################################################
# Python for all traj, the proton (continues) in water or suface
###################################################################
cat << EOF > obtainging_S_W_all_traj.py
import numpy as np
import math

data_SOi = [${SurfaceO[@]}]
data_WOi = [${WaterO[@]}]
total_proton_num=${total_proton_num}

Whole_proton_index=np.genfromtxt('Final_O_uporder_list_Final', delimiter='')
len_file=len(Whole_proton_index)

surface_water=np.zeros(shape=(len_file,total_proton_num*2+1))

# water layer O ==== 0
# surface layer 0 ==== 1
for i in range(0,len_file):
    surface_water[i,0]=Whole_proton_index[i,0]
    for ii in range(0,total_proton_num):
        surface_water[i,2*ii+1]=Whole_proton_index[i,ii+1]
        if surface_water[i,2*ii+1] in data_SOi:
            surface_water[i,2*ii+2]=1
        elif surface_water[i,2*ii+1] in data_WOi:
            surface_water[i,2*ii+2]=0

np.savetxt('SO_WO_index_all_traj', surface_water, fmt="%s", delimiter='   ')
EOF
###################################################################
# End of the python file
###################################################################
python obtainging_S_W_all_traj.py > python.log
rm *.py*
awk '{printf("%8d %8d %4d %8d %4d\n", $1,$2,$3,$4,$5)}' SO_WO_index_all_traj > final_SO_WO_index_all_traj
rm SO_WO_index_all_traj








