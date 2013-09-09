#!/bin/bash
USER=$1
DEST_DIR=$2
JOIN_TO=$3
echo "Starting"
NODES=`cat script/test-nodes | grep -v '^[[:space:]]*#' | grep -v '^$'`
for cur_node in ${NODES}; do
  echo "starting ${cur_node}"
  ssh ${USER}@${cur_node} "${DEST_DIR}/bin/etsdb-admin cluster join ${JOIN_TO}"
done
echo "Done"
