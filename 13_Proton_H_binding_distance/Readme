This script is used to get the proton related H bonding distance:

###########################################################################
The files we need here is:
Final_hydronium_O_corr from 11 ratio_all_OH_from_water_second_in_H3O_MO_MO_no_hydro
XDATCAR POSCAR from 2

###########################################################################
The parameters we need to determine:
grab_proton_H_binding_distance_first.sh
#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`

#Define the index num for the O in water and Surface, if you
WO_St=`echo 65`
WO_En=`echo 76`
interger_WO=`echo 1`

grab_proton_H_binding_distance_second.sh
#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`
# Water O index
WO_St=`echo 65`
WO_En=`echo 76`
interger_WO=`echo 1`

grab_proton_H_binding_distance_third.sh
#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`

Submit_first.run
#The former steps we need to cut from our SDATCAR file
needed_step=`echo 15000`   #$1 means the one you need to inp

###########################################################################
The command that used:
sbatch Submit_first.run [After it finished]
sbatch Submit_second.run [After it finished]
sbatch Submit_third.run









