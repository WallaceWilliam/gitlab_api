#!/bin/sh
# https://docs.gitlab.com/ee/api/groups.html

[ -f "./.env" ] && . "./.env"

GITLAB_API_URL="https://gitlab.com/api/v4"
#GITLAB_TOKEN=""

resp=$(curl -sS -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${GITLAB_API_URL}/user")
echo "${resp}" | jq -e -r "."


