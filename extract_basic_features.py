import csv,sys
from scipy.io import wavfile
import numpy as np
import librosa
curdir = sys.argv[1]


# Read the same files as processed by SylNet
fileList = []
with open(curdir + '/tmp_data/features/SylNet_out_files.txt') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        fileList.append(row)
        line_count += 1

zcr = []
dur = []
E = []

for fileName in fileList:    
    data, _ = librosa.core.load(fileName[0], sr = 16000, mono = True)    
    zcr.append(sum((np.diff(np.sign(data)))!= 0)) # zero crossing rate
    dur.append(len(data)/16000)    # duration
    E.append(20*np.log10(2**16)+20*np.log10(np.sum(np.abs(data)))) # total energy    

F = np.column_stack((dur,E))
F = np.column_stack((F,zcr))

np.savetxt(curdir + "/tmp_data/features/other_feats.txt", F, delimiter="\t")
