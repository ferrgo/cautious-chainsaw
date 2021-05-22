#!/bin/sh
. utils/logger.sh

comment_on_mr() {
  RES="$(post_curl)"
  if [ "${RES}" -ne 201 ]; then
    error "Curl failed to post message with code ""${RES}"" \nPayload:\n""$(cat .tmpcurl.log)""" 106
  fi
  log "Message posted \nHTTPCode:""${RES}"" \nPayload:\n""$(cat .tmpcurl.log)"""
  rm .tmpcurl.log
  log "Comment added on MR ""${MR_ID}"""
}

post_curl() {
  return $(curl \
    --request POST \
    --output .tmpcurl.log \
    --silent \
    --header "PRIVATE-TOKEN: ${TOKEN}" \
    --write-out "%{http_code}" \
    "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/merge_requests/${MR_ID}/notes" \
    --data "body=""${COMMENT_MSG}""")
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
  if [ -z "${TOKEN}" ]; then error "API Token is not set or is blank" 101; fi
  if [ -z "${CI_API_V4_URL}" ]; then error "API URL is not set or blank" 102; fi
  if [ -z "${CI_PROJECT_ID}" ]; then error "ProjectID is not set or blank" 103; fi
  if [ -z "${CI_MERGE_REQUEST_IID}" ] && [ -z "${CI_OPEN_MERGE_REQUESTS}" ]; 
  then 
    error "No Variable for Merge Request ID" 104; 
  fi
  if [ -z "${COMMENT_MSG}" ]; then error "Message is not set or blank" 105; fi
}

main() {
  check_variables
  log "API: ${CI_API_V4_URL} ProjectID: ${CI_PROJECT_ID} mergeId: ${MR_ID} Message: ${COMMENT_MSG}"
  set_mr_id
  comment_on_mr
}

main