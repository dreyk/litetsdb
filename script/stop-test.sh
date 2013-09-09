#!/bin/bash
DEST_DIR=$1
TO_JOIN=$2
echo "Starting"
NODES=`cat script/test-nodes | grep -v '^[[:space:]]*#' | grep -v '^$'`
for cur_node in ${NODES}; do
  echo "stoping ${cur_node}"
  ssh etsdb@${cur_node} "${DEST_DIR}/bin/etsdb-admin cluster join ${TO_JOIN}"
done
echo "Done"