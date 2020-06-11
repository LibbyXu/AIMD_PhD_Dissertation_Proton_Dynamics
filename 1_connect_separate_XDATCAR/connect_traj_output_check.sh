#This files will only work when you have more than 1 XDATCAR file
#How to use this script
#./connect_traj_outp.sh > LOG

#Connect different XDATCAR files
ls -l  *XDATCAR* > num_XDATCAR
Num_X=`wc -l num_XDATCAR | cut -d' ' -f1`

cp XDATCAR_1 XDATCAR_temp
for ((i=2; i<=${Num_X}; i++))
do0
#without selective dynamics option
sed -i '1,7d' XDATCAR_$i
#with selective dynamics option
#sed -i '1,8d' XDATCAR_$i
cat XDATCAR_temp XDATCAR_$i > XDATCAR
cp XDATCAR XDATCAR_temp 
done

rm XDATCAR_temp num_XDATCAR

grep 'Direct' XDATCAR > numlines
numline=`wc -l numlines | cut -d' ' -f1`
rm numlines
#The number of steps included
echo ${numline}

#check the total energy as well as the temperature for the AIMD simulations
#same as the previous combining XDATCAR step, the script only apply to the vasp.out which have more than 2 files
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

# You need to make sure that the ${numline} == ${num_lines}. This means your code is right
rm *vasp_*
rm *XDATCAR_*



