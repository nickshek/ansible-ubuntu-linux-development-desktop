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

if [ -z "$CONDA_ENV" ]; then
  CONDA_ENV="/home/nickshek/miniconda2/bin/"
fi

export PATH="$CONDA_ENV:$PATH"

source activate kail-desktop
