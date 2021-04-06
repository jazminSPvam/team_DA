'''NAME
       retrieve_seq_uniprot

VERSION
        1.0

AUTHOR
        Elizabeth Márquez Gómez <elimqzg@lcg.unam.mx>

DESCRIPTION
        Search for a given query on UniProt server

CATEGORY
        Automated search

USAGE
        retrieve_seq_uniprot.py --q 'goa:("response to salt stress [9651]") OR goa:("cellular response to salt stress [71472]") OR goa:("regulation of response to salt stress [1901000]") OR goa:("positive regulation of response to salt stress [1901002]") NOT taxonomy:"Metazoa [33208]" NOT taxonomy:"Viridiplantae [33090]"' --ext SALT --o salt_sequences.fasta

ARGUMENTS
        [--q, --query]  -->  In command line you have to introduce the input query to look for.
        
        [--ext, --extension]  -->  In command line you have to introduce the extension to add at the end of each match gene.
        
        [--o, --output] -->  In command line you have to introduce the output file to save the search.
        
'''
## IMPORT LIBRARIES
from bioservices import UniProt
from bioservices.apps.fasta import FASTA
import argparse

## 0. DEFINE ARGUMENTS AND ASIGNE TO MANAGE THEM AFTER
# 0.1 Arguments description
parser = argparse.ArgumentParser(description="")

parser.add_argument(
  "-q", "--query",
  metavar = "string",
  help = "Input query to look for",
  required = True)

parser.add_argument(
  "-ext", "--extension",
  metavar = "string",
  help = "Extension to add at the end of each match gene",
  required = True)

parser.add_argument(
    "-o", "--output",
    metavar = "path/to/file",
    help = "Output file to save the search",
    required = True)


# 0.2 Assign variables to input/output files, round value and aminoAcids
args = parser.parse_args()
query = args.query
extension = args.extension
outFilePath = args.output


## 1. CONNECTION WITH UNIPROT AND QUERY DEFINITION
u = UniProt(verbose=False)
search = u.search( query, frmt='tab', columns = 'id')
#print(f'UniProt search: {search}')

genesList = search.split()[1:]

print(f'Number of genes: {len(genesList)}')

## 2. SAVING THE FASTA SEQUENCES IN THE OUTPUT FILE
f = FASTA()

with open(outFilePath, 'w') as fastaFile:
    
    for gene in genesList:
        f.load(gene)
        identifier = f.identifier + '_' + extension
        sequence = f.sequence
        fastaFile.write(f'{identifier}\n{sequence}\n')

print(f'The results have been written in: {outFilePath}')
        