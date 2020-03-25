# We need the proton files from the 12 index folder
# separate surface, water, total average time
#load the needed Python environment
module load python/3.6.0

#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`

for ((ii=1;ii<=${total_proton_num};ii++))
do
cd proton_id_${ii}
cp Final_Surface_proton_time_period Final_Surface_proton_time_period_${ii}
cp Final_Total_proton_time_period Final_Total_proton_time_period_${ii}
cp Final_Water_proton_time_period Final_Water_proton_time_period_${ii}
mv Final_Surface_proton_time_period_${ii} ../
mv Final_Total_proton_time_period_${ii} ../
mv Final_Water_proton_time_period_${ii} ../
cd ..
sed -i '$d' Final_Total_proton_time_period_${ii}
done

touch Total_whole_time_binding
touch Water_whole_time_binding
touch Surface_whole_time_binding
for ((i=1;i<=${total_proton_num};i++))
do
cat Total_whole_time_binding  Final_Total_proton_time_period_${i} > Total_whole_time_binding_temp
cat Water_whole_time_binding Final_Water_proton_time_period_${i} > Water_whole_time_binding_temp
cat Surface_whole_time_binding Final_Surface_proton_time_period_${i} > Surface_whole_time_binding_temp
mv Total_whole_time_binding_temp Total_whole_time_binding
mv Water_whole_time_binding_temp Water_whole_time_binding
mv Surface_whole_time_binding_temp Surface_whole_time_binding
rm -r proton_id_${i}
done

rm *Final_Surface_proton_time_period_*
rm *Final_Total_proton_time_period_*
rm *Final_Water_proton_time_period_*

awk '{printf("%8d %8d\n",$2,$3)}' Total_whole_time_binding > Total_whole_time_binding_final
awk '{printf("%8d %8d\n",$2,$3)}' Water_whole_time_binding > Water_whole_time_binding_final
awk '{printf("%8d %8d\n",$2,$3)}' Surface_whole_time_binding > Surface_whole_time_binding_final

sort -n -k 2 Total_whole_time_binding_final > Sorted_Total_whole_time_binding_final
sort -n -k 2 Water_whole_time_binding_final > Sorted_Water_whole_time_binding_final
sort -n -k 2 Surface_whole_time_binding_final > Sorted_Surface_whole_time_binding_final

rm Total_whole_time_binding Total_whole_time_binding_final
rm Water_whole_time_binding Water_whole_time_binding_final
rm Surface_whole_time_binding Surface_whole_time_binding_final

#######################################################################
# Python Average binding time, Total, Surface, Water
#######################################################################
cat << EOF > Ave_binding_time_total_surface_water.py
#load the needed python environment
import numpy as np
import math

total_proton_num=${total_proton_num}

data_Total=np.genfromtxt('Sorted_Total_whole_time_binding_final', delimiter='')
data_Water=np.genfromtxt('Sorted_Water_whole_time_binding_final', delimiter='')
data_Surface=np.genfromtxt('Sorted_Surface_whole_time_binding_final', delimiter='')
len_Total=len(data_Total)
len_Water=len(data_Water)
len_Surface=len(data_Surface)

Total_time=sum(data_Total[:,1])
print('The total binding time for this {} fs is {}. (The end we did not count)'.format(15000*total_proton_num,Total_time))

if len_Surface!=0:    
    Water_time=sum(data_Water[:,1])
    Surface_time=sum(data_Surface[:,1])

    if int(Water_time+Surface_time)!=int(Total_time):
        print('The Water+Surface binding time dies not match the Total Time!')

    Percent_water=Water_time/Total_time*100   #%
    Percent_surface=Surface_time/Total_time*100   #%

    Average_Total_time=Total_time/len_Total
    Average_Water_time=Water_time/len_Water
    Average_Surface_time=Surface_time/len_Surface
    
    print('The average total time: {}'.format(Average_Total_time))
    print('\nThe water binding time: {}'.format(Water_time))
    print('The percent water time: %{}'.format(Percent_water))
    print('The average water time: {}'.format(Average_Water_time))
    print('\nThe surface binding time: {}'.format(Surface_time))
    print('The percent surface time: %{}'.format(Percent_surface))
    print('The average surface time: {}'.format(Average_Surface_time))
elif len_Surface==0:
    print('\nThere was no surface binding time, which means proton was in the water layer, no surface redox reaction!')
    Water_time=sum(data_Water[:,1])

    if int(Water_time)!=int(Total_time):
        print('The Water+Surface binding time dies not match the Total Time!')

    Percent_water=Water_time/Total_time*100   #%

    Average_Total_time=Total_time/len_Total
    Average_Water_time=Water_time/len_Water
    
    print('The average total time: {}'.format(Average_Total_time))
    print('\nThe water binding time: {}'.format(Water_time))
    print('The percent water time: %{}'.format(Percent_water))
    print('The average water time: {}'.format(Average_Water_time))

EOF
#######################################################################
# End of the python file
#######################################################################
python Ave_binding_time_total_surface_water.py > python.log
rm Ave_binding_time_total_surface_water.py





