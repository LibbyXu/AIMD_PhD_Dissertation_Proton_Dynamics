#connect all separate files into one and give them the line num as well as step num

ls -l  > num_XDATCAR
grep "File_XDATCAR_" num_XDATCAR > TEMP_XDATCAR
Num_Xfile=`wc -l TEMP_XDATCAR | cut -d' ' -f1`
rm num_XDATCAR TEMP_XDATCAR

mkdir Final_connected_Libby_H_list
mkdir Final_connected_reduced_H_list
mkdir First_python
mkdir Second_python
mkdir Third_python
mkdir Slurm_all

for ((a=1;a<=${Num_Xfile};a++))
do 
cd File_XDATCAR_$a
cp Libby_H_list Libby_H_list_$a
cp reduced_H_list reduced_H_list_$a
cp First_python.log First_python.log_$a
cp Second_python.log Second_python.log_$a
cp third_python.log third_python.log_$a
cp *slurm* slurm_$a
mv Libby_H_list_$a ../Final_connected_Libby_H_list
mv reduced_H_list_$a ../Final_connected_reduced_H_list
mv First_python.log_$a ../First_python
mv Second_python.log_$a ../Second_python
mv third_python.log_$a ../Third_python
mv slurm_$a ../Slurm_all
cd ..
done

cd Final_connected_Libby_H_list

touch Final_Libby_H_list
for ((a=1;a<=${Num_Xfile};a++))
do
cat Final_Libby_H_list Libby_H_list_$a > Final_Libby_H_list_temp
mv Final_Libby_H_list_temp Final_Libby_H_list
done
rm *Libby_H_list_*

cd ../Final_connected_reduced_H_list

touch Final_reduced_H_list
for ((a=1;a<=${Num_Xfile};a++))
do
cat Final_reduced_H_list reduced_H_list_$a > Final_reduced_H_list_temp
mv Final_reduced_H_list_temp Final_reduced_H_list
done
rm *reduced_H_list_*
cat -n Final_reduced_H_list > Final_reduced_H_list_Maria
cd ..


