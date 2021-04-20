termsList = ['acidic', 'alkaline', 'dormancy', 'endosporulation', 'ph', 'salt']

for term in termsList:
    
    for i in range(1,8):
        blastFile = f'blastp_{term}_ResGen_MET00{i}.txt'
        idFile = open(f'IDs_blastp_MET00{i}.txt', 'a')
    
        with open(blastFile, 'r') as getFile:
            for line in getFile:
            
                if not line.startswith('#'):
                    line = line.split('\t')
                    track = (line[1]).strip()
                    idFile.write(track)
                    
        print(f'ended process IDs_blastp_MET00{i}.txt')            
        idFile.close()