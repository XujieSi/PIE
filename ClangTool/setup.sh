#!/bin/bash

if [[ $# -ne 3 ]]; then
  echo "Please provide path to LLVM_ROOT and CGROUP_NAME"
  exit 1
fi

OWN_ROOT="`dirname "$0"`"
OWN_ROOT="`cd \"$OWN_ROOT\" && pwd`"

LLVM_ROOT="`cd \"$1\" && pwd`"
ABDUCER_ROOT="`cd ../abducer/ && pwd`"
WORKING_ROOT="`cd ../logs/ || mkdir -p ../logs/ && pwd`"

CGROUP_NAME="$2"
echo "[+] Creating cgroup [$CGROUP_NAME]."
sudo cgcreate -t $USER:$USER -a $USER:$USER -g memory,cpu:$CGROUP_NAME
cgset -r memory.limit_in_bytes=$((8*1024*1024*1024)) $CGROUP_NAME
cgset -r memory.memsw.limit_in_bytes=$((8*1024*1024*1024)) $CGROUP_NAME

cd "$LLVM_ROOT/tools/clang/tools"

NEW_TARGET_LINE="add_subdirectory(pinvgen)"
if [[ "`tail -n 1 < CMakeLists.txt`" != "$NEW_TARGET_LINE" ]]; then
  echo "$NEW_TARGET_LINE" >> CMakeLists.txt
fi

cp -Rf "$OWN_ROOT/pinvgen" .
cd "$LLVM_ROOT" ; mkdir build ; cd build

perl -pe 's#__WORKING_PATH_BASE_FROM_SETUP_SCRIPT__#'"$WORKING_ROOT"'#g' < "$OWN_ROOT/checker.template.sh" > checker
perl -pi -e 's#__ABDUCER_PATH_FROM_SETUP_SCRIPT__#'"$ABDUCER_ROOT"'#g' checker
chmod +x checker

perl -pe 's#__ABDUCER_PATH_FROM_SETUP_SCRIPT__#'"$ABDUCER_ROOT"'#g' < "$OWN_ROOT/check_all.template.sh" > check_all
chmod +x check_all

cmake .. && make -j4 pinvgen
