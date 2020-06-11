#Only works when you have more than 1 XDATCAR_# & vasp_# file
#Typing the following command to conduct the data processing:./Pre_Traj_check.sh > LOG or sbatch Submit.run 

#Connect & combine all "XDATCAR" files (in order)
ls -l  *XDATCAR* > num_XDATCAR
Num_X=`wc -l num_XDATCAR | cut -d' ' -f1`
cp XDATCAR_1 XDATCAR_temp

for ((i=2; i<=${Num_X}; i++))
do
sed -i '1,7d' XDATCAR_$i #without selective dynamics option
#sed -i '1,8d' XDATCAR_$i #with selective dynamics option
cat XDATCAR_temp XDATCAR_$i > XDATCAR
cp XDATCAR XDATCAR_temp 
done
rm XDATCAR_temp num_XDATCAR

grep 'Direct' XDATCAR > numlines
numline=`wc -l numlines | cut -d' ' -f1`
rm numlines
echo ${numline} #The number of steps included

#Check the total energy & temperature variations along AIMD trajectories to obtain the relative stabilized simulation period.
ls -l *vasp* > num_VASP
Num_v=`wc -l num_VASP | cut -d' ' -f1`
rm num_VASP
cp vasp_1.out vasp_temp.out

for ((i=2; i<=${Num_v}; i++))
do
cat vasp_temp.out vasp_$i.out > vasp.out
cp vasp.out vasp_temp.out
done
rm vasp_temp.out

grep "T= " vasp.out | awk '{print $3" "$5" "$7}' > T_E_temp.dat
cat -n T_E_temp.dat > T_E.dat
rm T_E_temp.dat
num_lines=`wc -l T_E.dat | cut -d' ' -f1`
echo ${num_lines}

# If ${numline} == ${num_lines}, your code is right. (check LOG file for the upper two rows)
rm *vasp_* *XDATCAR_*
