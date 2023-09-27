#!/bin/sh
# https://docs.gitlab.com/ee/api/groups.html

[ -f "./.env" ] && . "./.env"

GITLAB_API_URL="https://gitlab.com/api/v4"
GITLAB_TOKEN=""
PROJECT="project"

PROJECT_ENC="$(echo -n ${PROJECT} | jq -sRr @uri)"

USER_ID=6608574

group_members(){
    enc="$(echo -n ${1} | jq -sRr @uri)"
    resp=$(curl -sS -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${GITLAB_API_URL}/groups/${enc}/members/${USER_ID}")
#    echo "$resp" | jq -e -r ".[].username"
    echo "$resp" | jq -e -r ".access_level"
}

project_members(){
    enc="$(echo -n ${1} | jq -sRr @uri)"
    resp=$(curl -sS -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${GITLAB_API_URL}/projects/${enc}/members/${USER_ID}")
#    echo "$resp" | jq -e -r ".[].username"
    echo "$resp" | jq -e -r ".access_level"
}

echo ${PROJECT}
group_members ${PROJECT}

# list
echo list subgroups

resp=$(curl -sS -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${GITLAB_API_URL}/groups/${PROJECT_ENC}/subgroups?simple=yes&per_page=100")
groups=$(echo "${resp}" | jq -e -r ".[] ")
for group in $(echo "${groups}" | jq -e -r ".full_path"); do
    echo group ${group}
    group_members ${group}
    enc="$(echo -n ${group} | jq -sRr @uri)"
    resp=$(curl -sS -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${GITLAB_API_URL}/groups/${enc}/projects?per_page=100&simple=yes&archived=no")
    projects=$(echo "${resp}" | jq -e -r ".[]")
    for project in $(echo "${projects}" | jq -e -r ".path_with_namespace"); do
        echo project ${project}
        project_members ${project}
    done
done

exit 0

