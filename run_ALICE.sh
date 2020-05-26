#!/usr/bin/env bash
THISDIR="$( cd "$( dirname "$0" )" && pwd )"

# Run with --gpu if CUDA GPU is available


if [ $# -eq 0 ]; then
    echo "Too few arguments. Usage:
    sh run_ALICE.sh <data_location>
    or
    sh run_ALICE.sh <data_location> --gpu (for GPU-supported environments)

    Data location can be a folder with .wavs, an individual .wav file,
    or a .txt file with file paths to .wavs, one per row. "
    exit 2
fi

if [ $# -ge 3 ]; then
    echo "Too many arguments. Usage:
    sh run_ALICE.sh <data_locationr>
    or
    sh run_ALICE.sh <data_location> --gpu (for GPU-supported environments)

    Data location can be a folder  with .wavs, an individual .wav file,
    or a .txt file with file paths to .wavs, one per row. "
    exit 2
fi

cp $THISDIR/apply_overwrite.sh $THISDIR/voice-type-classifier/apply.sh

DATADIR=$1

if [ $# -ge 2 ]; then
    GPU=$2;
fi;

rm -rf $THISDIR/tmp_data/

mkdir -p $THISDIR/tmp_data/
mkdir -p $THISDIR/tmp_data/short/
mkdir -p $THISDIR/tmp_data/features/

# Run SAD on the files
python3 prepare_data.py $THISDIR $DATADIR/

# Call voice-type-classifier to do broad-class diarization

rm -rf $THISDIR/output_voice-type-classifier/
bash $THISDIR/voice-type-classifier/apply.sh $THISDIR/tmp_data/ "MAL FEM" $GPU

# Read .rttm files and split into utterance-sized wavs
python3 split_to_utterances.py $THISDIR
#rm $THISDIR/tmp_data/*.wav


# Extract SylNet syllable counts
if [ -z "$(ls -A $THISDIR/tmp_data/short/)" ]; then
#if [ ${#files[@]} -gt 0 ]; then
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



#fi

python3 getFinalEstimates.py $THISDIR $THISDIR/tmp_data/

# Cleanup
rm -rf $THISDIR/tmp_data/
cp $THISDIR/output_voice-type-classifier/tmp_data/all.rttm $THISDIR/diarization_output.rttm
rm -rf $THISDIR/output_voice-type-classifier/

echo "ALICE completed. Results written to $THISDIR/ALICE_output.txt and $THISDIR/diarization_output.rttm."
