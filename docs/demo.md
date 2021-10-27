## Demo & installation verification

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

ROS_5271_20_01_03600_snippet_mono       85      41      27

------

If this is the case, your installation of ALICE works correctly!
