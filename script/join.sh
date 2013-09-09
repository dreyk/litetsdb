#!/bin/bash
DEST_DIR=$1
echo "Starting"
NODES=`cat script/test-nodes | grep -v '^[[:space:]]*#' | grep -v '^$'`
for cur_node in ${NODES}; do
  echo "starting ${cur_node}"
  ssh etsdb@${cur_node} "${DEST_DIR}/bin/etsdb start"
done
echo "Done"
