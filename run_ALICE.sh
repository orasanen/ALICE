#!/usr/bin/env bash
THISDIR="$( cd "$( dirname "$0" )" && pwd )"

# Run with extra argument "gpu" if CUDA GPU is available


if [ $# -eq 0 ]; then
    echo "Too few arguments. Usage:
    ./run_ALICE.sh <data_location>
    or
    ./run_ALICE.sh <data_location> gpu (for GPU-supported environments)

    Data location can be a folder with .wavs, an individual .wav file,
    or a .txt file with file paths to .wavs, one per row. "
    exit 2
fi

if [ $# -ge 3 ]; then
    echo "Too many arguments. Usage:
    ./run_ALICE.sh <data_location>
    or
    ./run_ALICE.sh <data_location> gpu (for GPU-supported environments)

    Data location can be a folder  with .wavs, an individual .wav file,
    or a .txt file with file paths to .wavs, one per row. "
    exit 2
fi

DATADIR=$1

if [ $# -ge 2 ]; then
    GPU=$(echo "$2" | tr '[:upper:]' '[:lower:]') # force lowercase
else
    GPU="cpu"
fi;

rm -rf $THISDIR/tmp_data/

mkdir -p $THISDIR/tmp_data/
mkdir -p $THISDIR/tmp_data/short/
mkdir -p $THISDIR/tmp_data/features/

# Copy wavs-to-be-processed to local folder
python3 prepare_data.py $THISDIR $DATADIR

# Call voice-type-classifier to do broad-class diarization

rm -rf $THISDIR/output_voice-type-classifier/
bash $THISDIR/voice-type-classifier/apply.sh $THISDIR/tmp_data/ "MAL FEM" --device=$GPU 2>&1 | sed '/^Took/d'
#bash $THISDIR/voice-type-classifier/apply.sh $THISDIR/tmp_data/ "MAL FEM" $GPU #|& sed '/^Took/d' # old pyannote syntax

# Read .rttm files and split into utterance-sized wavs
python3 split_to_utterances.py $THISDIR


# Extract SylNet syllable counts
if [ -z "$(ls -A $THISDIR/tmp_data/short/)" ]; then
  touch $THISDIR/tmp_data/features/ALUCs_out_individual.txt
  else

    if python3 $THISDIR/SylNet/run_SylNet.py $THISDIR/tmp_data/short/ $THISDIR/tmp_data/features/SylNet_out.txt $THISDIR/SylNet_model/model_1 &> $THISDIR/sylnet.log; then
        echo "SylNet completed"
    else
        echo "SylNet failed. See sylnet.log for more information"
        exit
    fi

# Extract signal level features
  python3 extract_basic_features.py $THISDIR

# Combine features
  paste -d'\t' $THISDIR/tmp_data/features/SylNet_out.txt $THISDIR/tmp_data/features/other_feats.txt > $THISDIR/tmp_data/features/final_feats.txt

# Linear regression from features to unit counts
  python3 regress_ALUCs.py $THISDIR

# Merge with filename information
  paste -d'\t' $THISDIR/tmp_data/features/SylNet_out_files.txt $THISDIR/tmp_data/features/ALUCs_out_individual_tmp.txt > $THISDIR/tmp_data/features/ALUCs_out_individual.txt
  rm $THISDIR/tmp_data/features/ALUCs_out_individual_tmp.txt
fi


python3 getFinalEstimates.py $THISDIR $THISDIR/tmp_data/

cp $THISDIR/tmp_data/features/ALUCs_out_individual.txt $THISDIR/ALICE_output_utterances.txt

# Cleanup
rm -rf $THISDIR/tmp_data/
cp $THISDIR/output_voice_type_classifier/tmp_data/all.rttm $THISDIR/diarization_output.rttm
rm -rf $THISDIR/output_voice_type_classifier/

echo "ALICE completed. Results written to $THISDIR/ALICE_output.txt and $THISDIR/diarization_output.rttm."
