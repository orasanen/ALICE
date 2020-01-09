# regress_ALUCS.py maps signal-level and SylNet features to phoneme, syllable,
# and word counts using a pre-trained set of linear model coefficients.

import sys
import numpy as np
from numpy import genfromtxt

curdir = sys.argv[1]

F = genfromtxt(curdir + "/tmp_data/features/final_feats.txt", delimiter='\t')

X_words = [0.1212, 2.6642, -0.0406, -0.0001, 5.9070]
X_syls = [0.2870, 4.0694, -0.0644, -0.0004, 9.3347]
X_phones = [0.4618, 10.9067, -0.2042, -0.0002, 31.5639]

F = np.column_stack((F,np.ones((F.shape[0],1))))

words_est = np.dot(F,X_words)
syls_est = np.dot(F,X_syls)
phones_est = np.dot(F,X_phones)

Y = np.column_stack((phones_est,syls_est))
Y = np.column_stack((Y,words_est))


np.savetxt(curdir + "/tmp_data/features/ALUCs_out_individual_tmp.txt", Y, delimiter="\t",fmt='%0.2f')
