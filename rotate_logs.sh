#!/bin/bash
CONFIG_PATH=config_file/rotate.config

function usage {
    cat <<EOF
$(basename ${0}) is a tool for rotate *.log files.

Usage:
  $(basename ${0}) [command] ([options])

options:
  --rotate-path <path> set rotate target path
  --config-path <path> set config file path

commands:
  [no commands]: display usage or display
  all: rotate all (.log) files ignoring target_files which are written in config file.
  targets: rotate only target_files (.log) files which are written in config file.
EOF
}

function read_config_file {
  # check config file
  if [ ! -f ${CONFIG_PATH} ]; then
    echo '[ERROR] Config file does not exist. Please copy config file under config_file folder or use option --config-path.'
    exit 1
  fi
  # read config file
  source ${CONFIG_PATH}

  # overwrite paramaters
  if [ ! -n ${TMP_ROTATE_PATH} ]; then
    ROTATE_PATH=${TMP_ROTATE_PATH}
  fi

  # validate paramaters
  if [ ! -n ${RETENTION_PERIOD} ]; then
    echo '[ERROR] Could not find retention period. Please set RETENTION_PERIOD.'
    exit 1
  fi
  expr "${RETENTION_PERIOD}" + 1 >/dev/null 2>&1
  if [ ${?} -lt 2 ]; then
    if [ ${RETENTION_PERIOD} -lt 1 ] && [ ${RETENTION_PERIOD} -gt 365 ]; then
      echo '[ERROR] Please set RETENTION_PERIOD from 1 ~ 365.'
      exit 1
    fi
  else
    echo '[ERROR] Please set numeric RETENTION_PERIOD.'
    exit 1
  fi
  if [ ! -n ${ROTATE_PATH} ]; then
    echo '[ERROR] Could not find rotate path. Please set ROTATE_PATH or use --rotate-path option.'
    exit 1
  fi
  if [ ! -n ${1} ]; then
    if [ ${1} -eq "targets" ] && [ ! -n ${TARGET_FILES} ]; then
      echo '[ERROR] Could not find target files. Please set TARGET_FILES.'
      exit 1
    fi
  fi
}

function rename_as_archive {
  find ${ROTATE_PATH} -name ${1} | xargs -t -I{} mv {} {}.`date "+%Y%m%d"`
}

function remove_expired_file {
  find ${ROTATE_PATH} -mtime +$(( $RETENTION_PERIOD-1 )) -name ${1}.* | xargs rm
}

function all {
  read_config_file
  rename_as_archive *.log
  remove_expired_file *.log
}

function targets {
  read_config_file targets
  for target_file in `echo "$TARGET_FILES" | tr "," "\n"`
  do
    rename_as_archive ${target_file}
    remove_expired_file ${target_file}
  done
}

COMMANDS=${1}
while [ $# -gt 0 ];
do
  case ${1} in
    --rotate-path)
      TMP_ROTATE_PATH=${2}
      shift
    ;;

    --config-path)
      TMP_CONFIG_PATH=${2}
      shift
    ;;
  esac
  shift
done

case ${COMMANDS} in
  all)
    all
  ;;

  targets)
    targets
  ;;

  *)
    usage
    exit 1
  ;;
esac
