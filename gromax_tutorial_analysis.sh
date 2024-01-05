#!/usr/bin/bash
###GROMAX TUTORAIL#####
##################Analysis###################

gmx trjconv -s md_0_1.tpr -f md_0_1.xtc -o md_0_1_noPBC.xtc -pbc mol -center

gmx rms -s md_0_1.tpr -f md_0_1_noPBC.xtc -o rmsd.xvg -tu ns


###calculate RMSD relative to the crystal structure, we could issue the following:

gmx rms -s em.tpr -f md_0_1_noPBC.xtc -o rmsd_xtal.xvg -tu ns
