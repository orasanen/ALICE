PATCH NOTES
-------------------

- August 30, 2023: Fixed a bug where timestamps in filenames in ALICE_output_utterances.txt resulted in a numerical overflow for long (> 2.8h) files. As a result, the utterance onset and offset format is now with 10 digits (seconds * 10000). 

- June 10, 2020: A major bugfix to count estimation. Fixed bugs in file loading and energy calculation in feature extraction pipeline. Count estimates for all files were slightly off due to energy scaling, and those not sampled at 16 khz (such as the demo file) were producing large estimation errors. This bug only affected the open source implementation here, but not the ALICE paper. Demo code reference counts also updated.
