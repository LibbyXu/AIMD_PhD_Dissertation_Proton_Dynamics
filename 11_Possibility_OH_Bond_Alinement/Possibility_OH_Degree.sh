#Please give the path to the folder or you can comment ths following line and use this in the current folder
#For this work, we need two files, the first is the POSCAR, and the second is the XDATACAR file

#load the pyrhon3 environment
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
#WaterO=(115,116,117,118,119,120,121,122,123,124,125,126)
#The first index num of H
First_H_index=`echo 125`
#How many steps included in the current XDATCAR file
num_XDATCAR=`echo 500`

#Some other variables that is convenient to use
num_water=`echo ${WaterO[0]} | awk -F "," '{print NF}'`
Final_H_index=`echo ${First_H_index}'+'2'*'${num_water}'+'${total_proton_num}'-'1 | bc`

touch final_WO_position
for ((s=1; s<=${num_XDATCAR}; s++))
do
xdat2pos.pl 1 $s # obtaining the index num for all atoms in water and Surface
mv POSCAR$s.out CONTCAR

touch WO_Position_all
for ((a=${WO_St}; a<=${WO_En}; a++))
do
neighbors.pl CONTCAR $a # getting he neighdist.dat
#index atom_index, distace, position X, Y, Z
awk '{printf("%4d %4d %15.8f %15.8f %15.8f %15.8f\n",$1, $2, $7, $3, $4, $5)}' neighdist.dat > WO_temp_list
sed -i '5,$d' WO_temp_list
cat WO_Position_all WO_temp_list > WO_Position_final
mv WO_Position_final WO_Position_all
done
awk '{printf("%4d %4d %15.8f %15.8f %15.8f %15.8f\n", $1, $2, $3, $4, $5, $6)}' WO_Position_all > WO_Position_final_temp
awk '{if(NR%4!=0)ORS=" ";else ORS="\n"}1' WO_Position_final_temp > WO_Position_final_temp_t
rm WO_Position_all
cat final_WO_position WO_Position_final_temp_t > final_WO_position_temp
mv final_WO_position_temp final_WO_position
rm WO_Position_final_temp_t CONTCAR
done

rm WO_temp_list WO_Position_final_temp neighdist.dat
