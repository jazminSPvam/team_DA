#!/bin/bash
# retrieve sequences for all
# Elizabeth Marquez Gomez

#Start
printf $( date '+%F_%H:%M:%S' )

for condition in acidic alkaline dormancy endosporulation ph salt
do
  printf "Starting %s \n" "$condition"
  for numero in 1 2 3 4 5 6 7
  do
    printf "Starting MET00%s \n" "$numero"
    seqtk subseq ProdigalSE/prodigal_MET_00${numero}_SE.faa IDs_blastp_${condition}_MET00${numero}.txt > SeqMeta_blastp_${condition}_MET00${numero}.txt
  done
done

printf "<<<<<< End >>>>>> \n"

#End
printf $( date '+%F_%H:%M:%S' )