#Combined all files in order, and check.
ls -l  > num_XDATCAR
grep "File_XDATCAR_" num_XDATCAR > TEMP_XDATCAR
Num_Xfile=`wc -l TEMP_XDATCAR | cut -d' ' -f1`
rm num_XDATCAR TEMP_XDATCAR

#Make directories
mkdir Final_Combined_H_list
mkdir Final_Combined_reduced_H_list
mkdir First_python
mkdir Second_python
mkdir Third_python
mkdir Slurm_all

#Put the needed files into the "combined" folder
for ((a=1;a<=${Num_Xfile};a++))
do 
  cd File_XDATCAR_$a

  cp with_Proton_bonded_Oid_H_list with_Proton_bonded_Oid_H_list_$a
  cp Proton_bonded_O_H_list Proton_bonded_O_H_list_$a
  cp First_python.log First_python.log_$a   #Check
  cp Second_python.log Second_python.log_$a   #Check
  cp Third_python.log Third_python.log_$a   #Check
  cp *slurm* slurm_$a   #Check
  
  mv with_Proton_bonded_Oid_H_list_$a ../Final_Combined_H_list
  mv Proton_bonded_O_H_list_$a ../Final_Combined_reduced_H_list
  mv First_python.log_$a ../First_python
  mv Second_python.log_$a ../Second_python
  mv Third_python.log_$a ../Third_python
  mv slurm_$a ../Slurm_all
  
  cd ..
done

#Combined all files
cd Final_Combined_H_list
touch Combined_Final_H_list
for ((a=1;a<=${Num_Xfile};a++))
do
  cat Combined_Final_H_list with_Proton_bonded_Oid_H_list_$a > Combined_Final_H_list_temp
  mv Combined_Final_H_list_temp Combined_Final_H_list
done
rm *with_Proton_bonded_Oid_H_list_*

cd ../Final_Combined_reduced_H_list
touch Combined_Final_reduced_H_list
for ((a=1;a<=${Num_Xfile};a++))
do
  cat Combined_Final_reduced_H_list Proton_bonded_O_H_list_$a > Combined_Final_reduced_H_list_temp
  mv Combined_Final_reduced_H_list_temp Combined_Final_reduced_H_list
done
rm *Proton_bonded_O_H_list_*
cd ..
