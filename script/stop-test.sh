#!/bin/bash
echo "Starting"
NODES=`cat script/test-nodes | grep -v '^[[:space:]]*#' | grep -v '^$'`
for cur_node in ${NODES}; do
  echo "stoping ${cur_node}"
  ssh etsdb@${cur_node} "bin/etsdb stop"
done
echo "Done"