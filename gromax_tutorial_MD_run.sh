#!/usr/bin/bash
###GROMAX TUTORAIL#####
#REMOVE ALL THE WATER CRYSTAL 
grep -v HOH $1 > $1\_clean.pdb
############TOPOLOGY##########################
##1##pdb2gmx to generate topolgy, restrain and processed pdb file used to generate forcefield:

gmx pdb2gmx -f $1\_clean.pdb -o $1\_processed.gro -water spce

##2##choose force field for your pdb:


echo "#################################topolgy file generated#####################################"
############SOLVATION#######################

##3##define the box using editconf:

gmx editconf -f $1\_processed.gro -o $1\_newbox.gro -c -d 1.0 -bt cubic

##3##solavte the protein box:
gmx solvate -cp $1\_newbox.gro -cs spc216.gro -o $1\_solv.gro -p topol.top

#############Adding Ions#######################


##4##Generate .tpr file

gmx grompp -f ions.mdp -c $1\_solv.gro -p topol.top -o ions.tpr

gmx genion -s ions.tpr -o $1\_solv_ions.gro -p topol.top -pname NA -nname CL -neutral



#############Energy Minimization###############
##5##em.tpr production
gmx grompp -f minim.mdp -c $1\_solv_ions.gro -p topol.top -o em.tpr

gmx mdrun -v -deffnm em


##############Equilibration####################
##6##NVT equilibration
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr


gmx mdrun -deffnm nvt

##7##NPT equilibration
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr

gmx mdrun -deffnm npt

##############run production MD##############

gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr

##8## GROMACS on GPU

gmx mdrun -deffnm md_0_1 -nb gpu
