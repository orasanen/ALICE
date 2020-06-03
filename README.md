# Automatic LInguistic Unit Count Estimator (ALICE)

INTRODUCTION
-------------------

ALICE is a tool for estimating the number of adult-spoken linguistic units from child-centered audio
recordings, as captured by microphones worn by children. It is meant as an open-source alternative
for LENA <tm> adult word count (AWC) estimator [1].

ALICE uses SylNet [[2]](https://github.com/shreyas253/SylNet) for feature extraction and voice type classifier [[3]](https://github.com/MarvinLvn/voice-type-classifier) for broad-class speaker
diarization. The used model for linguistic unit counts has been optimized across four languages:
Argentinian Spanish, Tseltal, Yélî Dnye, and American and UK variants of English. SylNet uses a model that
has been adapted for daylong child-centered audio, starting from the baseline model available
in standard SylNet.

ALICE outputs an estimate for the number of phonemes, syllables, and words in the input. Only
speech detected as spoken by adult male or female talkers is considered towards the counts.

Unit counts from ALICE are not (and are not meant to be) accurate at short time-scales,
but optimized for counting across several minutes of audio. Also note that ALICE is NOT
designed for "typical" high-quality audio recordings, and may
not operate on such data properly.

![alt text](http://www.cs.tut.fi/sgn/specog/ALICE_schematic2.png)



CITING
-------------------

If you use ALICE or it's derivatives, please cite the following paper:

Räsänen, O., Seshadri, S. & Casillas, M. (in preparation): *ALICE: An open-source tool
for automatic linguistic unit count estimation from child-centered daylong recordings*.


REQUIREMENTS
-------------------

ALICE has been developed and so-far tested for a range of Linux and macOS environments. Windows users may encounter problems with some package versions, and we are currently looking into this.

Packages:

- Conda (https://docs.conda.io/en/latest/)
- CMake (```pip install cmake``` or ```conda install cmake```)

(other packages automatically installed by conda environment)


LICENSE
-------------------
Copyright (C) 2020 Okko Räsänen, Tampere University

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


INSTALLATION
-------------------
- Clone the repository with submodules :

```bash
git clone --recurse-submodules https://github.com/orasanen/ALICE/
```

- Make sure you have Conda and Cmake installed.

- Create the conda environment installing all the dependencies :

```bash
cd ALICE
conda env create -f ALICE.yml
```



USAGE
-------------------
Always activate the ALICE conda environment before usage. To do this, run:
```
  $ conda activate ALICE
```


To process your .wav files containing the audio of interest, run:
```
  $ ./run_ALICE.sh <data_location>
```
  where <data_location> = folder of .wavs, path to a .wav, or path to a .txt file
  with a list of .wav paths, one per row.

  For GPU use during diarization , use
```
  $ ./run_ALICE.sh <data_location> gpu
```
Note that the use of GPU will speed up diarization substantially, but this will require CUDA toolkit
and a compatible GPU.

After the processing is complete, results will be written to `ALICE_output.txt` inside ALICE main
directory. Diarization outputs will be written to `diarization_output.rttm` inside the same directory.

When done, deactivate the environment with
```
  $ conda deactivate
```


Notes:

- So far, the system has been tested for audio files up to 5 minutes of duration.
  For substantially longer files, cutting them into shorter pieces before
  processing is highly recommended.
- ALICE will require empty hard disk space equal to approx. the size of the .wavs
  to be processed.


DEMO & INSTALLATION VERIFICATION
-------------------

Navigate to ALICE folder, and run
```
  $ conda activate ALICE
  $ ./run_ALICE.sh demo/ROS_5271_20_01_03600_snippet_mono.wav
```

After a while, ALICE should complete without errors and print
``
SylNet completed
ALICE completed. Results written to <yourpath>/ALICE/ALICE_output.txt and <yourpath>/ALICE/diarization_output.rttm.
``

Now, contents of the ``<yourpath>/ALICE/ALICE_output.txt`` should look like this:

------

FileID   phonemes        syllables       words

ROS_5271_20_01_03600_snippet_mono       40      15      12

------

If this is the case, your installation of ALICE works correctly!

DEBUGGING
-------------------

If you are encountering problems with SylNet, please refer to sylnet.log that is automatically
generated to ALICE main folder upon ALICE execution. SylNet error printing to command line is disabled
due to a large number of warnings due to the use of Tensorflow 1.

## Some common problems:

#### Error #1: "CondaValueError: prefix already exists: /<your_condadir>/envs/ALICE" when creating the Conda environment

If you have installed an earlier version of ALICE before, please remove the old environment with 

```
  $ rm -rf /<your_condadir>/envs/ALICE/
```

and then install ALICE from scratch.



REFERENCES
-------------------

[1] Xu, D., Yapanel, U. Gray, S., Gilkerson, J., Richards, J. Hansen, J. (2008).
    Signal processing for young child speech language development
    Proceedings of the 1st Workshop on Child Computer and Interaction (WOCCI-2008), Chania, Crete, Greece.
    (https://www.lena.org/)

[2] Seshadri S. & Räsänen O. (2019). SylNet: An Adaptable End-to-End Syllable Count Estimator for Speech.
    IEEE Signal Processing Letters, vol 26, pp. 1359--1363  (https://github.com/shreyas253/SylNet)

[3] Lavechin, M.: Voice-type-classifier (https://github.com/MarvinLvn/voice-type-classifier)
