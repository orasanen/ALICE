## Usage

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

After the processing is complete, linguistic unit estimates for each input audio file will be written to `ALICE_output.txt` inside ALICE main directory. Diarization outputs will be written to `diarization_output.rttm` inside the same directory. 

In addition, utterance-level outputs for detected adult speech can be found from `ALICE_output_utterances.txt`, where each row corresponds to one utterance detected by the diarizer together with its estimated phoneme, syllable, and word counts. Timestamps appended to the filenames are of form <onset_time_in_ms x 10> _ <offset_time_in_ms x 10>, as measured from the beginning of each audio file. For instance, `<filename>_0000062740_0000096150.wav` stands for an utterance in `<filename.wav>` that started at 6.274 seconds and ended at 9.615 seconds. 

NOTE: utterance-level unit count estimates are not meant to be precise at short time-scales, but they can be used to create aggregate measures of unit counts for desired time windows shorter than the full (e.g., daylong) recordings. At 2 minutes of audio, correlation with "real" linguistic unit counts should be around r = 0.75-0.90 depending on the data and language (see the [ALICE paper](https://psyarxiv.com/p95dz) for evaluation). 

When done, deactivate the environment with
```
  $ conda deactivate
```


Notes:

- ALICE will require empty hard disk space equal to approx. the size of the .wavs
  to be processed.

