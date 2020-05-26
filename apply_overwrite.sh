#!/usr/bin/env bash
THISDIR="$( cd "$( dirname "$0" )" && pwd )"

declare -a classes=(KCHI CHI MAL FEM SPEECH)

declare -a folders=(
"KCHI:model/train/BBT_emp.SpeakerDiarization.All.train/validate_KCHI/BBT_emp.SpeakerDiarization.All.development/apply/0455"
"CHI:model/train/BBT_emp.SpeakerDiarization.All.train/validate_CHI/BBT_emp.SpeakerDiarization.All.development/apply/0265"
"MAL:model/train/BBT_emp.SpeakerDiarization.All.train/validate_MAL/BBT_emp.SpeakerDiarization.All.development/apply/0330"
"FEM:model/train/BBT_emp.SpeakerDiarization.All.train/validate_FEM/BBT_emp.SpeakerDiarization.All.development/apply/0495"
"SPEECH:model/train/BBT_emp.SpeakerDiarization.All.train/validate_SPEECH/BBT_emp.SpeakerDiarization.All.development/apply/0495")


if [ $# -ge 2 ]; then
    declare -a classes=() # empty array
    list=$@
    declare -a classes=($2) # get the classes provided by the user
fi;

if [ $# -ge 3 ]; then
    GPU=$3;
fi;

if [ "$(ls -A $1/*.wav)" ]; then
    echo "Found wav files."

    bn=$(basename $1)
    echo "Creating config for pyannote."
    # Create pyannote_tmp_config containing all the necessary files
    rm -rf $THISDIR/pyannote_tmp_config
    mkdir $THISDIR/pyannote_tmp_config

    # Create database.yml
    echo "Databases:
    $bn: $1/{uri}.wav

Protocols:
  $bn:
    SpeakerDiarization:
      All:
        test:
          annotated: $THISDIR/pyannote_tmp_config/$bn.uem" > $THISDIR/pyannote_tmp_config/database.yml

    # Create .uem file
    for audio in $1/*.wav; do
        duration=$(soxi -D $audio)
        echo "$(basename ${audio/.wav/}) 1 0.0 $duration"
    done > $THISDIR/pyannote_tmp_config/$bn.uem
    echo "Done creating config for pyannote."

    export PYANNOTE_DATABASE_CONFIG=$THISDIR/pyannote_tmp_config/database.yml

    OUTPUT=output_voice_type_classifier/$bn/
    mkdir -p output_voice_type_classifier/$bn/

    for couple in ${folders[*]}; do
        class="${couple%%:*}"
        class_model_path="${couple##*:}"
        echo "Extracting $class"
        pyannote-multilabel apply $GPU --subset=test $THISDIR/model/train/BBT_emp.SpeakerDiarization.All.train/validate_$class/BBT_emp.SpeakerDiarization.All.development $bn.SpeakerDiarization.All        
        awk -F' ' -v var="$class" 'BEGIN{OFS = "\t"}{print $1,$2,$3,$4,$5,$6,$7,var,$9,$10}' $THISDIR/${class_model_path}/$bn.SpeakerDiarization.All.test.rttm \
            > $OUTPUT/$class.rttm
    done;
    cat $OUTPUT/*.rttm > $OUTPUT/all.rttm

    # Super powerful sorting bash command :D !
    # Sort alphabetically to the second column, and numerically to the fourth one.
    sort -b -k2,2 -k4,4n $OUTPUT/all.rttm > $OUTPUT/all.tmp.rttm
    rm $OUTPUT/all.rttm
    mv $OUTPUT/all.tmp.rttm $OUTPUT/all.rttm
else
    echo "The folder you provided doesn't contain any wav files."
fi;
