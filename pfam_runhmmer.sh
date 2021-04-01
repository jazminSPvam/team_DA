#!/bin/bash
# David Madrigal-Trejo
# March 2021

bold=$(tput bold)
normal=$(tput sgr0)
usage() { echo "
  ${bold}USAGE${normal}
      $0 [-i <string>] [-d <string>] [-c <string>] [-p <string>]

  ${bold}DESCRIPTION${normal}
      Script that performs the following:
      1) Download pfam seed in stockholm format for each pfam accession
      number within a list;
      2) Build a HMMER profile for the pfam seed downloaded;
      3) And run a HMMER search in a predicted-protein metagenome
      databases (Domos del Arqueano).

  ${bold}OPTIONS${normal}
      ${bold}-i${normal}             Input textfile with one pfam accession number per line.

      ${bold}-d${normal}             Output directory prefix. Default 'PfamID'.

      ${bold}-c${normal}             Number of cpu's to be used in hmmbuild and hmmsearch.
                     Default '2'

      ${bold}-p${normal}             Path to the directory containing the metagenome databases.
                     By default, it is assumed that prodigal files are in the
                     current directory. Metagenome databases are expected to be
                     in fasta format, whitespaces should be removed from ID
                     headers.
  " 1>&2; exit 1; }

PREFIX="PfamID"
CPU="2"
METPATH="."
while getopts ':i:d:c:p:' flag; do
        case "${flag}" in
                i) FILE=${OPTARG} ;;
                d) PREFIX=${OPTARG} ;;
                c) CPU=${OPTARG} ;;
                p) METPATH=${OPTARG} ;;
                *) usage ;;
        esac
done
shift $((OPTIND-1))
if [ -z "${FILE}" ]; then
    usage
fi

module load hmmer-3.3-gcc-9.3.0-oyxlgla
module load seqtk-1.3-gcc-9.3.0-tfvs63t

cat $FILE | while read line
  do
   mkdir ${PREFIX}_alignments
   printf "Downloading ${line}_seed... \n"
   wget -O ${PREFIX}_alignments/${line}_seed.txt \
    "http://pfam.xfam.org/family/${line}/alignment/seed/format?format=stockholm"

   mkdir ${PREFIX}_hmmer_out
   mkdir ${PREFIX}_profiles
   mkdir ${PREFIX}_lsts
   mkdir ${PREFIX}_hmmer_hitseq
   printf "Building ${line}.hmm profile... \n"
   hmmbuild --cpu ${CPU} ${PREFIX}_profiles/${line}.hmm \
    ${PREFIX}_alignments/${line}_seed.txt
   for num in {1..7}
   do
     printf "HMMER search: ${line},MET00${num}... \n"
     hmmsearch --cpu ${CPU} ${PREFIX}_profiles/${line}.hmm \
      ${METPATH}/prodigal_MET_00${num}_SE.faa > ${PREFIX}_hmmer_out/${line}_MET_00${num}.tab

     cat ${PREFIX}_hmmer_out/${line}_MET_00${num}.tab | awk '{print $9}' | tail -n +16 \
      > ${PREFIX}_lsts/${line}_MET_00${num}_lst.txt
     seqtk subseq ${METPATH}/prodigal_MET_00${num}_SE.faa \
      ${PREFIX}_lsts/${line}_MET_00${num}_lst.txt \
        > ${PREFIX}_hmmer_hitseq/${line}_MET_00${num}_hitseq.fasta
    done
  done
