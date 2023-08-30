import csv,sys
from scipy.io import wavfile
import numpy as np
from numpy import genfromtxt
import os,glob

curdir = sys.argv[1]
datadir = sys.argv[2]

F = genfromtxt(curdir + "/tmp_data/features/ALUCs_out_individual.txt", delimiter='\t')

DATA = []
with open(curdir + "/tmp_data/features/ALUCs_out_individual.txt") as csv_file:
    csv_reader = csv.reader(csv_file, delimiter='\t')
    line_count = 0
    for row in csv_reader:
        DATA.append(row)
        line_count += 1

fileid = []

for line in DATA:
    s = line[0]
    path, filename = os.path.split(s)
    fileid.append(filename[0:-26])

uq_files = list(set(fileid))

text_file = open(curdir + "/ALICE_output.txt", "w")

text_file.write("FileID \t phonemes \t syllables \t words\n")

for file in uq_files:
    count_phones = 0
    count_syls = 0
    count_words = 0
    for i in range(0,len(fileid)):
        if(file == fileid[i]):
            count_phones = count_phones+float(DATA[i][1])
            count_syls = count_syls+ float(DATA[i][2])
            count_words = count_words+float(DATA[i][3])
    text_file.write(str(file + "\t" + str(int(round(count_phones))) + "\t" + str(int(round(count_syls))) + "\t" + str(int(round(count_words))) + "\n"))

# Compare original files and output files to see if some are missing (no diarization output, i.e., no speech)

fileList_orig = sorted(glob.glob(datadir + '/*.wav'))
for file in fileList_orig:
    path, filename = os.path.split(file)
    exists = False
    for file2 in uq_files:
        if filename[0:-4] == file2:
            exists = True
    if not exists:
        text_file.write(str(filename[0:-4] + "\t" + "0" + "\t" + "0" + "\t" + "0" + "\n"))

text_file.close()
