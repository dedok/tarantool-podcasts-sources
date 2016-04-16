#!/bin/bash
METHOD=$1
PARAMS=$2
wget localhost:8081/tnt \
  --post-data "{\"method\": \"$METHOD\", \"params\": $PARAMS, \"id\": 0}"
cat tnt && rm tnt
