#Here, we will separate the trajectory to each step

WO_St=`echo 65`
WO_En=`echo 76`
num_water=`echo ${WO_En}'-'${WO_St}'+'1 | bc`

Num_traj=`wc -l Final_total_traj | cut -d' ' -f1`
num_XDATCAR=`echo ${Num_traj}'/'${num_water} | bc`

awk '{printf("%4d %4d %15.8f %15.8f %15.8f %15.8f\n", $1,$2,$3,$4,$5,$6)}' Final_total_traj > WO_position
awk '{printf("%4d %4d %15.8f %15.8f %15.8f %15.8f %4d %4d %15.8f %15.8f %15.8f %15.8f %4d %4d %15.8f %15.8f %15.8f %15.8f\n",$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24)}' Final_total_traj > WOH_position

for ((aa=1; aa<=${num_XDATCAR}; aa++))
do
    echo "Direct configuration=  $aa" >> final_each_traj
    start_line=`echo '('$aa'-'1')*'${num_water}'+'1 | bc`
    end_line=`echo $aa'*'${num_water} | bc`
    sed -n ''${start_line}','${end_line}'p' Final_total_traj >> final_each_traj
done


