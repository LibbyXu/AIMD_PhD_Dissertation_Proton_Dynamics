This is the scripts to calculate the remaining time of the proton when it is bonding with the same O from water or surface (MXene).

###################################################################
The files we needed here:
Final_O_uporder_list_Final from 4

###################################################################
Several parameters that we need to modify:
get_Segment_all_protons_first.sh
#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`
#Define the index num for the O at Surface, if your index has an order
SO_St=`echo 33`
SO_En=`echo 64`
interger_SO=`echo 1`
#if it does not have an order
#SurfaceO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)

#Define the index num for the O in water, if your index has an order
WO_St=`echo 65`
WO_En=`echo 76`
interger_WO=`echo 1`
#if the index does not have an order
#WaterO=(65,66,67,68,69...)


separated_to_each_proton_and_combine_second.sh
#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`
#Define the index num for the O at Surface, if your index has an order
SO_St=`echo 33`
SO_En=`echo 64`
interger_SO=`echo 1`
#if it does not have an order
#SurfaceO=(83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113)

#Define the index num for the O in water, if your index has an order
WO_St=`echo 65`
WO_En=`echo 76`
interger_WO=`echo 1`
#if the index does not have an order
#WaterO=(65,66,67,68,69...)


combine_all_proton_and_average.sh
#Definition of variables
#How many protons are studied in the system
total_proton_num=`echo 2`

##########################################################################
sbatch Submit_first.run [After it finished]
sbatch Submit_second.run [After it finished]
sbatch Submit_third.run






