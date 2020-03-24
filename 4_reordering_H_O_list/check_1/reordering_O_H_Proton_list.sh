#reordering the O_H list
#The only input we need is the Final_reduced_H_list

#load the pyrhon3 environment
module load python/3.6.0

#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`


########################################################################################################################
# Python dealing with reorder H O list
########################################################################################################################
cat << EOF > dealing_with_ordering_PbindO_fourth.py
# Dealing with the Proton-binded OXYGENS orders
import numpy as np
import math

data_H_list=np.genfromtxt('Final_reduced_H_list', delimiter='')
line_needed=data_H_list[:,0]
len_file=len(line_needed)

proton_Num=${total_proton_num}
ProtonH_index=np.zeros(shape=(len_file,proton_Num))
P_H=np.zeros(shape=(len_file,proton_Num*6))

for i in range(0,proton_Num):
    ProtonH_index[:,i]=data_H_list[:,7*i]
    P_H[:,(i*6):((i+1)*6)]=data_H_list[:,(7*i+1):(7*(i+1))]
    
data_HOrder_list=np.zeros(shape=(len_file,proton_Num))
PH_up=np.zeros(shape=(len_file,(6*proton_Num)))

PH_up[0,:]=P_H[0,:]
temp_num=ProtonH_index[0,:]
data_HOrder_list[0,:]=temp_num

for ii in range(1,len_file):
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
                print("Something wrong happened with the input list at step {}!".format(ii+1))
                
np.savetxt('O_uporder_list', data_HOrder_list, fmt="%s", delimiter='   ')
np.savetxt('O_nearest_three_H', PH_up, fmt="%s", delimiter='   ')
EOF
##################################################################################################################
#Fourth Python script end
##################################################################################################################
python3 dealing_with_ordering_PbindO_fourth.py >> Fourth_python.log

rm *.py*

touch Final_O_uporder_list
for ((gg=1; gg<=${total_proton_num}; gg++))
do
awk '{printf("%6d\n",$('$gg'))}' O_uporder_list > temp_O
paste Final_O_uporder_list temp_O > Final_O_uporder_list_temp
mv Final_O_uporder_list_temp Final_O_uporder_list
rm temp_O
done

cat -n Final_O_uporder_list > Final_O_uporder_list_Final
cat -n O_nearest_three_H > Final_O_nearest_three_H_Final

rm O_nearest_three_H Final_O_uporder_list O_uporder_list Final_reduced_H_list



