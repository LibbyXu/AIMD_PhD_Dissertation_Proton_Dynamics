#We need to produce several important files necessary for the post-treatment of data for OH and Dipole orientation of the water molecules. 
#We need the file: Final_Total_OH_Degree_Results from the previous Final_Conbined_OH_Degree_Results folder in 11_Possibility_OH_Bond_Alinement

#Definitions of the variables
##O indexes in water
##If indexes have order  
WO_St=`echo 65` #The start of the Water-O index, you can modify
WO_En=`echo 76` #The end of the Water-O index, you can modify
num_water=`echo ${WO_En}'-'${WO_St}'+'1 | bc` #Total number of the water molecules

Num_traj=`wc -l Final_Total_OH_Degree_Results | cut -d' ' -f1`
num_XDATCAR=`echo ${Num_traj}'/'${num_water} | bc`

awk '{printf("%4d %4d %15.8f %15.8f %15.8f %15.8f\n", $1,$2,$3,$4,$5,$6)}' Final_Total_OH_Degree_Results > WO_position
awk '{printf("%4d %4d %15.8f %15.8f %15.8f %15.8f %4d %4d %15.8f %15.8f %15.8f %15.8f %4d %4d %15.8f %15.8f %15.8f %15.8f\n",$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24)}' Final_Total_OH_Degree_Results > WOH_position

for ((aa=1; aa<=${num_XDATCAR}; aa++))
do
  echo "Direct configuration=  $aa" >> Final_Each_Step_in_Traj
  start_line=`echo '('$aa'-'1')*'${num_water}'+'1 | bc`
  end_line=`echo $aa'*'${num_water} | bc`
  sed -n ''${start_line}','${end_line}'p' Final_Total_OH_Degree_Results >> Final_Each_Step_in_Traj
done
