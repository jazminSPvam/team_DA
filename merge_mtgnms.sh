#!/bin/bash
# David Madrigal-Trejo
# May 2021

bold=$(tput bold)
normal=$(tput sgr0)
usage() { echo "
  ${bold}USAGE${normal}
      $0 [<string>]

  ${bold}DESCRIPTION${normal}
      This script merges the hit sequences from each metagenome into one file.
      Headers are substituted with an alphanumeric identifier. Metagenome number
      is also incorporated into the header. For usage, please provide the path
      to the directory containing the hit sequences files per metagenome.
  " 1>&2; exit 1; }

  if [ -z "$1" ]; then
      usage
  fi

  module load seqtk-1.3-gcc-9.3.0-tfvs63t

  ls $1 | egrep -o "PF[0-9]*" | sort | uniq > pfam_lst.txt
  mkdir Pfam_merged
  cat pfam_lst.txt | while read line
  do
    touch Pfam_merged/${line}.fasta
    for num in {1..7}
    do
      seqtk rename $1/${line}_MET_00${num}_hitseq.fasta SEQ |
      sed "s/>/>MET00${num}:/g" >> Pfam_merged/${line}.fasta
    done
  done
  rm pfam_lst.txt
