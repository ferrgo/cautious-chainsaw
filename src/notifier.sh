#!/bin/sh
. utils/logger.sh

LOG_FILE=.tmpcurl.log

comment_on_mr() {
  RES=$(post_curl)
  if [ "${RES}" != "201" ]; then
    error 106 "Curl failed to post message with code ""${RES}"" " "Payload: ""$(cat ${LOG_FILE})"""
  fi
  log "Message posted" "HTTPCode:""${RES}"" " "Payload:" """$(cat ${LOG_FILE})"""
  rm ${LOG_FILE}
  log "Comment added on MR ""${MR_ID}"""
}

post_curl() {
  curl \
    --request POST \
    --output ${LOG_FILE} \
    -i \
    --header "PRIVATE-TOKEN: ${TOKEN}" \
    "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/merge_requests/${MR_ID}/notes" \
    --data "body=""${COMMENT_MSG}"""
  echo $(cat ${LOG_FILE} | grep HTTP | awk '{print $2}')
}

set_mr_id() {
  if [ -n "${CI_OPEN_MERGE_REQUESTS}" ]; then
    log "Using list of open MR to get id"
    # List such as: 'gitlab-org/gitlab!333,gitlab-org/gitlab-foss!11'
    MR_ID=$(echo "${CI_OPEN_MERGE_REQUESTS}" | awk -F , '{print $1}' | awk -F ! '{print $2}')
  else
    log "Using current MR to get id"
    MR_ID=${CI_MERGE_REQUEST_IID}
  fi
}

check_variables() {
  if [ -z "${TOKEN}" ]; then error 101 "API Token is not set or is blank"; fi
  if [ -z "${CI_API_V4_URL}" ]; then error 102 "API URL is not set or blank"; fi
  if [ -z "${CI_PROJECT_ID}" ]; then error 103 "ProjectID is not set or blank"; fi
  if [ -z "${CI_MERGE_REQUEST_IID}" ] && [ -z "${CI_OPEN_MERGE_REQUESTS}" ]; 
  then 
    error 104 "No Variable for Merge Request ID"; 
  fi
  if [ -z "${COMMENT_MSG}" ]; then error 105 "Message is not set or blank"; fi
}

main() {
  check_variables
  set_mr_id
  log "API: ${CI_API_V4_URL} ProjectID: ${CI_PROJECT_ID} mergeId: ${MR_ID} Message: ${COMMENT_MSG}"
  comment_on_mr
}

main