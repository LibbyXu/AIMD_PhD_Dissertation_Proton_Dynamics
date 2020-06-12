#We need XDATCAR from "1_Combine_XDATCAR_Pre_Analysis" folder & POSCAR when you conduct AIMD simulation.
#Typing the following command to conduct the data processing:./cut_and_split.sh 15000 or sbatch Submit.run

#Some data preparations
##without Selective option when doing AIMD using VASP
sed '8,$d' XDATCAR > head_XDAT
sed '1,7d' XDATCAR > split_XDAT
sed '1,6d' head_XDAT > NUMA
##with Selective option when doing AIMD using VASP
#sed '9,$d' XDATCAR > head_XDAT
#sed '1,8d' XDATCAR > split_XDAT
#sed '1,6d' head_XDAT > NUMA

#Since we only need the last $1 steps for our following data analysis/processing. We need to get rid of the needless steps from our XDATCAR.
needed_step=`echo $1`   #$1 input step-number 
echo ${needed_step}      
grep "Direct" XDATCAR > numlines
numlines=`wc -l numlines | cut -d' ' -f1`
rm numlines
rest_line=`echo ${numlines}'-'${needed_step} | bc`
echo ${rest_line}

#Splitting XDATCAR file
num_atoms=`awk '{ for(i=1;i<=NF;i++) sum+=$i; print sum}' NUMA`
file_line=`echo 500` #500 step per file/folder
line_totals=`echo ${file_line}'*('${num_atoms}'+'1')' | bc`
delet_line=`echo '('${num_atoms}'+'1')*'${rest_line} | bc`
sed -i '1,'${delet_line}'d' split_XDAT
split -l ${line_totals} split_XDAT -d -a 2 Trajfile_
rm NUMA split_XDAT	
ls -l *Trajfile_* > trajnum
Num_traj=`wc -l trajnum | cut -d' ' -f1`

#Making folders
for ((i=1; i<=${Num_traj}; i++))
do
  mkdir File_XDATCAR_$i
done

#Putting needed files into each folder
num_traj=`echo ${Num_traj}'-'1 | bc`
#If total amount of folder <= 9, POSCAR to corresponding "File_XDATCAR_#" folder
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
#If total amount of folder > 9, POSCAR to corresponding "File_XDATCAR_#" folder
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



