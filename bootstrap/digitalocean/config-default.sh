#!/bin/bash
get_lastest_apollo_image_id() {
  api_call() {
    curl -s -X GET -H 'Content-Type: application/json' -H "Authorization: Bearer ${DIGITALOCEAN_API_TOKEN}" "https://api.digitalocean.com/v2/images?private=true"
  }
  return_id_name_table() {
    api_call | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'id'\042/){print $(i+1)"\t"$(i+3)}}}' | tr -d '"' | sed -n p
  }
  return_name_with_apollo_rows() {
    return_id_name_table | grep apollo
  }
  return_ids_column() {
    return_name_with_apollo_rows | awk -F"\t" '{print $1}'
  }
  return_lastest_row() {
    return_ids_column | awk 'END{print}'
  }
  echo $(return_lastest_row)
} 

DIGITALOCEAN_REGION=${DIGITALOCEAN_REGION:-lon1}
DIGITALOCEAN_SSH_PUB_KEY=${DIGITALOCEAN_SSH_KEY:?"Need to set DIGITALOCEAN_SSH_KEY non-empty"}
DIGITALOCEAN_API_TOKEN=${DIGITALOCEAN_API_TOKEN:?"Need to set DIGITALOCEAN_API_TOKEN non-empty"}
DO_CLIENT_ID=${DO_CLIENT_ID:?"Need to set DO_CLIENT_ID non-empty"}
DO_API_KEY=${DO_API_KEY:?"Need to set DO_API_KEY non-empty"}

ATLAS_TOKEN=${ATLAS_TOKEN:?"Need to set ATLAS_TOKEN non-empty"}
ATLAS_INFRASTRUCTURE=${ATLAS_INFRASTRUCTURE:-capgemini/infrastructure}
MASTER_SIZE=${MASTER_SIZE:-512mb}
SLAVE_SIZE=${SLAVE_SIZE:-512mb}
NUM_SLAVES=${NUM_SLAVES:-1}
MASTER_IMAGE=${MASTER_IMAGE:-$(get_lastest_apollo_image_id)}
SLAVE_IMAGE=${SLAVE_IMAGE:-$(get_lastest_apollo_image_id)}
