#!/bin/bash
########################################################
# Useful function to Get the current shell script path #
########################################################
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


#############################################
# Useful section to print the color in bash #
#############################################

# Colors
end="\033[0m"
black="\033[0;30m"
blackb="\033[1;30m"
white="\033[0;37m"
whiteb="\033[1;37m"
red="\033[0;31m"
redb="\033[1;31m"
green="\033[0;32m"
greenb="\033[1;32m"
yellow="\033[0;33m"
yellowb="\033[1;33m"
blue="\033[0;34m"
blueb="\033[1;34m"
purple="\033[0;35m"
purpleb="\033[1;35m"
lightblue="\033[0;36m"
lightblueb="\033[1;36m"

function black {
  echo -e "${black}${1}${end}"
}

function blackb {
  echo -e "${blackb}${1}${end}"
}

function white {
  echo -e "${white}${1}${end}"
}

function whiteb {
  echo -e "${whiteb}${1}${end}"
}

function red {
  echo -e "${red}${1}${end}"
}

function redb {
  echo -e "${redb}${1}${end}"
}

function green {
  echo -e "${green}${1}${end}"
}

function greenb {
  echo -e "${greenb}${1}${end}"
}

function yellow {
  echo -e "${yellow}${1}${end}"
}

function yellowb {
  echo -e "${yellowb}${1}${end}"
}

function blue {
  echo -e "${blue}${1}${end}"
}

function blueb {
  echo -e "${blueb}${1}${end}"
}

function purple {
  echo -e "${purple}${1}${end}"
}

function purpleb {
  echo -e "${purpleb}${1}${end}"
}

function lightblue {
  echo -e "${lightblue}${1}${end}"
}

function lightblueb {
  echo -e "${lightblueb}${1}${end}"
}

function colors {
  black "black"
  blackb "blackb"
  white "white"
  whiteb "whiteb"
  red "red"
  redb "redb"
  green "green"
  greenb "greenb"
  yellow "yellow"
  yellowb "yellowb"
  blue "blue"
  blueb "blueb"
  purple "purple"
  purpleb "purpleb"
  lightblue "lightblue"
  lightblueb "lightblueb"
}

function colortest {
  if [[ -n "$1" ]]; then
    T="$1"
  fi
  T='gYw'   # The test text

  echo -e "\n                 40m     41m     42m     43m\
       44m     45m     46m     47m";

  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
             '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
             '  36m' '1;36m' '  37m' '1;37m';
    do FG=${FGs// /}
    echo -en " $FGs \033[$FG  $T  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
      do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
    done
    echo;
  done
  echo
}

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

# Setup db first. After thatm setup web application
ENVIRONMENTS="local"
TAGS=""
ASK_PASS=" --ask-pass "
START_AT_TASK=""

function usage()
{
    echo "A simple script to deploy global city forecast to centos 7 server"
    echo ""
    echo "Usage:"
    echo "1) $0 -h"
    echo ""
    echo "2) $0 -e=[hostname]"
    echo ""
    echo "3) $0 -e=[hostname] -t=[tags]"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        -e | --environment)
            ENVIRONMENTS=$VALUE
            ;;
        -a | --ask-pass)
            ASK_PASS=" --ask-pass "
            ;;
        -t | --tags)
            TAGS=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

if [[ $ENVIRONMENTS == "local" ]]; then
  ASK_PASS=""
fi

if [[ -z $TAGS ]] ; then
  for ENVIRONMENT in $ENVIRONMENTS
  do
    greenb "------------------Deploying application for ENVIRONMENT = $ENVIRONMENT------------------";
    greenb "ASK_PASS is $ASK_PASS";

    greenb "Deploying Application. Execute cd ${SCRIPTPATH}/../ && ansible-playbook -vvv $ASK_PASS -i hosts deploy.yml -l $ENVIRONMENT"
    cd ${SCRIPTPATH}/../ && ansible-playbook -vv $ASK_PASS -i hosts deploy.yml -l $ENVIRONMENT
  done
else
  if [[ -z $ENVIRONMENTS ]]; then
    greenb "------------------Deploying application for tags = $TAGS------------------";
    greenb "ASK_PASS is $ASK_PASS";

    greenb "Deploying Application. Execute cd ${SCRIPTPATH}/../ && ansible-playbook -vvv $ASK_PASS -i hosts deploy.yml --tags $TAGS"
    cd ${SCRIPTPATH}/../ && ansible-playbook -vv $ASK_PASS -i hosts deploy.yml --tags $TAGS
  else
    for ENVIRONMENT in $ENVIRONMENTS
    do
      greenb "------------------Deploying application for tags = $TAGS, ENVIRONMENT = $ENVIRONMENT------------------";
      greenb "ASK_PASS is $ASK_PASS";

      greenb "Deploying Application. Execute cd ${SCRIPTPATH}/../ && ansible-playbook -vvv $ASK_PASS -i hosts deploy.yml --tags $TAGS -l $ENVIRONMENT"
      cd ${SCRIPTPATH}/../ && ansible-playbook -vv $ASK_PASS -i hosts deploy.yml --tags $TAGS -l $ENVIRONMENT
    done
  fi
fi
