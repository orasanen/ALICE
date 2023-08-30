# Loads diarization outputs (.rttms) and splits long audio files to utterance-sized
# wav-files based on the diarization results. Short files are temporarily stored
# to ALICE/tmo_data/short/

import csv,sys
from scipy.io import wavfile
import numpy as np
import librosa

curdir = sys.argv[1]

valid_speakers = ['FEM','MAL']

DATA = []
with open(curdir + '/output_voice_type_classifier/tmp_data/all.rttm') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        DATA.append(row)
        line_count += 1

curfile = []
for k in range(0,len(DATA)):
    s = DATA[k][0].split()
    filename = s[1]
    orig_filename = curdir + '/tmp_data/'+ s[1] +'.wav'
    speaker = s[7]
    isvalid = False
    for ref in valid_speakers:
        if(ref == speaker):
            isvalid = True
    if(curfile != orig_filename): # read .wav if not read already
        try:
            fs, data = wavfile.read(orig_filename)
        except ValueError: # Reading failed. Try with librosa.
            data, fs = librosa.load(orig_filename,16000)
        curfile = orig_filename
    onset = float(s[3])
    offset = onset+float(s[4])
    if isvalid:
        y = data[max(0,round(onset*fs)):min(len(data),round(offset*fs))]
        new_filename = curdir + '/tmp_data/short/'+ filename + ("_%010.0f" % (onset*10000)) + '_' + ("%010.0f" % (offset*10000)) +'.wav'
        wavfile.write(new_filename,fs,y)
