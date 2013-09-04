#!/bin/bash
echo "Starting"
NODES=`cat script/test-nodes | grep -v '^[[:space:]]*#' | grep -v '^$'`
for cur_node in ${NODES}; do
  echo "starting ${cur_node}"
  ssh etsdb@${cur_node} "bin/etsdb start"
done
echo "Done"
