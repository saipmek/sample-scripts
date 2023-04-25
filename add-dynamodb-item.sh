#!/bin/bash
# Use the following to log in to aws cli
# aws-sso -p np
# aws-sso -p prod

RED="\e[1;31m"
YELLOW="\e[1;32m"
OFF="\e[0m"

export AWS_PAGER=""
# HOST_T0_WHITELIST="abcdef.execute-api.us-east-1.amazonaws.com"
REQUESTER="Requester"
REQUESTING_TEAM="Team Name"
APPROVAL_DATE=`date +%m-%d-%Y`
REASON="Migration"
REQUEST_DATE=`date +%m-%d-%Y`
ENV="prod"

for i in `cat whitelist_items.txt`; do
  HOST_T0_WHITELIST=$i
  # remove any protocol or trailing slash
  HOST_T0_WHITELIST=`printf $HOST_T0_WHITELIST | sed -e "s/^https:\/\///" -e "s/^http:\/\///" -e "s/\/$//"`
  item=$(cat <<EOF
  {
    "_id": {"S": "$HOST_T0_WHITELIST"},
    "approval_date": {"S": "$APPROVAL_DATE"},
    "approver": {"S": "API-Integration-Team"},
    "reason": {"S": "$REASON"},
    "request_date": {"S": "$REQUEST_DATE"},
    "requester": {"S": "$REQUESTER"},
    "requesting_team": {"S": "$REQUESTING_TEAM"}
  }
EOF
  )
  printf "$RED adding $HOST_T0_WHITELIST to host whitelist in $ENV $OFF \n"

  printf "$YELLOW $item $OFF \n"
  aws dynamodb put-item \
  --table-name "whitelisted_hosts" \
  --item "$item" \
  --profile $ENV
done
