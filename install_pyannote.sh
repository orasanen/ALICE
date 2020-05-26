#!/usr/bin/env bash

cd voice-type-classifier
git clone https://github.com/MarvinLvn/pyannote-audio.git
cd pyannote-audio
git checkout voice_type_classifier
pip install .
