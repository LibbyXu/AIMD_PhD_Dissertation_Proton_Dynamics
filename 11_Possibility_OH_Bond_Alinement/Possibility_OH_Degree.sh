#Calculing the OH direction degree with respect to the -Z-dir.
#We need two files: POSCAR, XDATACAR from 2_Split_Manually_Data_Processing

#load the Python3 environment
module load python/3.6.0

#Definition of variables
##Number of the protons
total_proton_num=`echo 2` #You can modify 

##The O index from Water 
##If the indexes have an order
WO_St=`echo 65`  #you can modify
WO_En=`echo 76`  #you can modify
interger_WO=`echo 1`  #you can modify
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

##Initial index of Hydrogen (H)
First_H_index=`echo 125`  #You can modify
#The number of steps included in the current XDATCAR file
num_XDATCAR=`echo 500`  #You can modify

#Some other parameters needed to be set
num_water=`echo ${WaterO[0]} | awk -F "," '{print NF}'`
Final_H_index=`echo ${First_H_index}'+'2'*'${num_water}'+'${total_proton_num}'-'1 | bc`


touch final_WO_position
for ((s=1; s<=${num_XDATCAR}; s++))
do
  xdat2pos.pl 1 $s #Obtain the index for all atoms in water & Surface
  mv POSCAR$s.out CONTCAR

  touch WO_Position_all
  for ((a=${WO_St}; a<=${WO_En}; a++))
  do
    neighbors.pl CONTCAR $a #Get the neighdist.dat
    #index, atom_index, distance, position X, Y, Z
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

#The final output "final_WO_position"
#Index, atom_index, distance, position X, position Y, position Z (Every group contains 6 columns)
#The first 6 columns are for the Water-O, and then is the closest surrounding Hs.
