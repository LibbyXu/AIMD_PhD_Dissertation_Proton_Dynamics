# Home-made Computer Codes
Currently, I am still working on improving the **performance & efficiency** of this coding package. **_Your suggestion and advice are highly appreciated_**.

This coding package mainly focused the **Chapter 5** through my dissertation **`_"Probing Properties and Mechanisms of Protons in Materials and Interfaces for Energy Storage Systems Using First-Principles Methodology"_`**. Since several data are not released for publications, the dissertation will be avaliable online around **Jul. 2021** fortunately. 

## Goal for This Coding Package
The aim of this repository is providing general codes (Python/MATLAB/LINUX) for analyzing the proton (or ions) dynamic behavior, transport phenomenon, diffusion mechanisms, and other chemical/physical properties through the trajectory output files “XDATCAR” from the Vienna Ab initio Simulation Package (VASP) [1] 

## About Applicable Systems
We aim to explore the transport processes of the ionic liquid and organic electrolytes within the interfaces in energy storage materials. The commonly used electrode materials are transition metal oxides (TMO), MXenes, composite materials such as the MXene-TMO, graphene-MXene, graphene-TMO, etc. 

Here, we explore the proton dynamics (in my case, the surrounding environment is acidic, like H2SO4, which commonly used in aqueous-based electrochemical devices) within the water layer confined by electrode materials with the -O (or partially -O) terminations. Please refer to the details in my future publications or dissertations. 

## The Operation Environment & Needed Packages
**These codes can be applied to any cases that satisfy the following requirements:**
i)	VASP [1] outputs (POSCAR, XDATCAR, …). 
ii)	Water molecules will not dissociate along the whole trajectories.
iii)Protons and water molecules are the primary interface media.
iv)	The surfaces are mainly or partially covered by O terminations (the “partially” means that other terminated functional groups are inertia to the active media in iii).

**To use these codes, we need the following operating environment, and some (already) installed packages:**
i)	LINUX operating systems
ii)	Python 3 environment
iii)	VTSTSCRIPTS-933 [2-3] coding packages (We will call some functions from this package during our coding analysis. The path to the executables should be written into the environmental variables.) 

#### In each file, we will have a separate “Readme.md” document to explain the usage and function of the current scrips. And for each script, detailed illuminations on several necessary coding or command rows will be provided. Hopefully, it will be easy for you to understand. Please feel free to contact me if you have any questions. 

## References
[1] Kresse, G.; Furthmüller, J. Efficient Iterative Schemes for Ab Initio Total-Energy Calculations Using a Plane-Wave Basis Set. Physical Review B 1996, 54 (16), 11169. http://dx.doi.org/10.1103/PhysRevB.54.11169.
[2] Sheppard, D.; Terrell, R.; Henkelman, G. Optimization Methods for Finding Minimum Energy Paths. The Journal of chemical physics 2008, 128 (13), 134106. https://doi.org/10.1063/1.2841941. 
[3] Henkelman, G.; Uberuaga, B. P.; Jónsson, H. A Climbing Image Nudged Elastic Band Method for Finding Saddle Points and Minimum Energy Paths. The Journal of chemical physics 2000, 113 (22), 9901–9904. https://doi.org/10.1063/1.1329672.

***************************************************************************************


