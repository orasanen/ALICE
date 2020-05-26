# regress_ALUCS.py maps signal-level and SylNet features to phoneme, syllable,
# and word counts using a pre-trained set of linear model coefficients.

import sys
import numpy as np
from numpy import genfromtxt

curdir = sys.argv[1]

F = genfromtxt(curdir + "/tmp_data/features/final_feats.txt", delimiter='\t')


# Old diarizer (Dec 2019)
#X_phones = [1.1092, 16.1548, -0.317, -0.0014, 48.7033]
#X_syls = [0.6267, 8.8197, -0.1579, -0.0010, 23.0796]
#X_words = [0.3029, 5.9524, -0.0977, -0.0004, 14.2853]

# New diarizer (March 2020)
X_phones = [0.6675, 10.0683, -0.2763, -0.0009, 42.7907]
X_syls = [0.3094, 5.5473, -0.1538, -0.0006, 23.2143]
X_words = [0.1697, 3.5229, -0.0920, -0.0003, 13.9089]

F = np.column_stack((F,np.ones((F.shape[0],1))))

words_est = np.dot(F,X_words)
words_est = words_est.clip(min = 0)
syls_est = np.dot(F,X_syls)
syls_est = syls_est.clip(min = 0)
phones_est = np.dot(F,X_phones)
phones_est = phones_est.clip(min = 0)

Y = np.column_stack((phones_est,syls_est))
Y = np.column_stack((Y,words_est))


np.savetxt(curdir + "/tmp_data/features/ALUCs_out_individual_tmp.txt", Y, delimiter="\t",fmt='%0.2f')
