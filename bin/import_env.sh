#!/usr/bin/env bash

realpath() {
  OURPWD=$PWD
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  cd "$OURPWD"
  echo "$REALPATH"
}

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

CONDA_DIR="/home/$USER/miniconda2/bin/"

if [ ! -d "$CONDA_DIR" ]; then
  echo "Conda is not installed! Please visit https://docs.conda.io/en/latest/miniconda.html to install miniconda2."
  exit 1;
fi

if [ -z "$CONDA_ENV" ]; then
  CONDA_ENV=$CONDA_DIR
fi

export PATH="$CONDA_ENV:$PATH"

source activate desktop

conda env create -f $SCRIPTPATH/environment.yml
