#reordering the O_H list
#We need file: Final_Combined_reduced_H_list

#load the Python3 environment
module load python/3.6.0

#######################################  
##########Setting parameters###########  
#######################################  
#####Number of the protons#####  
total_proton_num=`echo 2` #You can modify 

#####################################  
##########Python codes lists##########  
#####################################  
  
###########################  
###Python_fourth.py code###  
###########################  
########################################################  
###Reorder proton-bonded O list, making it continuous###  
########################################################  
cat << EOF > Python_fourth.py  
  
import numpy as np  
import math  
  
#Define parameters  
proton_Num=${total_proton_num}  
#Load data  
data_H_list=np.genfromtxt('Final_Combined_reduced_H_list', delimiter='')  
len_file=len(data_H_list[:,0])  
  
#Original proton-bonded O list  
ProtonH_index=np.zeros(shape=(len_file,proton_Num))  
P_H=np.zeros(shape=(len_file,proton_Num*6))  
  
for i in range(0,proton_Num):  
    ProtonH_index[:,i]=data_H_list[:,7*i]  #All proton-bonded O indexes  
    P_H[:,(i*6):((i+1)*6)]=data_H_list[:,(7*i+1):(7*(i+1))]  #The surrounding H info (inclduing proton)  
  
#Reordering the proton-bonded O list      
data_HOrder_list=np.zeros(shape=(len_file,proton_Num))  
PH_up=np.zeros(shape=(len_file,(6*proton_Num)))  
  
PH_up[0,:]=P_H[0,:]  
temp_num=ProtonH_index[0,:]  
data_HOrder_list[0,:]=temp_num  
  
for ii in range(1,len_file):  
    count_times=0  
    for aa in range(0,proton_Num):  
        temp_H=ProtonH_index[ii,aa]  
        tem_sum=0  
        for bb in range(0,proton_Num):  
            if temp_H==temp_num[bb]:  
               data_HOrder_list[ii,bb]=temp_H  
               PH_up[ii,(bb*6):((bb+1)*6)]=P_H[ii,(aa*6):((aa+1)*6)]  
               tem_sum=tem_sum+1  
        if tem_sum==0:  
            temp_PH=P_H[ii,(aa*6):((aa+1)*6)]  
            temp_sumup=0  
            for cc in range(0, 3):  
                for ee in range(0, proton_Num):                      
                    for dd in range(0,3):  
                        if (temp_PH[2*cc]==PH_up[(ii-1),(6*ee+2*dd)]) and (temp_PH[2*cc] != 0):  
                            temp_sumup=temp_sumup+1  
                            PH_up[ii,(ee*6):((ee+1)*6)]=temp_PH  
                            data_HOrder_list[ii,ee]=temp_H  
                            temp_num[ee]=temp_H  
            if temp_sumup != 1:  
                count_times=count_times+1  
                remaining_PH=temp_PH  
                remaining_O=temp_H  
                step_problem=ii+1  
               #print("Something wrong happened with the input list at step {}!".format(ii+1))  
    if count_times==1:  
        for nn in range(0,proton_Num):  
            if data_HOrder_list[ii,nn]==0:  
                data_HOrder_list[ii,nn]=remaining_O  
                temp_num[nn]=remaining_O  
                PH_up[ii,(nn*6):((nn+1)*6)]=remaining_PH  
                break  
    elif count_times>=1:  
        print("Please check the trajectory at step {}, at leat two protons jump far away!".format(step_problem))  
          
#Format for data_HOrder_list:  
#proton-bonded O indexes (continues)  
  
#Format for PH_up:  
#3H bonded to proton-bonded O (H/proton index, H-O distance)  
#After the first column, each 6-column corresponds to one proton-bonded O in data_HOrder_list  
  
#Save datafiles                  
np.savetxt('proton_bonded_O_reorder_list',data_HOrder_list,fmt="%s",delimiter='   ')  
np.savetxt('proton_bonded_O_nearest_three_H_list',PH_up,fmt="%s",delimiter='   ')  

EOF
#############################  
###End of Python_fourth.py###  
############################# 

#########################################################################  
##########Linux commands used to connect different Python codes##########  
#########################################################################   
#####################################################  
#####Final continuous proton-bonded O index list#####  
#####################################################  
python Python_fourth.py > Fourth_python.log  
  
#Format for data_HOrder_list:  
#Step index, proton-bonded O indexes (continues)  
touch Final_proton_bonded_O_reorder_list  
for ((gg=1; gg<=${total_proton_num}; gg++))  
do  
  awk '{printf("%6d\n",$('$gg'))}' proton_bonded_O_reorder_list > temp_O  
  paste Final_proton_bonded_O_reorder_list temp_O > Final_proton_bonded_O_reorder_list_temp  
  mv Final_proton_bonded_O_reorder_list_temp Final_proton_bonded_O_reorder_list  
  rm temp_O  
done  
cat -n Final_proton_bonded_O_reorder_list > Final_proton_bonded_O_reorder_list_Final  
  
#Format for PH_up:  
#Step index, 3H bonded to proton-bonded O (H/proton index, H-O distance)  
#After the first column, each 6-column corresponds to one proton-bonded O in data_HOrder_list  
touch Final_proton_bonded_O_nearest_three_H_list  
for ((pp=1; pp<=${total_proton_num}; pp++))  
do  
  awk '{printf("%6d %14.10f %6d %14.10f %6d %14.10f\n",$(('$pp'-1)*6+1),$(('$pp'-1)*6+2),$(('$pp'-1)*6+3),$(('$pp'-1)*6+4),$(('$pp'-1)*6+5),$('$pp'*6))}' proton_bonded_O_nearest_three_H_list > temp_H  
  paste Final_proton_bonded_O_nearest_three_H_list temp_H > Final_proton_bonded_O_nearest_three_H_list_temp  
  mv Final_proton_bonded_O_nearest_three_H_list_temp Final_proton_bonded_O_nearest_three_H_list  
  rm temp_H  
done  
cat -n Final_proton_bonded_O_nearest_three_H_list > Final_proton_bonded_O_nearest_three_H_list_Final  
  
rm proton_bonded_O_nearest_three_H_list Final_proton_bonded_O_nearest_three_H_list Final_proton_bonded_O_reorder_list proton_bonded_O_reorder_list Final_reduced_H_list *.py*
