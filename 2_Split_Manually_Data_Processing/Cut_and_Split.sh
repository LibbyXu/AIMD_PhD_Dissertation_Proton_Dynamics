#We need the XDATCAR from 1 and the correspondind POSCAR
#How to use this script
#./cut_and_split.sh 15000

#We will only use the last n steps from the XDATCAR file
#without selective option
sed '8,$d' XDATCAR > head_XDAT
sed '1,7d' XDATCAR > split_XDAT
sed '1,6d' head_XDAT > NUMA
#with selective option
#sed '9,$d' XDATCAR > head_XDAT
#sed '1,8d' XDATCAR > split_XDAT
#sed '1,6d' head_XDAT > NUMA

#The former steps we need to cut from our SDATCAR file
needed_step=`echo $1`   #$1 means the one you need to input
echo ${needed_step}      
grep "Direct" XDATCAR > numlines
numlines=`wc -l numlines | cut -d' ' -f1`
rm numlines
rest_line=`echo ${numlines}'-'${needed_step} | bc`
echo ${rest_line}

#Split files
num_atoms=`awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}' NUMA`
file_line=`echo 500`
line_totals=`echo ${file_line}'*('${num_atoms}'+'1')' | bc`
delet_line=`echo '('${num_atoms}'+'1')*'${rest_line} | bc`
sed -i '1,'${delet_line}'d' split_XDAT
split -l ${line_totals} split_XDAT -d -a 2 Trajfile_

rm NUMA split_XDAT	

ls -l *Trajfile_* > trajnum
Num_traj=`wc -l trajnum | cut -d' ' -f1`

for ((i=1; i<=${Num_traj}; i++))
do
mkdir File_XDATCAR_$i
done

num_traj=`echo ${Num_traj}'-'1 | bc`
if [ ${num_traj} -le 9 ]
then
for ((a=0;a<=${num_traj};a++))
do
num_temp=`echo $a'+'1 | bc`
cat head_XDAT Trajfile_0$a > XDATCAR_${num_temp}
mv XDATCAR_${num_temp} File_XDATCAR_${num_temp}
rm Trajfile_0$a
cd File_XDATCAR_${num_temp}
mv XDATCAR_${num_temp} XDATCAR
cd ..
cp POSCAR File_XDATCAR_${num_temp}
done
else
for ((a=0;a<=9;a++))
do
num_temp=`echo $a'+'1 | bc`
cat head_XDAT Trajfile_0$a > XDATCAR_${num_temp}
mv XDATCAR_${num_temp} File_XDATCAR_${num_temp}
rm Trajfile_0$a
cd File_XDATCAR_${num_temp}
mv XDATCAR_${num_temp} XDATCAR
cd ..
cp POSCAR File_XDATCAR_${num_temp}
done
for ((b=10;b<=${num_traj};b++))
do
num_temp=`echo $b'+'1 | bc`
cat head_XDAT Trajfile_$b > XDATCAR_${num_temp}
mv XDATCAR_${num_temp} File_XDATCAR_${num_temp}
rm Trajfile_$b
cd File_XDATCAR_${num_temp}
mv XDATCAR_${num_temp} XDATCAR
cd ..
cp POSCAR File_XDATCAR_${num_temp}
done
fi
rm trajnum head_XDAT



