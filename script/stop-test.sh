#!/bin/bash
USER=$1
DEST_DIR=$2
echo "Stoping"
NODES=`cat script/test-nodes | grep -v '^[[:space:]]*#' | grep -v '^$'`
for cur_node in ${NODES}; do
  echo "stoping ${cur_node}"
  ssh ${USER}@${cur_node} "${DEST_DIR}/bin/etsdb stop"
done
echo "Done"
