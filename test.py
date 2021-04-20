from Bio import SeqIO

blastFile = f'blastp_acidic_ResGen_MET001.txt'
metaFile = SeqIO.parse(f'ProdigalSE/prodigal_MET_001_SE.faa','fasta')
counter = 0
founded = False
with open(blastFile, 'r') as getFile:
    
    for line in getFile:
        if counter > 50:
            break
        counter += 1
        line = line.strip()
                
        if not line.startswith('#'):
            line = line.split('\t')
            track = line[1]
            print(track)

            for record in metaFile:
                if (record.id).rstrip('\t') == track:
                    founded = True
                    sequence = record.seq
                    print(sequence)
                    break
            
            if founded == False:
                print('not founded')
            else:
                founded = False
print('ended process')