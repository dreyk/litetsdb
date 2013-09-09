#!/bin/bash

LIST_FILE=$3
DIR_TO_COPY="rel/litetsdb"
PING_COUNT=10
DB_USER=$1
DB_VM=$2
DEST_DIR=$4

error_message()
{
  echo "Error: $1"
  exit 1
}

update_node()
{
  NODE_NAME=$1
  export NODE_NAME

  echo Node: ${NODE_NAME}
  echo -n "Checking... "
  if [ `ping -c ${PING_COUNT} ${NODE_NAME} | grep -c 'bytes from'` -gt 0 ]; then
    echo "OK"
  else
    error_message "Node '${NODE_NAME}' is not reachable"
  fi

  echo -n "Coping... "
  # copy main application
  cd ${DIR_TO_COPY}
  scp -rq * ${DB_USER}@${NODE_NAME}:${DEST_DIR}
  echo "OK"
  ssh ${DB_USER}@${NODE_NAME} mkdir -p tmp
  ( cat <<_EOF_
#!/bin/bash
cd ~/etc
NODE_NAME=$1
DEST_DIR=$2
export NODE_NAME
export DEST_DIR
echo Node address: \${NODE_NAME}
cd ${DEST_DIR}
cp vm.args vm.args.release
sed 's/^-name .*\$/-name ${DB_VM}@'\${NODE_NAME}'/' vm.args.release > vm.args
rm vm.args.release
cd ../
rm -rf ~/tmp/conf_updater.sh
_EOF_
  ) | ssh ${DB_USER}@${NODE_NAME} "cat > ~/tmp/conf_updater.sh"
  ssh ${DB_USER}@${NODE_NAME} "chmod +x ~/tmp/conf_updater.sh; ~/tmp/conf_updater.sh ${NODE_NAME} ${DEST_DIR}"
}

if [ ! -f ${LIST_FILE} ]; then
  error_message "File not found '${LIST_FILE}'!"
fi

NODES=`cat ${LIST_FILE} | grep -v '^[[:space:]]*#' | grep -v '^$'`

for cur_node in ${NODES}; do
  update_node ${cur_node} &
done

wait

echo "+------------------------------------+"
echo "| ~~~=== All nodes updated!!! ===~~~ |"
echo "+------------------------------------+"
